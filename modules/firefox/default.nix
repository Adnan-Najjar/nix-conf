{
  inputs,
  config,
  pkgs,
  user,
  ...
}:
{
  imports = [
    ./xdg.nix
    ./webapp.nix
  ];

  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    configPath = "${config.xdg.configHome}/mozilla/firefox";
    profiles = {

      # Main profile
      ${user.username} = {
        id = 0;
        name = "${user.username}";
        path = "${user.username}.default";
        userChrome = "";
        isDefault = true;
        settings = {
          "general.autoScroll" = true;

          "network.trr.mode" = 2;
          "network.trr.uri" = "https://firefox.dns.nextdns.io/";

          "sidebar.revamp" = true;
          "sidebar.verticalTabs" = true;
          "sidebar.main.tools" = "history,synced-tabs,extensions";

          "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
          "extensions.ui.dictionary.hidden" = true;
          "extensions.ui.lastCategory" = "addons://list/extension";
          "extensions.ui.locale.hidden" = true;
          "extensions.ui.mlmodel.hidden" = true;
          "extensions.ui.sitepermission.hidden" = false;

          "browser.startup.homepage" = "about:newtab";
          "browser.newtabpage.enabled" = true;
          "browser.toolbars.bookmarks.visibility" = "never";
          "browser.ctrlTab.sortByRecentlyUsed" = true;
          "browser.preferences.defaultPerformanceSettings.enabled" = false;
          "browser.search.suggest.enabled" = false;
          "browser.urlbar.suggest.searches" = false;
          "browser.uiCustomization.state" = builtins.toJSON {
            placements = {
              widget-overflow-fixed-list = [ ];

              unified-extensions-area = [
                "sponsorblocker_ajay_app-browser-action"
                "ublock0_raymondhill_net-browser-action"
                "info_haramblur_com-browser-action"
                "_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action"
                "bookmarkdial_sblask-browser-action"
              ];

              nav-bar = [
                "sidebar-button"
                "customizableui-special-spring2"
                "back-button"
                "forward-button"
                "stop-reload-button"
                "urlbar-container"
                "vertical-spacer"
                "simple-translate_sienori-browser-action"
                "addon_darkreader_org-browser-action"
                "_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action"
                "unified-extensions-button"
              ];

              toolbar-menubar = [
                "menubar-items"
              ];

              TabsToolbar = [ ];

              vertical-tabs = [
                "tabbrowser-tabs"
              ];

              PersonalToolbar = [
                "personal-bookmarks"
              ];
            };

            currentVersion = 24;
            newElementCount = 6;
          };

        };
        extensions = {
          force = true;
          packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
            ublock-origin
            sponsorblock
            darkreader
            simple-translate # settings: Target: English, Second: Arabic
            bitwarden
            vimium # settings: map K previousTab \n map J nextTab
            humble-new-tab # settings: {"open.OMajrHQ0BWUH":"true","open.KrEtqFWwZtWf":"true","options.show_root":"0","options.font_size":"17","options.highlight_color":"#ffffff","open.95SjX98sDSrc":"true","options.lock":"0","options.font_color":"#ffffff","column.1.0":"unfiled_____","options.background_align":"center","options.show_recent":"0","column.0.0":"toolbar_____","options.show_menu________":"0","options.shadow_color":"#000000","options.spacing":"1.359","options.show_closed":"0","open.unfiled_____":"true","open.menu________":"true","options.show_top":"0","column.2.0":"mobile______","options.icon_provider":"4","open.toolbar_____":"true","options.background_size":"contain","options.hide_options":"0"}
          ];
        };
        search = {
          force = true;
          default = "ddg";
          engines = {
            "bing".metaData.hidden = true;
            "google".metaData.hidden = true;
            "perplexity".metaData.hidden = true;
            "wikipedia".metaData.hidden = true;
          };
        };
      };
    };
    policies = {
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisableFirefoxAccounts = false;
      DisablePocket = true;
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = true;
      ShowBookmarksBar = "never";
      OfferToSaveLogins = false;
      PasswordManagerEnabled = false;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      StartDownloadsInTempDirectory = true;
      ExtensionSettings =
        with builtins;
        let
          extension = shortId: uuid: {
            name = uuid;
            value = {
              install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
              installation_mode = "normal_installed";
            };
          };
        in
        listToAttrs [
          (extension "haramblur" "info@haramblur.com")
        ];
    };
  };
}
