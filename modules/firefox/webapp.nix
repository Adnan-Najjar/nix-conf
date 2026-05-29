{ ... }:
let
  makeWebApp =
    {
      name,
      url,
      icon ? name,
    }:
    {
      name = name;
      genericName = "${name} Web App";
      exec = "env MOZ_ENABLE_WAYLAND=0 MOZ_GTK_TITLEBAR_DECORATION=none firefox -P webapp --name ${name}Web --class ${name}Web --no-remote --new-window ${url}";
      icon = icon;
      terminal = false;
      categories = [
        "Network"
        "InstantMessaging"
      ];
      settings = {
        StartupWMClass = "${name}Web";
      };
    };
in
{
  xdg = {
    mime.enable = true;
    desktopEntries = {
      whatsapp = makeWebApp {
        name = "WhatsApp";
        icon = "whatsapp";
        url = "https://web.whatsapp.com";
      };
    };
  };

  programs.firefox.profiles = {
    # WhatsApp profile
    webapp = {
      id = 1;
      name = "webapp";
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.toolbars.bookmarks.visibility" = "never";
        "ui.key.menuAccessKeyFocuses" = false;
        "permissions.default.persistent-storage" = 1;
        "browser.preferences.defaultPerformanceSettings.enabled" = false;
        "browser.search.suggest.enabled" = false;
        "browser.urlbar.suggest.searches" = false;
      };

      userChrome = ''
        @namespace url("http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul");

        /* Hide the Menu Bar */
        #toolbar-menubar {
          visibility: collapse !important;
          display: none !important;
        }

        /* Hide the Tab Strip */
        #TabsToolbar {
          visibility: collapse !important;
          display: none !important;
        }

        /* Hide the Navigation Bar (Address Bar, Back/Forward, Extensions) */
        #nav-bar {
          visibility: collapse !important;
          display: none !important;
        }

        /* Remove any remaining spacing/padding from the toolbox */
        #navigator-toolbox {
          max-height: 0 !important;
          min-height: 0 !important;
          padding: 0 !important;
          margin: 0 !important;
          border: none !important;
        }   
      '';

      userContent = ''
        @-moz-document domain("web.whatsapp.com") {

            /* Smooth transitions */
            * {
                transition: filter 120ms ease, opacity 120ms ease !important;
            }

            /* Blur ENTIRE contact rows (chat list) */
            [role="listitem"],
            [data-testid="cell-frame-container"] {
                filter: blur(8px) !important;
            }

            /* Blur entire chat panel */
            [data-testid="conversation-panel"],
            main,
            aside {
                filter: blur(8px) !important;
            }

            /* Hover reveal FULL contact row */
            [role="listitem"]:hover,
            [data-testid="cell-frame-container"]:hover {
                filter: blur(0) !important;
            }

            /* Hover reveal full chat panel */
            [data-testid="conversation-panel"]:hover {
                filter: blur(0) !important;
            }
        }
      '';
    };
  };
}
