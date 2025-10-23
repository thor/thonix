{ pkgs, lib, ... }:
let
  inherit (lib) mkIf;
  inherit (pkgs.stdenv) isDarwin;
  corePackages = with pkgs; [
    # core utilities
    bat # bats are better than cats
    delta # pretty good looking diffs
    pay-respects # fuck with suggestions
    eza # ls replacement
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
    nix-index # local database
  ];
  development = with pkgs; [
    # not really development, but ansible will do, too
    # Disabled due to NixOS/nixpkgs#400373
    # ansible
    # NOTE: this isn't the nix way, but I'm not handling nvim with nix quite yet
    cmake
    protobuf # protobuf
    watch # not the best, but need it
    # environments and stuff
    direnv
    # FIXME: nobody wants to use this if you could use nix
    mise
    # js
    nodejs
    pnpm
    # python
    python3 # don't pretend python 2 is getting anywhere near close
    uv
    # go
    go
    # git and stuff
    git # source control
    jujutsu # source control, but different
    gnupg # signature verifications
    watchman # jujutsu: helpful file monitor
    jjui # delicious
    gh # github
    lazygit # tui for git
    # network and fun
    cloudflared
  ];
  services = with pkgs; [
    rbw # bitwarden cli client
    pinentry_mac # runtime dependency of rbw
    maestral # files, I need them
    discord # ooof not actually irc
    # steam # some entertainment necessary
  ];
in
{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = corePackages ++ development ++ services;

  # Enable beautiful direnv
  programs.direnv.enable = true;

  homebrew.brews = mkIf isDarwin [
    "ansible" # temporarily while broken see NixOS/nixpkgs#400373
    "winetricks" # wine baby
  ];

  homebrew.casks = mkIf isDarwin [
    "iterm2" # terminal emulator
    "google-chrome" # browser most of the time
    "todoist-app" # tasks
    "messenger" # facebook messenger
    "chatgpt" # just another llm
    "anki" # how to learn
    "wifiman" # handy to get home
    "remarkable" # access to the tablet
    "nordvpn" # it is what it is
    "parallels" # virtual machines
    "wine@staging" # wine baby
    "steam" # some entertainment, yeah?
    "calibre" # books god damn
    "obsidian" # notes to replace dendron
  ];

  imports = [
    ./brew.nix
    ./llm.nix
    ./system.nix
    ./ux.nix
    ./rust.nix
  ];
}
