# /etc/nixos/SpidyNix/Homes/apps/qutebrowser.nix
{lib, pkgs, ...}: {
  programs.qutebrowser = {
    enable = true;  # Enable Qutebrowser
    loadAutoconfig = true;  # Load autoconfig
    keyBindings = {
      normal = {
        ";v" = "hint links spawn --detach mpv {hint-url}";  # Hint links with mpv
        ",h" = lib.mkMerge [
          "config-cycle tabs.show      never   always"  # Toggle tabs
          "config-cycle statusbar.show in-mode always"  # Toggle statusbar
          "config-cycle scrolling.bar  never   always"  # Toggle scrollbar
        ];
        ",s" = lib.mkMerge [
          "config-cycle tabs.position  left   top"  # Toggle tabs position
        ];
      };
    };
    settings = {
      highdpi = true;  # Enable high DPI
      auto_save.session = true;  # Auto save session
      fonts = {
        default_family = lib.mkForce "ZedMono Nerd Font Mono";  # Default font
        default_size = lib.mkForce "10pt";  # Default font size
        web.family.fixed = lib.mkForce "ZedMono Nerd Font Mono";  # Web font
      };
      colors.webpage.darkmode.enabled = true;  # Enable dark mode
      new_instance_open_target = "window";  # New instance open target
      tabs.background = true;  # Tabs background
      completion = {
        height = "30%";  # Completion height
        open_categories = ["history"];  # Open categories
        scrollbar = {
          padding = 0;  # Scrollbar padding
          width = 0;  # Scrollbar width
        };
        show = "always";  # Show completion
        shrink = true;  # Shrink completion
        timestamp_format = "";  # Timestamp format
        web_history.max_items = 7;  # Web history max items
      };
      content = {
        headers = {
          user_agent = "Mozilla/5.0 (X11; Linux x86_64; rv:123.0) Gecko/20100101 Firefox/123.0";  # User agent
          accept_language = "en-US,en;q=0.5";  # Accept language
        };

        blocking = {
          enabled = true;  # Enable blocking
          method = "both";  # Blocking method
          adblock.lists = [
            "https://easylist.to/easylist/easylist.txt"  # Adblock list
            "https://easylist.to/easylist/easyprivacy.txt"  # Adblock list
            "https://easylist.to/easylist/fanboy-annoyance.txt"  # Adblock list
            "https://secure.fanboy.co.nz/fanboy-cookiemonster.txt"  # Adblock list
            "https://secure.fanboy.co.nz/fanboy-annoyance.txt"  # Adblock list
            "https://easylist-downloads.adblockplus.org/abp-filters-anti-cv.txt"  # Adblock list
            "https://pgl.yoyo.org/adservers/serverlist.php?showintro=0;hostformat=hosts"  # Adblock list
            "https://github.com/uBlockOrigin/uAssets/raw/master/filters/legacy.txt"  # Adblock list
            "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters.txt"  # Adblock list
            "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2020.txt"  # Adblock list
            "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2021.txt"  # Adblock list
            "https://github.com/uBlockOrigin/uAssets/raw/master/filters/badware.txt"  # Adblock list
            "https://github.com/uBlockOrigin/uAssets/raw/master/filters/privacy.txt"  # Adblock list
            "https://github.com/uBlockOrigin/uAssets/raw/master/filters/badlists.txt"  # Adblock list
            "https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances.txt"  # Adblock list
            "https://github.com/uBlockOrigin/uAssets/raw/master/filters/resource-abuse.txt"  # Adblock list
            "https://github.com/uBlockOrigin/uAssets/raw/master/filters/unbreak.txt"  # Adblock list
            "https://www.i-dont-care-about-cookies.eu/abp/"  # Adblock list
            "https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=1&mimetype=plaintext"  # Adblock list
            "https://gitlab.com/curben/urlhaus-filter/-/raw/master/urlhaus-filter-online.txt"  # Adblock list
          ];
        };
        canvas_reading = false;  # Disable canvas reading
        autoplay = false;  # Disable autoplay
        javascript.clipboard = "access";  # JavaScript clipboard
        pdfjs = true;  # Enable PDF.js
      };
      downloads = {
        position = "bottom";  # Downloads position
        remove_finished = 0;  # Remove finished downloads
      };
      scrolling = {
        bar = "never";  # Scrollbar
        smooth = true;  # Smooth scrolling
      };
    };

    searchEngines = {
      "DEFAULT" = "https://duckduckgo.com/?ia=web&q={}";  # Default search engine
      "!d" = "https://duckduckgo.com/?ia=web&q={}";  # DuckDuckGo
      "!gc" = "https://github.com/search?q={}&type=code";  # GitHub code search
      "!g" = "https://www.google.com/search?hl=en&q={}";  # Google
      "!gr" = "https://github.com/search?q={}&type=repositories";  # GitHub repositories
      "!gs" = "https://github.com/search?o=desc&q={}&s=stars";  # GitHub stars
      "!hm" = "https://home-manager-options.extranix.com/?query={}";  # Home Manager options
      "!nf" = "https://noogle.dev/q?term={}&limit=50&page=1";  # Noogle
      "!np" = "https://search.nixos.org/packages?type=packages&query={}";  # NixOS packages
      "!npp" = "https://github.com/NixOS/nixpkgs/pulls?q=is%3Apr+is%3Aopen+{}";  # NixOS pull requests
      "!nw" = "https://nixos.wiki/index.php?search={}";  # NixOS wiki
      "!yt" = "https://youtube.com/results?search_query={}";  # YouTube
    };

    # extraConfig = ''
    #   c.content.user_stylesheets = ['~/.config/qutebrowser/css/gruvbox.css']
    # '';
  };

}

