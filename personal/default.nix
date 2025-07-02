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
  ];
  development = with pkgs; [
    # not really development, but ansible will do, too
    # Disabled due to NixOS/nixpkgs#400373
    # ansible
    ansible-language-server
    # NOTE: this isn't the nix way, but I'm not handling nvim with nix quite yet
    cmake
    protobuf # protobuf
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
    gh # github
    lazygit # tui for git
    # network and fun
    cloudflared
  ];
  services = with pkgs; [
    maestral # files, I need them
    discord # ooof not actually irc
  ];
  llm = with pkgs; [
    gemini-cli # open source cli with gemini access and mcp
  ];
in
{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = corePackages ++ development ++ services ++ llm;

  # Enable beautiful direnv
  programs.direnv.enable = true;

  homebrew.brews = mkIf isDarwin [
    "ansible" # temporarily while broken see NixOS/nixpkgs#400373
  ];

  homebrew.casks = mkIf isDarwin [
    "iterm2" # terminal emulator
    "google-chrome" # browser most of the time
    "todoist" # tasks
    "todoist-app" # tasks
    "messenger" # facebook messenger
    "chatgpt" # just another llm
    "anki" # how to learn
    "wifiman" # handy to get home
    "remarkable" # access to the tablet
    "nordvpn" # it is what it is
    "parallels" # virtual machines
  ];

  imports = [
    ./brew.nix
    ./system.nix
    ./ux.nix
    ./rust.nix
  ];
}
