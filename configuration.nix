{ pkgs, pkgs-stable, inputs, ... }: # neovimUtils, wrapNeovimUnstable, 
# let
# nvimConfig = pkgs.neovimUtils.makeNeovimConfig {
#   extraLuaPackages = p: [ p.magick ];
#   extraPackages = p: [ p.imagemagick ];
#   # ... other config
# };
# in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Yekaterinburg";

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

  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      fcitx5-chinese-addons
      fcitx5-catppuccin
    ];
  };

  services.xserver.enable = true;
  services.displayManager.ly.enable = true;
  # services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
  '';

  services.flatpak.enable = true;
  services.flatpak.packages = [
    "net.mkiol.SpeechNote"
    "net.mkiol.SpeechNote.Addon.nvidia"
    "com.discordapp.Discord"
    "com.github.ahrm.sioyek"
  ];
  services.flatpak.update.auto = {
    enable = true;
    onCalendar = "weekly"; # Default value
  };

  # systemd.user.services.dsnote = {
  #   Unit = {
  #     Description = "Speech daemon";
  #     After = "pulseaudio.service";
  #     Requires="pulseaudio.service";
  #   };
  #   Service = {
  #     Type="dbus";
  #     BusName="org.mkiol.Speech";
  #     ExecStart="@binary_path@ --service";
  #   };
  # };

  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  services.ratbagd.enable = true;
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  hardware.nvidia-container-toolkit.enable = true;
  virtualisation.docker={
    enable = true; 
    daemon.settings = {
      data-root = "/docker-storage/";
    };
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.bob = {
    isNormalUser = true;
    description = "bob";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  home-manager = {
    extraSpecialArgs = {  inherit pkgs-stable; };
    users = {
      "bob" = import ./home.nix;
    };
  };
    
  environment.localBinInPath = true;

  fonts.packages = with pkgs; [noto-fonts-cjk-sans];# [noto-fonts noto-fonts-extra];
  
  programs.hyprland.enable = true;

  nixpkgs.config.allowUnfree = true;
  
  # nixpkgs.overlays = [
  #     (_: super: {
  #     neovim-custom = pkgs.wrapNeovimUnstable
  #         (super.neovim-unwrapped.overrideAttrs (oldAttrs: {
  #         buildInputs = oldAttrs.buildInputs ++ [ super.tree-sitter ];
  #         })) nvimConfig;
  #     })
  # ];

  environment.systemPackages = with pkgs; [
    hyprlock

    vim
    tree-sitter
    nixpkgs-fmt
    alejandra
    nixd
    unzip
    
    wget
    wireguard-tools
    git
    gcc
    cmake
    kitty
    libratbag
    btop
    nvtopPackages.full
    corectrl
    glxinfo
    gdk-pixbuf
    qt5.full
    libpulseaudio
    zlib
    fcitx5-configtool
    usbutils
    udiskie
    udisks
    d-spy
    fzf
    fd
    swww
    waypaper
    ripgrep
    file
    socat
    
    xdg-desktop-portal
    obs-studio
    cargo
    uv
    python311
    python311Packages.jupyterlab
    python311Packages.pipx
    python311Packages.pip
    zig
    lua
    luarocks
    luaPackages.lua-lsp
    nodejs

    lazydocker
    cudatoolkit
    cmake

    lact
    imagemagick
  ];

  systemd.services.lact = {
    description = "AMDGPU Control Daemon";
    after = ["multi-user.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      ExecStart = "${pkgs.lact}/bin/lact daemon";
    };
    enable = true;
  };

  environment.variables = {
    UV_PYTHON_DOWNLOADS="never";
  };

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
  system.stateVersion = "24.05"; # Did you read the comment?

}
