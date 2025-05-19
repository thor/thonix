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
    jsonnet
    jsonnet-bundler
    jsonnet-language-server
    tanka
    # workflows
    argo
    # mandatory google
    (google-cloud-sdk.withExtraComponents (
      with google-cloud-sdk.components; [ gke-gcloud-auth-plugin ]
    ))
    google-cloud-sql-proxy
  ];

  # Enable beautiful direnv
  programs.direnv.enable = true;

  # brew brews and casks
  homebrew.brews = [
    "podman"
    "podman-compose"
    "docker"
    "docker-compose"
    "helm"
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
