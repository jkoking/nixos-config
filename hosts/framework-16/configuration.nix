# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, config, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  # mamually select kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # mount drives
  fileSystems = {
    "/home/jacob/Games".label = "games";
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Define your hostname.
  networking.hostName = "framework-16";

  # Enable experimentel features
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable bluetooth
  hardware.bluetooth.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # enable fwupd
  services.fwupd.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  services.printing.drivers = [ pkgs.hplipWithPlugin ];

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jacob = {
    isNormalUser = true;
    description = "jacob";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
    ];
  };

  # Setup display manager
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "${pkgs.nordic.sddm}/share/sddm/themes/Nordic-bluish";
  };

  # Enable 32 bit libraries
  hardware.graphics.enable32Bit = true;

  # Setup Virt-manager
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      vhostUserPackages = with pkgs; [ virtiofsd ];
      ovmf = {
        enable = true;
        packages = [
          (pkgs.OVMF.override {
            secureBoot = true;
            tpmSupport = true;
          }).fd
        ];
      };
    };
  };
  boot.extraModprobeConfig = "options kvm_amd nested=1 vfio-pci ids=1002:7480,1002:ab30";

  # Allow unfree package
  nixpkgs.config.allowUnfree = true;

  # Setup Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  # Setup gamescope
  programs.steam.gamescopeSession.enable = true;

  # Setup git
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    config.credential.helper = "libsecret";
  };

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    _86Box
    appimage-run
    bitwarden-desktop
    bleachbit
    bottles
    chiaki
    chromium
    cool-retro-term
    corectrl
    devenv
    direnv
    discord
    dolphin-emu
    easyeffects
    espeak
    exfat
    fastfetch
    fd
    floorp
    freecad
    gimp
    godot_4
    handbrake
    home-manager
    jetbrains.idea-community-bin
    looking-glass-client
    (lutris.override { extraPkgs = pkgs: [ pkgs.adwaita-icon-theme ]; })
    makemkv
    mgba
    minetest
    nil
    nixfmt-rfc-style
    nix-index
    nix-tree
    nix-index
    nixd
    obs-studio
    okteta
    onlyoffice-bin
    papirus-icon-theme
    pciutils
    piper-tts
    pokemmo-installer
    (prismlauncher.override {
      additionalLibs = [
        at-spi2-atk
        cairo.out
        cups.lib
        dbus.lib
        glib
        libdrm
        libxkbcommon
        mesa
        nspr
        nss
        pango
        xorg_sys_opengl
        xorg.libxcb.out
        xorg.libXcomposite
        xorg.libXdamage
        xorg.libXfixes.out
      ];
      additionalPrograms = [ ffmpeg ];
    })
    protonplus
    protontricks
    protonvpn-gui
    python3
    qpwgraph
    ryujinx
    scrcpy
    space-cadet-pinball
    speechd
    speedtest-cli
    spotify
    synology-drive-client
    trashy
    tree
    virt-manager
    vscode
    vulkan-tools
    wget
    wine-staging
    xemu
  ];
  systemd.tmpfiles.rules = [
    "f /dev/shm/looking-glass 0660 jacob qemu-libvirtd -"
  ];



  # enable gamemode
  programs.gamemode.enable = true;

  #setup nh
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/jacob/nix";
  };

  # dynamic link home apps
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
    libcef
  ];

  # setup shells
  programs.fish.enable = true;
  environment.shells = with pkgs; [
    fish
    bash
  ];
  users.defaultUserShell = pkgs.bash;
  programs.bash = {
    interactiveShellInit = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };

  #pt


  boot = {
    extraModulePackages = with config.boot.kernelPackages; [ kvmfr ];
    initrd = {
      availableKernelModules = [
        "amdgpu"
        "nvme"
        "xhci_pci"
        "thunderbolt"
        "usbhid"
        "usb_storage"
        "uas"
        "sd_mod"
        "pci_stub"
        "vfio"
        "vfio-pci"
        "vfio_iommu_type1"
      ];
      kernelModules = [
        "vfio"
        "vfio-pci"
        # order matters here, the vfio have to come before the amdgpu
        # or else the gpu will grab the pci device before it can be
        # set for vfio-pci passthru
        "amdgpu"
      ];
      preDeviceCommands = ''
        DEVS="0000:03:00.0 0000:03:00.1"
        for DEV in $DEVS; do
          echo "vfio-pci" > /sys/bus/pci/devices/$DEV/driver_override
        done
        modprobe -i vfio-pci
      '';
    };
    kernelModules = [
      "kvm-amd"
      "pci_stub"
      "vfio_pci"
      "vfio"
      "vfio_iommu_type1"
      "kvmfr"
    ];
    kernelParams = [
      "iommu=pt"
      # "pcie_aspm=off"
      "amd_iommu=on"
      "vfio-pci.ids=1002:7480,1002:ab30"
      "pci-stub.ids=1002:7480,1002:ab30"
      "mem_sleep_default=deep"
    ];
  };


  # Limit journal size
  services.journald.extraConfig = ''
    SystemMaxUse=50M
  '';

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
