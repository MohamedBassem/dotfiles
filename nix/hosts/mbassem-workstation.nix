{ pkgs, ... }:
{
  home.packages = with pkgs; [
    kubectl
    lnav
    lsof
    obsidian-headless
    sysbench
    watchman
  ];

  systemd.user.services = {
    obsidian-sync = {
      Unit = {
        Description = "Obsidian continuous sync for MainVault";
        Documentation = "https://obsidian.md/help/sync/headless";
      };

      Service = {
        Type = "simple";
        WorkingDirectory = "%h/vaults/MainVault";
        ExecStart = "${pkgs.obsidian-headless}/bin/ob sync --path %h/vaults/MainVault --continuous";
        Restart = "always";
        RestartSec = "5s";
        TimeoutStopSec = "20s";
      };

      Install.WantedBy = [ "default.target" ];
    };

    t3code = {
      Unit = {
        Description = "T3 Code server";
        StartLimitIntervalSec = 300;
        StartLimitBurst = 5;
      };

      Service = {
        Type = "simple";
        WorkingDirectory = "%h";
        Environment = [
          "T3CODE_HOME=%h/.t3"
          "T3_BOOT_SERVICE_UNIT=t3code.service"
          "T3CODE_HOST=0.0.0.0"
        ];
        ExecStart = "${pkgs.nodejs}/bin/node %h/.t3/runtime/service-launcher.mjs";
        KillMode = "mixed";
        OOMPolicy = "continue";
        Restart = "always";
        RestartSec = 5;
        StandardOutput = "append:%h/.t3/userdata/logs/boot-service.log";
        StandardError = "append:%h/.t3/userdata/logs/boot-service.log";
      };

      Install.WantedBy = [ "default.target" ];
    };
  };
}
