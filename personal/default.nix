{ pkgs, ... }:
let
  corePackages = with pkgs; [
    # core utilities
    bat # bats are better than cats
    thefuck # fuck
    fzf # selector from heaven
    fd # file finder
    ripgrep # fast searcher
    neovim # the best vim
    vscode # visual goto
    tmux # screen replacement
    # dotfile manager I could get rid of in the long run
    rcm
    sheldon # source and fetch zsh plugins
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
    # python
    python3 # don't pretend python 2 is getting anywhere near close
    # rust
    rustc # toolchain
    cargo # tools for power
    # go
    go
    # git and stuff
    git # source control
    gh # github
  ];
in
{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    corePackages
    ++ development
    ++ [
    ];

  homebrew.casks = [
    "todoist"
    "messenger" # facebook messenger
  ];

  imports = [
    ./brew.nix
    ./system.nix
    ./ux.nix
  ];
}
