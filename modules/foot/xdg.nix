{ pkgs, ... }:
{
  xdg.autostart = {
    enable = true;
    entries = [
      "${pkgs.foot}/share/applications/foot.desktop"
    ];
  };
}
