{ config, pkgs, lib, inputs, ... }:

# ============================================================================
# SPIDYNIX GIT CONFIGURATION MODULE
# ============================================================================
# Custom git settings, delta syntax highlighting, and lazygit TUI
# Optimized for Colemak DH keyboard layout and Wayland
# ============================================================================

{
  # =========================================================================
  # GIT CONFIGURATION
  # =========================================================================
  programs.git = {
    enable = true;
    lfs.enable = true;

    settings = {
      user = {
        name = "spidyx5";
        email = "spidyx5@duck.com";
      };

      alias = {
        st = "status";
        s = "status --short";
        co = "checkout";
        br = "branch --sort=-committerdate";
        cm = "commit -m";
        lg = "log --graph --pretty=format:'%Cred%h%Creset - %C(yellow)%d%Creset %s %C(green)(%cr)%C(bold blue) <%an>%Creset' --abbrev-commit";
        df = "diff";
        gp = "pull";
        gph = "push";
        unstage = "reset HEAD --";
      };

      init.defaultBranch = "main";
      pull.rebase = false;
      push = {
        default = "simple";
        autoSetupRemote = true;
      };
      core = {
        editor = "nvim";
        autocrlf = "input";
        fsmonitor = true;
      };
      credential.helper = "cache --timeout=7200";
      merge.conflictStyle = "diff3";
      diff.colorMoved = "default";
    };

    ignores = [
      ".DS_Store" "Thumbs.db" "*.swp" ".vscode/" "node_modules/" "result"
    ];
  };

  # =========================================================================
  # DELTA - SYNTAX-HIGHLIGHTING DIFF VIEWER
  # =========================================================================
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      side-by-side = true;
      line-numbers = true;
    };
  };

  # =========================================================================
  # LAZYGIT - GIT TUI
  # =========================================================================
  programs.lazygit = {
    enable = true;
    settings = {
      disableStartupPopups = true;
      notARepository = "skip";
      update.method = "never";
      gui.nerdFontsVersion = "3";

      git.paging = {
        colorArg = "always";
        pager = "delta --dark --paging=never";
      };
    };
  };
}
# GIT USAGE:
# - Clone: git clone <url>
# - Status: git st
# - Add: git add .
# - Commit: git cm "message"
# - Push: git gph
# - Pull: git gp
# - Branch: git br
# - Log: git lg
#
# LAZYGIT USAGE:
# - Launch: lazygit
# - Navigate: arrow keys or j/k
# - Stage/unstage: space
# - Commit: c
# - Push: P
# - Pull: p
# - Quit: q
#
# GIT ALIASES:
# - st: Status
# - co: Checkout
# - br: Branch list (sorted by date)
# - lg: Pretty log graph
# - df: Diff
# - com: Commit all
# - gs: Stash
# - gp: Pull
# CREDENTIAL CACHING:
# - Credentials cached for 2 hours
# - Use SSH keys for better security
# - Generate key: ssh-keygen -t spidy
# - Add to GitHub: cat ~/.ssh/id_spidy.pub
# ============================================================================
