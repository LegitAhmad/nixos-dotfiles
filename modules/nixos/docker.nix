{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Enable Docker service.
  virtualisation.docker = {
    enable = true;
  };

  # Docker CLI utilities.
  environment.systemPackages = with pkgs; [
    docker-compose
  ];
}
