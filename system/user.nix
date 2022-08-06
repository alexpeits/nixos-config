{ pkgs, ... }:

{
  users = {
    users.alex = {
      createHome = true;
      group = "users";
      home = "/home/alex";
      isNormalUser = true;
      uid = 1000;

      extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" "docker" ];
      shell = pkgs.fish;
    };

    defaultUserShell = pkgs.bash;
  };
}
