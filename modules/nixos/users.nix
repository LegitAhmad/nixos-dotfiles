{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Define a user account.
  users.users.legitahmad = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "input"
      "uinput"
      "docker"
    ]; # Enable ‘sudo’, NetworkManager, video control, input/uinput, and docker access.
    initialPassword = "changeme";
    shell = pkgs.zsh;
  };
}
