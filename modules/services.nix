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
        cd $HOME/Documents

        ${git} pull --rebase || true
        ${git} add .
        ${git} diff --quiet --cached && exit 0
        ${git} commit -m "Autosave: $(date)"
        ${git} push || true
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
