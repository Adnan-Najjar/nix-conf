{ user, ... }:
{
  programs = {
    git = {
      enable = true;
      settings = {
        user = {
          name = user.fullName;
          email = user.email;
        };
        alias = {
          pl = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(r) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
        };
        init.defaultBranch = "main";
        color.ui = true;
        credential.helper = "store";
        pull.rebase = true;
      };
      ignores = [
        "AGENTS.md"
        ".*env*"
        "*.log"
        "TODO.md"
      ];
    };
    gh.enable = true;
  };
}
