{ ... }:
{
  # Enable dnsmasq for local development
  services.dnsmasq = {
    enable = true;
    addresses = {
      ".internal" = "127.0.0.1";
    };
    port = 5553;
  };
}
