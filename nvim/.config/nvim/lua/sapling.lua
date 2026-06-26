-- Sapling (sl) integration for Neovim.
--
-- gitsigns.nvim deliberately does not support Sapling, so this module provides
-- an equivalent experience for `.sl` repos via mini.diff:
--   * `M.source`      - a mini.diff source that supplies reference text from
--                       `sl cat`, so add/change/delete hunks render in the sign
--                       column (mini.diff stays detached outside Sapling repos).
--   * `M.setup_blame` - an inline `sl blame` current-line annotation that
--                       approximates gitsigns' `current_line_blame`.
--
-- See: https://github.com/lewis6991/gitsigns.nvim/issues/1063

local M = {}

local uv = vim.uv or vim.loop

-- Per-buffer state, keyed by buffer id:
--   { root, file, watcher, blame = { lines = {ref_line -> entry}, desc = {node -> summary} } }
local state = {}

local blame_ns = vim.api.nvim_create_namespace("sapling_blame")

-- Cooldown (ms) before the blame annotation appears on an idle line, matching
-- gitsigns' `current_line_blame_opts.delay`. Overridable via `setup_blame`.
local blame_delay = 1000
local blame_timer

-- Return the root of the Sapling repo containing `path`, or nil if there is none.
local function sapling_root(path)
	if not path or path == "" then
		return nil
	end
	local found = vim.fs.find(".sl", { path = path, upward = true, type = "directory" })
	if not found[1] then
		return nil
	end
	return vim.fs.dirname(found[1])
end

-- The on-disk path backing a buffer, or nil for unnamed/special buffers.
local function buf_path(buf_id)
	if vim.bo[buf_id].buftype ~= "" then
		return nil
	end
	local name = vim.api.nvim_buf_get_name(buf_id)
	if name == "" then
		return nil
	end
	return name
end

-- ---------------------------------------------------------------------------
-- mini.diff source: reference text from `sl cat -r .`
-- ---------------------------------------------------------------------------

local function set_ref(buf_id)
	local st = state[buf_id]
	if not st then
		return
	end
	vim.system(
		{ "sl", "cat", "-r", ".", st.file },
		{ cwd = st.root, text = true },
		vim.schedule_wrap(function(out)
			if not (state[buf_id] and vim.api.nvim_buf_is_valid(buf_id)) then
				return
			end
			-- On a non-zero exit the file is untracked/new at the parent commit;
			-- an empty reference makes mini.diff render the whole buffer as added.
			require("mini.diff").set_ref_text(buf_id, out.code == 0 and out.stdout or "")
		end)
	)
end

local function teardown(buf_id)
	local st = state[buf_id]
	if st and st.watcher then
		st.watcher:stop()
		st.watcher:close()
	end
	state[buf_id] = nil
end

M.source = {
	name = "sapling",
	attach = function(buf_id)
		local path = buf_path(buf_id)
		if not path then
			return false
		end
		local root = sapling_root(vim.fs.dirname(path))
		if not root then
			-- Not a Sapling buffer: mini.diff stays detached here.
			return false
		end

		teardown(buf_id)
		state[buf_id] = { root = root, file = path, blame = { lines = {}, desc = {} } }

		set_ref(buf_id)
		M.refresh_blame(buf_id)

		-- Reference text only changes on commit/amend/goto, which all rewrite
		-- `.sl/dirstate`. Watch it (debounced) to refresh signs and blame, the
		-- same way mini.diff's git source watches `.git/index`.
		local watcher = uv.new_fs_event()
		if watcher then
			state[buf_id].watcher = watcher
			local timer
			watcher:start(root .. "/.sl/dirstate", {}, function()
				if timer then
					timer:stop()
					timer:close()
				end
				timer = uv.new_timer()
				timer:start(150, 0, function()
					timer:stop()
					timer:close()
					timer = nil
					vim.schedule(function()
						if state[buf_id] and vim.api.nvim_buf_is_valid(buf_id) then
							set_ref(buf_id)
							M.refresh_blame(buf_id)
						end
					end)
				end)
			end)
		end

		return true
	end,
	detach = function(buf_id)
		teardown(buf_id)
	end,
	-- No `apply_hunks`: Sapling has no staging area, so mini.diff's "apply"
	-- operation is intentionally unavailable. Hunk preview/reset/navigation all
	-- still work since they operate on buffer text + reference text.
}

-- ---------------------------------------------------------------------------
-- Inline blame: `sl blame` annotation on the current line
-- ---------------------------------------------------------------------------

