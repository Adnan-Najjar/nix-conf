{
  config,
  pkgs,
  lib,
  ...
}:

let
  random_wallpaper =
    pkgs.runCommand "random-wallpaper"
      {
        nativeBuildInputs = [ pkgs.coreutils ];
      }
      ''
        cp "${./Wallpapers}/$(ls ${./Wallpapers} | shuf -n 1)" "$out"
      '';
in
{
  imports = [
    (import ./dconf.nix {
      inherit
        config
        pkgs
        lib
        random_wallpaper
        ;
    })
  ];

  xdg.enable = true;
  fonts.fontconfig.enable = true;
  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };
  # Fix dark mode
  systemd.user.sessionVariables = {
    GTK_THEME = "Adwaita:dark";
  };

  home = {
    packages = with pkgs.gnomeExtensions; [
      caffeine
      athantimes
      todotxt
      clipboard-indicator
    ];

  };
}
