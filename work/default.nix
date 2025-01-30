{ config, pkgs, ... }:
{
  environment.systemPackages = [
    # source control
    pkgs.git
    # communication tool
    pkgs.slack
  ];

  system.defaults = {
    dock.persistent-apps = [
      "/Applications/Slack.app"
    ];
  };
}
