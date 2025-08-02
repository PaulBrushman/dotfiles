{ pkgs, pkgs-stable, lib, ... }:

{
  home.username = "bob";
  home.homeDirectory = "/home/bob";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.  
  
  programs.btop = {
    enable = true;
    settings = {
      vim_keys = true;
    };
  };
  
  programs.yazi = {
    enable = true;
    keymap = {
      mgr.prepend_keymap = [
        { on = ''!''; run = ''shell "nvim" --block''; }
      ];
    };
    settings = {
      mgr = {
        show_hidden = true;
	      sort_by = "mtime"; # "modified";
	      sort_dir_first = true;
	      sort_reverse = true;
      };
      opener = {
        pideo = [
          { run = ''vlc "$@"''; orphan = true; }
        ];      
        edit = [
          { run = ''nvim "$@"''; orphan = true; block = true; }
        ];
      };
      open = {
        rules = [
          { mime = ''{audio,video}/*''; use = "pideo"; }
          { name = ''*''; use = "edit"; }
        ];
      };
    };
  };

  programs.neovim = { 
    enable = true;
    extraLuaPackages = ps: [ ps.magick ];
    extraPackages = [ pkgs.imagemagick ];
  };

  home.packages = [ pkgs-stable.vivaldi ] ++ (with pkgs; [
    brightnessctl
    pulseaudio
    fuzzel
    rtorrent
    tgt
    anki
    lazygit
    clipse
    gnumake
    vlc
    piper
    gpu-viewer
    vial
    starship
    zoxide
    wl-clipboard
    obsidian
    xclip
    yt-dlp
    wtype
    texlivePackages.latex
    texlivePackages.amsmath
    # texlivePackages.amssymb
    # texlivePackages.graphicx
    texlivePackages.dvipng

    gh
    hyprshot
    nwg-look
    capitaine-cursors
    difftastic
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ]);

  #systemd.user.services.rtorrent = {
  #  Unit = { 
  #    Description = "RTorrent Daemon"; 
  #    After = "network.target"; 
  #  };
  #  Service = {
  #    Type = "simple";
  #    ExecStartPre = "/run/current-system/sw/bin/rm -f /home/bob/.session/rtorrent.lock";
  #    ExecStart = "/etc/profiles/per-user/bob/bin/rtorrent -o system.daemon.set=true";
  #    Restart = "on-failure";
  #    RestartSec = "3";
  #  };
  #  Install = { WantedBy = [ "default.target" ]; };
  #};

  programs.bash = {
    enable = true;
    shellAliases = {
      l = "ls -alh";
      nrs = "sudo nixos-rebuild switch --flake ~/dotfiles/";
      wgu = "sudo wg-quick up joe";
      wgd = "sudo wg-quick down joe";
      ns = "nix search nixpkgs";
      nh = "nix-shell -p";
      pa = "ps aux";
      pg = "ps aux | grep";
      min = "docker run -p 9000:9000 -p 9001:9001 -v data:/home/bob/Models --name s3 -d quay.io/minio/minio server /data --console-address \":9001\"";
      hub = "docker run --rm -p 8022:8022 -v jupyter-data:/home/bob/Sandbox --name eup -d orie";
      eup = "ssh localhost -p 8022";
      clip = "xclip -selection clipboard";
      ytm = "yt-dlp -f 140 --embed-thumbnail --paths /mnt/tb4/Music/";
      ytv = "yt-dlp -f 303 --paths /mnt/tb4/excercise/";
      st = "cd /mnt/tb4/YBackup/santi/; y";
      m = "cd /mnt/tb4/Music/; y";
      yan = "cd /mnt/tb4/yan/; y";
      b = "cd ~/notes; nvim Bucket.norg";
      d = "cd ~/dotfiles; nvim home.nix";
    };
    
    bashrcExtra = ''
    set -o vi

    export GTK_IM_MODULE=fcitx
    export XMODIFIERS=@im=fcitx
    export QT_IM_MODULE=fcitx
 
    function y() {
    	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    	yazi "$@" --cwd-file="$tmp"
    	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    		builtin cd -- "$cwd"
    	fi
    	rm -f -- "$tmp"
    }

    function p() {
      cd ~/projects/$1;
      nvim;
    }

    function c() { 
      cd ~/clones/$1;
      nvim;
    }

    function gic() {
      cd ~/clones/;
      git clone $1;
      cd $(basename $1);
      nvim;
    }

    eval "$(starship init bash)"'';
  };

  home.activation = {
    configNvim = lib.hm.dag.entryAfter ["writeBoudary"] ''
      run ln -sfT $VERBOSE_ARG $HOME/dotfiles/nvim $HOME/.config/nvim
    '';
    configHypr = lib.hm.dag.entryAfter ["writeBoudary"] ''
      run ln -sfT $VERBOSE_ARG $HOME/dotfiles/hypr $HOME/.config/hypr
    '';
  };

  home.file = {};

  home.sessionVariables = {
    EDITOR = "nvim";
  };
  systemd.user.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.home-manager.enable = true;
}
