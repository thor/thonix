{
  pkgs,
  ...
}:

{
  # I need unfree packages to work with work
  nixpkgs.config.allowUnfree = true;

  # nix packages
  environment.systemPackages = with pkgs; [
    # source control
    git
    github-cli
    # communication tool
    slack
    # yummy python
    pipx
    # general good infra stuff
    terraform
    terraform-lsp
    terraform-docs
    # grafana stack tools
    grafana-loki
    grafana-alloy
    grizzly
    # mandatory google
    google-cloud-sdk
    google-cloud-sql-proxy
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
