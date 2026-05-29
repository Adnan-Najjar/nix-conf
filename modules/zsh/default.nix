{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./programs.nix
  ];
  home.sessionPath = [
    "$HOME/.local/bin"
    "$GOPATH/bin"
  ];

  home.sessionVariables = {
    SHELL = "${pkgs.zsh}/bin/zsh";
    GOPATH = "$HOME/.go";
    MANPATH = "/usr/share/man:/usr/local/share/man:$MANPATH";
    MANPAGER = "nvim +Man!";
    MANWIDTH = 999;
    _ZO_EXCLUDE_DIRS = "/nix:/tmp:/proc:/sys:/dev";
    NIXPKGS_ALLOW_UNFREE = "1";
    XDG_DATA_DIRS = "$HOME/.local/share/nix-profile/share:$HOME/.nix-profile/share:\${XDG_DATA_DIRS:-/usr/local/share:/usr/share}";
  };

  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    autocd = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history = {
      expireDuplicatesFirst = true;
      extended = true;
      ignoreAllDups = true;
      size = 10000;
      save = 10000;
    };

    shellAliases = {
      ".." = "cd ..";
      cat = "bat";
      ip = "ip -c";
      rm = "trash -v";
      mkdir = "mkdir -p";
      ls = "eza --icons=auto";
      la = "eza -a --icons=auto";
      ll = "eza -l --icons=auto --total-size";
      lt = "eza --icons=auto --tree -I .git -I node_modules --group-directories-first";
      urls = "grep -oP -N --color=never 'http[s]?://\\S+'";
      music = "mpv --shuffle --no-video --volume=40 ~/Music/*";
    };

    initContent = builtins.readFile ./zshrc;
  };
}