-- A short, human-friendly age such as "3d ago" from a unix timestamp.
function M.relative_time(ts)
	if not ts then
		return nil
	end
	local diff = os.time() - ts
	if diff < 60 then
		return "just now"
	end
	diff = diff / 60
	if diff < 60 then
		return string.format("%dm ago", diff)
	end
	diff = diff / 60
	if diff < 24 then
		return string.format("%dh ago", diff)
	end
	diff = diff / 24
	if diff < 7 then
		return string.format("%dd ago", diff)
	end
	if diff < 30 then
		return string.format("%dw ago", diff / 7)
	end
	if diff < 365 then
		return string.format("%dmo ago", diff / 30)
	end
	return string.format("%dy ago", diff / 365)
end

-- Map a 1-indexed buffer line to its committed (reference) line number using
-- mini.diff's hunks, or nil when the line is added/changed (no committed source).
local function buf_to_ref_line(buf_id, lnum)
	local data = require("mini.diff").get_buf_data(buf_id)
	if not data or not data.hunks then
		return lnum
	end
	local offset = 0
	for _, h in ipairs(data.hunks) do
		local last_buf_line = (h.buf_count > 0) and (h.buf_start + h.buf_count - 1) or h.buf_start
		if h.buf_count > 0 and lnum >= h.buf_start and lnum <= last_buf_line then
			-- Cursor sits on an added/changed line: nothing committed to blame.
			return nil
		elseif last_buf_line < lnum then
			offset = offset + (h.buf_count - h.ref_count)
		end
	end
	return lnum - offset
end

