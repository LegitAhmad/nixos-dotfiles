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
    ]; # Enable ‘sudo’, NetworkManager, video control, and input/uinput access.
    initialPassword = "changeme";
    shell = pkgs.zsh;
  };
}
