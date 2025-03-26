{ pkgs, lib, ... }:
let
  inherit (lib) mkIf;
  inherit (pkgs.stdenv) isDarwin;
  corePackages = with pkgs; [
    # core utilities
    bat # bats are better than cats
    delta # pretty good looking diffs
    thefuck # fuck
    fzf # selector from heaven
    fd # file finder
    parallel # run in parallel
    ripgrep # fast searcher
    neovim # the best vim
    vscode # visual goto
    tmux # screen replacement
    # web and stuff
    httpie
    mtr
    # dotfile manager I could get rid of in the long run
    rcm
    sheldon # source and fetch zsh plugins
    # archives
    keka
    # nix
    nix-search-cli # better search
    nixd # beautiful linking
    nixfmt-rfc-style # formatting for nixd
  ];
  development = with pkgs; [
    # NOTE: this isn't the nix way, but I'm not handling nvim with nix quite yet
    cmake
    protobuf # protobuf
    # environments and stuff
    direnv
    # FIXME: nobody wants to use this if you could use nix
    mise
    # js
    nodejs
    # python
    python3 # don't pretend python 2 is getting anywhere near close
    uv
    # rust
    rustup
    # go
    go
    # git and stuff
    git # source control
    gh # github
    lazygit # tui for git
  ];
  services = with pkgs; [
    maestral # files, I need them
    discord # ooof not actually irc
  ];
in
{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = corePackages ++ development ++ services;

  # Enable beautiful direnv
  programs.direnv.enable = true;

  homebrew.casks = mkIf isDarwin [
    "todoist" # tasks
    "messenger" # facebook messenger
    "chatgpt" # just another llm
    "anki" # how to learn
    "wifiman" # handy to get home
    "remarkable" # access to the tablet
    "nordvpn" # it is what it is
  ];

  # pin some apps
  system.defaults = mkIf isDarwin {
    dock.persistent-apps = [
      "/Applications/Todoist.app"
      "/Applications/Messenger.app"
    ];
  };

  imports = [
    ./brew.nix
    ./system.nix
    ./ux.nix
    ./dev.nix
  ];
}
