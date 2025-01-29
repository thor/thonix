{ config, pkgs, ... }:
{
  environment.systemPackages = [
    # source control
    pkgs.git
    # communication tool
    pkgs.slack
  ];
}