-- Render the blame annotation for the current line of `buf_id` (if focused).
function M.render_blame(buf_id)
	if not (state[buf_id] and vim.api.nvim_buf_is_valid(buf_id)) then
		return
	end
	vim.api.nvim_buf_clear_namespace(buf_id, blame_ns, 0, -1)
	if vim.api.nvim_get_current_buf() ~= buf_id then
		return
	end

	local lnum = vim.api.nvim_win_get_cursor(0)[1]
	local ref = buf_to_ref_line(buf_id, lnum)
	if not ref then
		return
	end
	local entry = state[buf_id].blame.lines[ref]
	if not entry then
		return
	end

	-- Strip "<email>" to keep the annotation compact.
	local author = (entry.user or ""):gsub("%s*<.*>%s*$", "")
	local parts = { author }
	local rel = M.relative_time(entry.date)
	if rel then
		parts[#parts + 1] = rel
	end
	local summary = entry.node and state[buf_id].blame.desc[entry.node]
	if summary then
		parts[#parts + 1] = summary
	end

	vim.api.nvim_buf_set_extmark(buf_id, blame_ns, lnum - 1, 0, {
		-- Reuse gitsigns' own blame highlight so the two VCS look identical.
		virt_text = { { "  " .. table.concat(parts, " · "), "GitSignsCurrentLineBlame" } },
		virt_text_pos = "eol",
		hl_mode = "combine",
	})
end

-- Hide any current annotation immediately, then re-render the current line only
-- once the cursor has been idle for `blame_delay` ms (debounced, gitsigns-style).
function M.schedule_blame(buf_id)
	if not (state[buf_id] and vim.api.nvim_buf_is_valid(buf_id)) then
		return
	end
	vim.api.nvim_buf_clear_namespace(buf_id, blame_ns, 0, -1)
	if not blame_timer then
		blame_timer = assert((vim.uv or vim.loop).new_timer())
	end
	blame_timer:stop()
	blame_timer:start(
		blame_delay,
		0,
		vim.schedule_wrap(function()
			if state[buf_id] and vim.api.nvim_get_current_buf() == buf_id then
				M.render_blame(buf_id)
			end
		end)
	)
end

-- Re-run `sl blame` for a buffer, cache per-line authorship + commit summaries,
-- then re-render. Blame is always against the committed parent (`-r .`); Sapling
-- cannot blame the dirty working copy, hence the buf->ref line mapping above.
function M.refresh_blame(buf_id)
	local st = state[buf_id]
	if not st then
		return
	end
	vim.system(
		{ "sl", "blame", "-r", ".", "-T", "json", "--user", "--date", "--changeset", st.file },
		{ cwd = st.root, text = true },
		vim.schedule_wrap(function(out)
			if not (state[buf_id] and vim.api.nvim_buf_is_valid(buf_id)) then
				return
			end

			local ok, decoded = pcall(vim.json.decode, out.stdout or "")
			local lines = {}
			if ok and decoded and decoded[1] and decoded[1].lines then
				for i, l in ipairs(decoded[1].lines) do
					lines[i] = { user = l.user, date = l.date and l.date[1], node = l.node }
				end
			end
			state[buf_id].blame.lines = lines

			-- Commit summaries are not in blame output; batch-fetch the ones we
			-- have not seen yet in a single `sl log` call, then render.
			local want, seen = {}, {}
			for _, e in pairs(lines) do
				if e.node and not state[buf_id].blame.desc[e.node] and not seen[e.node] then
					seen[e.node] = true
					want[#want + 1] = e.node
				end
			end
			if #want == 0 then
				M.schedule_blame(buf_id)
				return
			end
			vim.system(
				{ "sl", "log", "-r", table.concat(want, "+"), "-T", "json" },
				{ cwd = st.root, text = true },
				vim.schedule_wrap(function(lout)
					if not (state[buf_id] and vim.api.nvim_buf_is_valid(buf_id)) then
						return
					end
					local lok, ldec = pcall(vim.json.decode, lout.stdout or "")
					if lok and ldec then
						for _, c in ipairs(ldec) do
							if c.node and c.desc then
								state[buf_id].blame.desc[c.node] = vim.split(c.desc, "\n")[1]
							end
						end
					end
					M.schedule_blame(buf_id)
				end)
			)
		end)
	)
end

-- Wire up the autocmds that drive the inline blame annotation.
-- `opts.delay` overrides the idle cooldown (ms) before blame appears.
function M.setup_blame(opts)
	if opts and opts.delay then
		blame_delay = opts.delay
	end
	local group = vim.api.nvim_create_augroup("SaplingBlame", { clear = true })
	vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "BufEnter" }, {
		group = group,
		callback = function(args)
			if state[args.buf] then
				M.schedule_blame(args.buf)
			end
		end,
	})
	vim.api.nvim_create_autocmd("BufLeave", {
		group = group,
		callback = function(args)
			if state[args.buf] and vim.api.nvim_buf_is_valid(args.buf) then
				vim.api.nvim_buf_clear_namespace(args.buf, blame_ns, 0, -1)
			end
		end,
	})
	vim.api.nvim_create_autocmd("BufWritePost", {
		group = group,
		callback = function(args)
			if state[args.buf] then
				M.refresh_blame(args.buf)
			end
		end,
	})
end

-- ---------------------------------------------------------------------------
-- nvim-scrollview: mirror mini.diff hunks into the scrollbar
-- ---------------------------------------------------------------------------

-- Show add/change/delete hunks as marks on the scrollbar, the same way gitsigns
-- hunks can appear there. No-op if nvim-scrollview is not installed.
function M.setup_scrollview()
	local ok, scrollview = pcall(require, "scrollview")
	if not ok then
		return
	end

	local group = "sapling_diff"
	scrollview.register_sign_group(group)

	-- One spec per hunk type, colored with mini.diff's own sign highlights.
	local names = {}
	for _, item in ipairs({
		{ type = "add", hl = "MiniDiffSignAdd" },
		{ type = "change", hl = "MiniDiffSignChange" },
		{ type = "delete", hl = "MiniDiffSignDelete" },
	}) do
		names[item.type] = scrollview
			.register_sign_spec({ group = group, highlight = item.hl, symbol = "┃", variant = item.type })
			.name
	end

	-- Recompute the marked lines for every eligible window on each refresh.
	scrollview.set_sign_group_callback(group, function()
		local MiniDiff = require("mini.diff")
		for _, winid in ipairs(scrollview.get_sign_eligible_windows()) do
			local bufnr = vim.api.nvim_win_get_buf(winid)
			local lines = { add = {}, change = {}, delete = {} }
			local data = MiniDiff.get_buf_data(bufnr)
			if data and data.hunks then
				for _, h in ipairs(data.hunks) do
					local bucket = lines[h.type]
					if bucket then
						if h.buf_count > 0 then
							for l = h.buf_start, h.buf_start + h.buf_count - 1 do
								bucket[#bucket + 1] = l
							end
						else
							-- Pure deletion sits between buffer lines; mark the line above.
							bucket[#bucket + 1] = math.max(h.buf_start, 1)
						end
					end
				end
			end
			for t, name in pairs(names) do
				vim.b[bufnr][name] = lines[t]
			end
		end
	end)

	scrollview.set_sign_group_state(group, true)

	-- mini.diff fires this (buffer-local) after recomputing hunks.
	vim.api.nvim_create_autocmd("User", {
		group = vim.api.nvim_create_augroup("SaplingScrollview", { clear = true }),
		pattern = "MiniDiffUpdated",
		callback = function()
			if scrollview.is_sign_group_active(group) then
				scrollview.refresh()
			end
		end,
	})
end

return M
