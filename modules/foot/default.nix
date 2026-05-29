{ pkgs, lib, ... }:
{
  imports = [ ./xdg.nix ];
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMonoNerdFontMono-Regular:size=12";
        shell = lib.getExe pkgs.zsh;
        initial-window-mode = "maximized";
      };
      mouse.hide-when-typing = true;
      csd.size = 0;

      colors-dark = {
        alpha = 0.97;
        foreground = "e6e1cf";
        background = "0b0e14";
        selection-foreground = "e6e1cf";
        selection-background = "202229"; # Derived from color 19
        urls = "e6b450"; # Derived from color 17

        ## Normal/regular colors (color palette 0-7)
        regular0 = "0b0e14"; # black
        regular1 = "f07178"; # red
        regular2 = "aad94c"; # green
        regular3 = "ffb454"; # yellow
        regular4 = "59c2ff"; # blue
        regular5 = "d2a6ff"; # magenta
        regular6 = "95e6cb"; # cyan
        regular7 = "e6e1cf"; # white

        ## Bright colors (color palette 8-15)
        bright0 = "3e4b59"; # bright black
        bright1 = "f07178"; # bright red
        bright2 = "aad94c"; # bright green
        bright3 = "ffb454"; # bright yellow
        bright4 = "59c2ff"; # bright blue
        bright5 = "d2a6ff"; # bright magenta
        bright6 = "95e6cb"; # bright cyan
        bright7 = "f2f0e7"; # bright white

        ## dimmed colors
        dim0 = "ff8f40"; # Derived from color 16
        dim1 = "131721"; # Derived from color 18
      };
    };
  };
}
