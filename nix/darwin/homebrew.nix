_: {
  homebrew = {
    enable = true;

    global.autoUpdate = false;
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "none";
    };

    taps = [ "restatedev/tap" ];

    brews = [
      "restatedev/tap/restate"
      "restatedev/tap/restate-server"
      "restatedev/tap/restatectl"
      "sapling"
    ];
  };
}
