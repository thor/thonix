{
  config,
  pkgs,
  inputs,
  ...
}:

{
  # nix packages
  environment.systemPackages = [
    # source control
    pkgs.git
    # communication tool
    pkgs.slack
  ];

  # brew formulae and casks
  homebrew.casks = [
    "linear-linear"
  ];

  system.defaults = {
    dock.persistent-apps = [
      "/Applications/Slack.app"
    ];
  };
}
