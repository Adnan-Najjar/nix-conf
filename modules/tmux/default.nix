{ ... }:

{
  programs.tmux = {
    enable = true;
    prefix = "C-s";
    keyMode = "vi";
    mouse = true;
    newSession = true;
    extraConfig = builtins.readFile ./tmux.conf;
  };
}
