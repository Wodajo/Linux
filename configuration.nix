# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 1;

  # ntfs support
  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "Neocortex"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pl_PL.UTF-8";
    LC_IDENTIFICATION = "pl_PL.UTF-8";
    LC_MEASUREMENT = "pl_PL.UTF-8";
    LC_MONETARY = "pl_PL.UTF-8";
    LC_NAME = "pl_PL.UTF-8";
    LC_NUMERIC = "pl_PL.UTF-8";
    LC_PAPER = "pl_PL.UTF-8";
    LC_TELEPHONE = "pl_PL.UTF-8";
    LC_TIME = "pl_PL.UTF-8";
  };

  # NVIDIA stuff

# Make sure opengl is enabled
#  hardware.opengl = {
#    enable = true;
#    driSupport = true;
#    driSupport32Bit = true;
#  };

  # Tell Xorg to use the nvidia driver (also valid for Wayland)
#  services.xserver.videoDrivers = ["nvidia"];

#  hardware.nvidia = {

    # Modesetting is needed for most Wayland compositors
#    modesetting.enable = true;

    # Use the open source version of the kernel module
    # Only available on driver 515.43.04+
#    open = false;

    # Enable the nvidia settings menu
#    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
#    package = config.boot.kernelPackages.nvidiaPackages.stable;
#  };


  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the XFCE Desktop Environment.
#  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.lightdm.greeters.slick.enable = true;
#  services.xserver.desktopManager.xfce.enable = true;

  # Enable GNOME
#  services.xserver.displayManager.gdm.enable = true;
#  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
#  services.xserver.windowManager.qtile.enable = true;
#  services.xserver.displayManager.defaultSession = "none+qtile";
#  services.xserver.displayManager.defaultSession = "plasma";
   services.xserver.displayManager.defaultSession = "gnome";

  # GNOME services
#  services.gnome.gnome-browser-connector.enable = true;  # host-side connector for browser shell extensions (you have to also install browser addon
#  services.gnome.gnome-keyring.enable = true;

  # Virtualization
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "arco" ];
 #  virtualisation.virtualbox.host.enable = true;
 #  virtualisation.virtualbox.host.enableExtensionPack = true;
  virtualisation.virtualbox.guest.enable = true;
  virtualisation.virtualbox.guest.x11 = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.docker.enable = true;
  programs.dconf.enable = true;  # ?
