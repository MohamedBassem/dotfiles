function custom_fish_cancel_commandline
    echo -sn $__fish_cancel_text
    commandline -C 10000000
    printf (string repeat -n (commandline -L) "\n")
    commandline ""
    emit fish_cancel
    commandline -f cancel -f repaint
end
