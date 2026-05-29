{
  config,
  pkgs,
  lib,
  ...
}:
let
  git = lib.getExe pkgs.git;
in
{
  # Auto save to github
  systemd.user.timers."autosave" = {
    Unit = {
      Description = "Autosave notes timer";
    };
    Timer = {
      OnBootSec = "2m";
      OnCalendar = "hourly";
      Unit = "autosave.service";
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };

  systemd.user.services."autosave" = {
    Unit = {
      Description = "Autosave notes to git";
    };
    Service = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "autosave" ''
        set -eu
        cd "$HOME/Documents"
        if [ ! -d ".git" ]; then
          git clone https://github.com/adnan-najjar/my-notes . || exit 1
        fi

        ${git} fetch origin main || true

        ${git} diff --name-only --diff-filter=D HEAD origin/main 2>/dev/null | while read -r file; do
            if [ -f "$file" ]; then
                rm "$file"
                ${git} rm "$file"
            fi
        done

        ${git} add .
        if ! ${git} diff --quiet --cached; then
            ${git} commit -m "Autosave (Local changes): $(date)"
        fi

        ${git} merge origin/main -X ours --no-edit || true

        ${git} push origin main || true
      '';
    };
  };

  # Quran Quiz
  systemd.user.services.quranquiz = {
    Unit = {
      Description = "Run Quran Quiz";
    };

    Service = {
      Type = "oneshot";
      Environment = [
        "SURAH_NUM=36"
        "VERSE_NUM=1"
      ];
      ExecStart = "${config.home.homeDirectory}/.local/bin/QuranQuiz";
    };
  };

  systemd.user.timers.quranquiz = {
    Unit = {
      Description = "Run Quran Quiz every hour";
    };

    Timer = {
      OnCalendar = "hourly";
      Persistent = true;
    };

    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
