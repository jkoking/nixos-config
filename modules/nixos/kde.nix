{ pkgs, ... }: {
  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.desktopManager.plasma6.enable = true;

  # kde connect
  programs.kdeconnect.enable = true;

  # add kde pack packags
  environment.systemPackages = with pkgs.kdePackages; [
    akregator
    dragon
    elisa
    # kamoso
    kcalc
    kdenlive
    partitionmanager
    kdeplasma-addons
    kmines
    knights
  ];
}
