{
  config,
  pkgs,
  ...
}: {
  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruber.yaml";
  # nord
  # stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";

  #stylix.image = ./wallpaper.jpg;

  stylix.image = config.lib.stylix.pixel "base0A";

  stylix.cursor.package = pkgs.bibata-cursors;
  stylix.cursor.name = "Bibata-Modern-Ice";

  stylix.fonts = {
    sizes = {
      applications = 14;
      desktop = 14;
      popups = 14;
    };
    monospace = {
      # package = pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];};
      # name = "JetBrainsMono Nerd Font Mono";
      package = pkgs.iosevka;
      name = "Iosevka";
    };
    sansSerif = {
      package = pkgs.noto-fonts;
      name = "Noto Sans";
    };
    serif = {
      package = pkgs.noto-fonts;
      name = "Noto Serif";
    };
  };
}
