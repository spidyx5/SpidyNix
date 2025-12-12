{ config, pkgs, lib, inputs, ... }:

{
  # =========================================================================
  # CURSOR SETTINGS ONLY (Minimal, High Performance)
  # =========================================================================
  # Keep only cursor - no GTK/Qt overhead
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };
  
  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "adwaita-dark";
  };
}
