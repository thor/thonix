{ lib, pkgs, ... }:
{
  # Enable dnsmasq for local development
  services.dnsmasq = {
    enable = true;
    addresses = {
      "internal" = "127.0.0.1";
    };
    port = 5553;
  };

  # macOS uses /etc/resolver/<domain> files for per-domain DNS servers.
  # This is for local testing where I point it to external addresses, too.
  environment.etc = lib.mkIf pkgs.stdenv.isDarwin {
    "resolver/test".text = ''
      nameserver 127.0.0.1
      port 5554
    '';
  };
}