#   [virt-manager] File (menu bar) -> add connection    OR   in home-manager
#   HyperVisor = QEMU/KVM
#   Autoconnect = checkmark
#   Connect
#  security.wrappers.spice-client-glib-usb-acl-helper.source = "${pkgs.spice-gtk}/bin/spice-client-glib-usb-acl-helper";
  virtualisation.spiceUSBRedirection.enable = true;
  services.spice-vdagentd.enable = true;  # for copy-paste between host&VM

  # Configure keymap in X11
  services.xserver = {
    layout = "pl";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "pl2";

  # Printing
#  services.printing.enable = true;  # CUPS

  # -- IPP
#  services.avahi.enable = true;
#  services.avahi.nssmdns = true;
  # for a WiFi printer
#  services.avahi.openFirewall = true;
  # -- driver-based printing
#  services.printing.drivers = with pkgs;[
#gutenprint gutenprintBin hplip brlaser
#];


  # Enable blueman
  services.blueman.enable = true;
  
  # Rstudio Server
#  services.rstudio-server.enable = true;
#  services.rstudio-server.serverWorkingDir = "path/to/dir"  # path ro default working dir of rserver
#  services.rstudio-server.rsessionExtraConfig = ""  # extra content for rsession.conf

  # Enable sound with pipewire.
  sound.enable = true;
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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;


  # Cachix - I'm not really sure which binaries are from there (surely not these from steam...)
#{
#  nix.settings = {
#    substituters = ["https://nix-gaming.cachix.org"];
#    trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="];
#  };
#}



  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.arco = {
    isNormalUser = true;
    description = "Wodajo";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "adbusers" "docker" ];
    packages = with pkgs; [
#      firefox
#      obsidian
#      nomacs
#      vlc
#      obs-studio
#      feh
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;


nixpkgs.overlays = [ (final: prev: { 
  zotero_beta = prev.zotero.overrideAttrs (old: with prev.zotero; rec {
    pname = "zotero-beta";
    version = "0cab24fb8";

    libPath = prev.zotero.libPath + ":" + prev.lib.makeLibraryPath [
      prev.alsa-lib
      prev.xorg.libXtst
    ];
    src = pkgs.fetchurl {
      url = "https://download.zotero.org/client/beta/7.0.0-beta.48%2B${version}/Zotero-7.0.0-beta.48%2B${version}_linux-x86_64.tar.bz2";
      hash = "sha256-IbTCQr32dknmy8aqQe4u6ymlQ+2VNSqHcFZDbV26Wbo=";
    };
    meta.knownVulnerabilities = [ ];
    postPatch = "";

    installPhase = ''
      runHook preInstall

      mkdir -p "$prefix/usr/lib/zotero-bin-${version}"
      cp -r * "$prefix/usr/lib/zotero-bin-${version}"
      mkdir -p "$out/bin"
      ln -s "$prefix/usr/lib/zotero-bin-${version}/zotero" "$out/bin/"

      # install desktop file and icons.
      mkdir -p $out/share/applications
      cp ${desktopItem}/share/applications/* $out/share/applications/
      for size in 16 32 48 256; do
        install -Dm444 chrome/icons/default/default$size.png \
          $out/share/icons/hicolor/''${size}x''${size}/apps/zotero.png
      done

      for executable in \
        zotero-bin plugin-container \
        updater minidump-analyzer
      do
        if [ -e "$out/usr/lib/zotero-bin-${version}/$executable" ]; then
          patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
            "$out/usr/lib/zotero-bin-${version}/$executable"
        fi
      done
      find . -executable -type f -exec \
        patchelf --set-rpath "$libPath" \
          "$out/usr/lib/zotero-bin-${version}/{}" \;

      runHook postInstall
    '';
  });
  })
];


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs;
  let
    RStudio-with-my-packages = rstudioWrapper.override{
      packages = with rPackages; [ 
tidyverse rtracklayer DESeq2 limma ggrepel scales seqinr shiny rlang stringr circlize renv
];};
    RStudio-Server-with-my-pks = rstudioServerWrapper.override{
	packages = with rPackages; [
tidyverse rtracklayer DESeq2 limma ggrepel scales seqinr rlang stringr circlize shiny renv
];};
  in
  [
#    RStudio-with-my-packages
#     RStudio-Server-with-my-pks
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    firefox
#    obsidian
#    conda
    jetbrains.pycharm-community
#     gnomeExtensions.no-activities-button
#     gnomeExtensions.dash-to-dock
#     gnomeExtensions.vitals
#     gnomeExtensions.nvidia-gpu-stats-tool
    nomacs
    vlc
    obs-studio
#    feh
#    qtile
    picom
    nitrogen
    flameshot
    rofi
    git
    alacritty
    xclip
    unzip
    xfce.thunar
    tldr
    okular
    betterlockscreen
    brightnessctl
    pavucontrol
    unrar
    nmap
    libreoffice-still
    hunspell
    hunspellDicts.pl-pl
    networkmanagerapplet
    blueman
    lightdm-gtk-greeter
    lxappearance
#    anydesk
#    mangohud
#    httrack
#    burpsuite
    usbimager
    lutris
    (lutris.override {
	extraPkgs = pkgs: [
	  # list of dependencies here
          wineWowPackages.stable  # both 32&64 bit apps
          winetricks  # all versions
	];
    })
    heroic
#    nfs-utils  # think about NFS from katbot NAS
    qbittorrent
    bleachbit
#    qmmp
    scanmem  # cheat engine like stuff 
    chromium
#   appimagekit
    appimage-run
#    foomatic-db-ppds-withNonfreeDb
    anki  # anki-bin slightly newer
   virt-manager
   spice-gtk  # for us redirection in virt manager via SPICE - it also needs a security wrapper (should be in #Virtualization)
    usbutils
    pciutils
    libarchive
    android-udev-rules  # so that non-root device (specifically androids) could use usb
    onlyoffice-bin
    wineWowPackages.stable
    winetricks
    vassal
    teamviewer
    zotero
    python3
    diffutils
 #   virtualbox
 #   linuxKernel.packages.linux_xanmod_latest.virtualbox
    calibre
  ];

  # Android SKD (adb, fastboot ...)
#  programs.adb.enable = true;  # you also need user to be in "adbusers" group for proper udev rules  # 34.0.1 (old)


#  Gaming
	programs.steam = {
	enable = true;
#       remotePlay.openFirewall = true;  # Open ports in the fw for Steam Remote Play
#	dedicatedServer.openFirewall = true;   # open ports in fw for Source Dedicated Server
	};
#
	hardware.opengl.driSupport32Bit = true;  # for Epic Games Store 32bit support (needed on 64)

  # fonts

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
