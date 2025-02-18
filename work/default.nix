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
    kubectl
    kubectl-explore
    kubectx
    k9s
    k3d
    kind
    terraform
    terraform-lsp
    terraform-docs
    # grafana stack tools
    grafana-loki
    grafana-alloy
    grizzly
    # workflows
    argo
    # mandatory google
    (google-cloud-sdk.withExtraComponents (
      with google-cloud-sdk.components; [ gke-gcloud-auth-plugin ]
    ))
    google-cloud-sql-proxy
  ];

  # brew brews and casks
  homebrew.brews = [
    "podman"
    "podman-compose"
    "docker"
    "docker-compose"
  ];
  homebrew.casks = [
    "linear-linear"
    "podman-desktop"
  ];

  system.defaults = {
    dock.persistent-apps = [
      "/Applications/Slack.app"
      "/Applications/Linear.app"
    ];
  };
}
