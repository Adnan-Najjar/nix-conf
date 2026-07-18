{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # CLI
    xdg-utils
    tesseract
    wl-clipboard
    libnotify
    man-pages
    man-pages-posix
    unixtools.xxd
    file
    unzip
    p7zip
    ripgrep
    fd
    ffmpeg
    jq
    htmlq
    btop
    fastfetch
    eza
    tldr
    trash-cli
    imagemagick
    python313Packages.markitdown
    gnumake
    pinentry-gnome3
    pandoc
    texliveSmall
    android-tools
    nerd-fonts.jetbrains-mono # font
    w3m

    # GUI
    mission-center
    chromium
    thunderbird
    gradia
    marktext
    libreoffice
  ];

  programs.mpv = {
    enable = true;
    scripts = [ pkgs.mpvScripts.mpris ];
  };

  # Nix Helper
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
    };
    flake = "${config.home.homeDirectory}/.config/home-manager";
  };
}
