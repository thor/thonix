{ ... }:

{
  imports = [ ./default.nix ];

  networking.hostName = "lincoln-hotel";

  # Don't enable management of nix installation as this machine uses determinate
  nix.enable = false;
  nix.linux-builder.enable = false;

  nix.settings.trusted-users = [ "root" "@wheel" "@admin" ];
}
