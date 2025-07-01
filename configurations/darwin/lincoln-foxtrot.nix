{ ... }:

{
  imports = [ ./default.nix ];

  # Don't enable management of nix installation as this machine uses determinate
  nix.enable = false;

  networking.hostName = "lincoln-foxtrot";
}
