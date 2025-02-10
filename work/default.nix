{
  pkgs,
  ...
}:

{
  # nix packages
  environment.systemPackages = with pkgs; [
    # source control
    git
    # communication tool
    slack
    # yummy python
    pipx
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
