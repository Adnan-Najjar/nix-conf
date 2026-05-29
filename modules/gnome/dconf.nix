# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{
  config,
  lib,
  random_wallpaper,
  ...
}:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };

    "org/gnome/mutter" = {
      dynamic-workspaces = false;
    };

    "org/gnome/desktop/input-sources" = {
      sources = [
        (mkTuple [
          "xkb"
          "us"
        ])
        (mkTuple [
          "xkb"
          "ara"
        ])
      ];
      xkb-options = [
        "caps:escape"
        "grp:alt_shift_toggle"
      ];
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-animations = false;
      enable-hot-corners = false;
      show-battery-percentage = true;
      cursor-theme = "Adwaita";
    };

    "org/gnome/desktop/background" = {
      picture-options = "zoom";
      picture-uri-dark = "file://${random_wallpaper}";
    };

    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Super>w" ];
      panel-run-dialog = [ "<Super>r" ];
      move-to-workspace-1 = [ "<Shift><Super>1" ];
      move-to-workspace-2 = [ "<Shift><Super>2" ];
      move-to-workspace-3 = [ "<Shift><Super>3" ];
      move-to-workspace-4 = [ "<Shift><Super>4" ];
      move-to-workspace-5 = [ "<Shift><Super>5" ];
      move-to-workspace-6 = [ "<Shift><Super>6" ];
      move-to-workspace-7 = [ "<Shift><Super>7" ];
      move-to-workspace-8 = [ "<Shift><Super>8" ];
      move-to-workspace-9 = [ "<Shift><Super>9" ];
      switch-to-workspace-1 = [ "<Super>1" ];
      switch-to-workspace-2 = [ "<Super>2" ];
      switch-to-workspace-3 = [ "<Super>3" ];
      switch-to-workspace-4 = [ "<Super>4" ];
      switch-to-workspace-5 = [ "<Super>5" ];
      switch-to-workspace-6 = [ "<Super>6" ];
      switch-to-workspace-7 = [ "<Super>7" ];
      switch-to-workspace-8 = [ "<Super>8" ];
      switch-to-workspace-9 = [ "<Super>9" ];
      switch-input-source = [ "<Shift>Alt_L" ];
      switch-input-source-backward = [ "<Shift>Alt_L" ];
    };

    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = "default";
      speed = -0.48;
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
      num-workspaces = 5;
      resize-with-right-button = true;
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      control-center = [ "<Super>i" ];
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
      ];
      home = [ "<Super>e" ];
      magnifier = [ "<Super>z" ];
      www = [ "<Super>b" ];
      mic-mute = [ "KP_Subtract" ];
      volume-mute = [ "KP_Add" ];
    };

    "org/gnome/gnome-screenshot" = {
      show-screenshot-ui = [ "<Shift><Super>s" ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding = "<Super>Return";
      command = "foot";
      name = "Terminal";
    };

    "org/gnome/shell" = {
      always-show-log-out = true;
      enabled-extensions = [
        "appindicatorsupport@rgcjonas.gmail.com"
        "copyous@boerdereinar.dev"
        "caffeine@patapon.info"
        "gsconnect@andyholmes.github.io"
        "athan@goodm4ven"
        "todo.txt@bart.libert.gmail.com"
      ];
      favorite-apps = [
        "foot.desktop"
        "firefox.desktop"
        "org.gnome.Nautilus.desktop"
      ];
    };

    "org/gnome/shell/weather" = {
      automatic-location = true;
    };

    "org/gnome/shell/app-switcher" = {
      current-workspace-only = true;
    };

    "org/gnome/shell/keybindings" = {
      screenshot = [ "Print" ];
      show-screen-recording-ui = [ "<Shift><Super>r" ];
      switch-to-application-1 = [ ];
      switch-to-application-2 = [ ];
      switch-to-application-3 = [ ];
      switch-to-application-4 = [ ];
      switch-to-application-5 = [ ];
      switch-to-application-6 = [ ];
      switch-to-application-7 = [ ];
      switch-to-application-8 = [ ];
      switch-to-application-9 = [ ];
      toggle-message-tray = [ "<super>c" ];
      toggle-overview = [ "<super>tab" ];
    };

    "org/gnome/desktop/sound" = {
      event-sounds = false;
    };

    "org/gnome/desktop/search-providers" = {
      disable-external = false;
    };

    "org/gnome/shell/extensions/copyous" = {
      open-clipboard-dialog-shortcut = [ "<Super>v" ];
      auto-hide-search = true;
      clipboard-orientation = "vertical";
      clipboard-position-horizontal = "top";
      clipboard-position-vertical = "fill";
      dynamic-item-height = true;
      header-controls-visibility = "visible-on-hover";
      item-height = 100;
      item-width = 300;
      show-at-pointer = true;
      show-header = false;
    };

    "org/gnome/shell/extensions/copyous/file-item" = {
      file-preview-visibility = "file-info";
    };

    "org/gnome/shell/extensions/copyous/link-item" = {
      link-preview-orientation = "horizontal";
    };

    "org/gnome/shell/extensions/athan" = {
      auto-location = true;
      time-format-12 = true;
    };

    "org/gnome/shell/extensions/TodoTxt" = {
      donetxt-location = "${config.home.homeDirectory}/Documents/todo.txt";
      todotxt-location = "${config.home.homeDirectory}/Documents/todo.txt";
      show-open-preferences = false;
      task-insert-location = 1;
      truncate-long-tasks = true;
    };
  };
}
