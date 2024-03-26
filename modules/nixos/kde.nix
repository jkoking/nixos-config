{ pkgs, ... }: {
  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm = {
    enable = true;
    theme = "${pkgs.nordic.sddm}/share/sddm/themes/Nordic-bluish";
    wayland.enable = true;
  };
  services.xserver.desktopManager.plasma6.enable = true;

  # kde connect
  programs.kdeconnect.enable = true;

  # add kde pack packags
  environment.systemPackages = with pkgs.kdePackages; [
    akregator
    dragon
    kamoso
    kdenlive
    kdeplasma-addons
    kmines
    knights
    qtstyleplugin-kvantum
  ];
}
