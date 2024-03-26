{ pkgs, ... }: {
  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm = {
    enable = true;
    theme = "${pkgs.nordic.sddm}/share/sddm/themes/Nordic-bluish";
  };
  services.xserver.desktopManager.plasma5.enable = true;

  # kde connect
  programs.kdeconnect.enable = true;

  # add kde pack packags
  environment.systemPackages = with pkgs.libsForQt5; [
    akregator
    dragon
    kdenlive
    kdeplasma-addons
    kmines
    knights
    qtstyleplugin-kvantum
  ];
}
