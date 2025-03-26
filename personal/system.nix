{ ... }:
{
  # Allow touch ID for sudo authentication
  security.pam.services.sudo_local.touchIdAuth = true;

  # Set a reasonable timeout for sudo
  security.sudo.extraConfig = ''
    Defaults timestamp_timeout=60
  '';

  # Enable the built-in OpenSSH server
  services.openssh.enable = true;

  system = {

    # Enable keyboard remapping
    keyboard.enableKeyMapping = true;
    # (actually) remap Caps Lock to Escape
    keyboard.remapCapsLockToEscape = true;

    defaults = {
      # Hide the dock automatically
      dock.autohide = true;
      # Do not use the most-recently-used spaces, urgh!
      dock.mru-spaces = false;
      # Specify the persistent apps in the Dock
      dock.persistent-apps = [
        "/Applications/Google Chrome.app"
        "/Applications/Nix Apps/iTerm2.app"
        "/Applications/Bitwarden.app"
      ];

      finder = {
        AppleShowAllExtensions = true;
        _FXShowPosixPathInTitle = true;
      };
    };
  };
}
