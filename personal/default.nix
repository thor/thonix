{ config, pkgs, ... }:
let
  corePackages = with pkgs; [
    # core utilities
    bat # bats are better than cats
    fzf # selector from heaven
    fd # file finder
    ripgrep # fast searcher
    git # source control
    neovim # the best vim
    vscode # visual goto
    tmux # screen replacement
  ];
  languages = with pkgs; [
    python3
    rustc
    cargo
    go
  ];
in
{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    corePackages
    ++ languages
    ++ [
      # dotfile manager I could get rid of in the long run
      pkgs.rcm
    ];

  imports = [
    ./system.nix
    ./ux.nix
  ];
}
