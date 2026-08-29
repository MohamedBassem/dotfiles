{ ... }:
{
  homebrew = {
    enable = true;

    global.autoUpdate = false;
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "none";
    };

    taps = [
      "anomalyco/tap"
      "modem-dev/tap"
      "restatedev/tap"
    ];

    brews = [
      "anomalyco/tap/opencode"
      "herdr"
      "modem-dev/tap/hunk"
      "nixpacks"
      "restatedev/tap/restate"
      "restatedev/tap/restate-server"
      "restatedev/tap/restatectl"
      "sapling"
      "serpl"
    ];
  };
}
