{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin;
  primary = config.system.primaryUser;
  # Editable overrides: dnsmasq format, one entry per line, e.g. address=/my.dev/127.0.0.1
  userAddressesConf = "/Users/${primary}/.config/dnsmasq/dev-adresses.conf";
  dnsmasqDeveloperConf = pkgs.writeText "dnsmasq-development.conf" ''
    no-resolv
    port=5554
    listen-address=127.0.0.1
    conf-file=${userAddressesConf}
  '';
in
{
  # Enable dnsmasq for local development (system instance; provides the shared package).
  services.dnsmasq = {
    enable = true;
    addresses = {
      "internal" = "127.0.0.1";
    };
    port = 5553;
  };

  # macOS uses /etc/resolver/<domain> files for per-domain DNS servers.
  # This is for local testing where I point it to external addresses, too.
  environment.etc = lib.mkIf isDarwin {
    "resolver/test".text = ''
      nameserver 127.0.0.1
      port 5554
    '';
  };

  launchd.user.agents.dnsmasq-developer = lib.mkIf isDarwin {
    command = "${config.services.dnsmasq.package}/bin/dnsmasq --keep-in-foreground --conf-file=${dnsmasqDeveloperConf}";
    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
    };
  };
}
