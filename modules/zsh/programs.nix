{ ... }:

{
  programs = {
    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        format = "$directory$git_status$python$cmd_duration\n$jobs$character";
        python = {
          # Only show when venv is active
          format = "([$symbol$virtualenv]($style) )";
          detect_extensions = [ ];
          detect_files = [ ];
          detect_folders = [ ];
        };
      };
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [ "--cmd cd" ];
    };
    carapace = {
      enable = true;
      enableZshIntegration = true;
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    direnv = {
      enable = true;
      silent = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
    bat = {
      enable = true;
      config = {
        pager = "less -FirSwX";
        theme = "TwoDark";
      };
    };
  };
}
