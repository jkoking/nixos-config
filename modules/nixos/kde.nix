{ pkgs, ... }:
{
  # Enable the KDE Plasma Desktop Environment.
  services.desktopManager.plasma6.enable = true;

  # kde connect
  programs.kdeconnect.enable = true;

  # add kde packages
  environment.systemPackages = with pkgs.kdePackages; [
    akregator
    dragon
    elisa
    kcalc
    kcharselect
    kdenlive
    partitionmanager
    plasma-integration
    kdeplasma-addons
    kmines
    knights
    qtstyleplugin-kvantum
  ];
}
