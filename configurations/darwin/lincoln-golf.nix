{ ... }:

{
  imports = [ ./default.nix ];

  networking.hostName = "lincoln-golf";

  nix.linux-builder.enable = true;

  nix.settings.trusted-users = [ "root" "@wheel" "@admin" ];

  custom.keyboard.layout = ./resources/NorwegianTvorak.bundle;
}
