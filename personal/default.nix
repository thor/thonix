{ pkgs, ... }:
let
  corePackages = with pkgs; [
    # core utilities
    bat # bats are better than cats
    thefuck # fuck
    fzf # selector from heaven
    fd # file finder
    parallel # run in parallel
    ripgrep # fast searcher
    neovim # the best vim
    vscode # visual goto
    tmux # screen replacement
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
    rustc # toolchain
    cargo # tools for power
    # go
    go
    # git and stuff
    git # source control
    gh # github
    lazygit # tui for git
  ];
  services = with pkgs; [
    maestral # files, I need them
  ];
in
{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = corePackages ++ development ++ services;

  homebrew.casks = [
    "todoist" # tasks
    "messenger" # facebook messenger
    "chatgpt" # just another llm
    "anki" # how to learn
  ];

  # pin some apps
  system.defaults = {
    dock.persistent-apps = [
      "/Applications/Todoist.app"
      "/Applications/Messenger.app"
    ];
  };

  imports = [
    ./brew.nix
    ./system.nix
    ./ux.nix
  ];
}
