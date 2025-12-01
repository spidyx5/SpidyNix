# /etc/nixos/SpidyNix/Homes/devs/git.nix
{ config, pkgs, lib, ... }:
{
  # ============================================================================
  # GIT CONFIGURATION
  # ============================================================================
  programs.git = {
    enable = true;  # Enable Git
    lfs.enable = true;  # Enable Git LFS

    # NEW FORMAT: All config goes into 'settings'
    settings = {
      # User Identity
      user = {
        name = "spidyx5";  # Git user name
        email = "spidyx5@duck.com";  # Git user email
      };

      # Aliases (Previously 'aliases')
      alias = {
        st = "status";  # Status alias
        s = "status --short";  # Short status alias
        co = "checkout";  # Checkout alias
        br = "branch --sort=-committerdate";  # Branch list sorted by date
        cm = "commit -m";  # Commit with message
        lg = "log --graph --pretty=format:'%Cred%h%Creset - %C(yellow)%d%Creset %s %C(green)(%cr)%C(bold blue) <%an>%Creset' --abbrev-commit";  # Pretty log graph
        df = "diff";  # Diff alias
        gp = "pull";  # Pull alias
        gph = "push";  # Push alias
        unstage = "reset HEAD --";  # Unstage alias
      };

      # Core Config (Previously 'extraConfig')
      init.defaultBranch = "main";  # Default branch name
      pull.rebase = false;  # Disable rebase on pull
      push = {
        default = "simple";  # Default push behavior
        autoSetupRemote = true;  # Auto setup remote
      };
      core = {
        editor = "nvim";  # Default editor
        autocrlf = "input";  # Auto CRLF handling
        fsmonitor = true;  # Enable filesystem monitor
      };
      credential.helper = "cache --timeout=7200";  # Credential cache timeout
      merge.conflictStyle = "diff3";  # Merge conflict style
      diff.colorMoved = "default";  # Diff color moved
    };

    # Ignores remain top-level
    ignores = [
      ".DS_Store" "Thumbs.db" "*.swp" ".vscode/" "node_modules/" "result"
    ];
  };

  # ============================================================================
  # DELTA (Now a separate module)
  # ============================================================================
  programs.delta = {
    enable = true;  # Enable Delta
    enableGitIntegration = true;  # Enable Git integration
    options = {
      navigate = true;  # Enable navigation
      side-by-side = true;  # Enable side-by-side view
      line-numbers = true;  # Enable line numbers
    };
  };

  # ============================================================================
  # LAZYGIT
  # ============================================================================
  programs.lazygit = {
    enable = true;  # Enable Lazygit
    settings = {
      disableStartupPopups = true;  # Disable startup popups
      notARepository = "skip";  # Skip if not a repository
      update.method = "never";  # Disable auto-update
      gui.nerdFontsVersion = "3";  # Nerd fonts version

      git.paging = {
        colorArg = "always";  # Always use color
        pager = "delta --dark --paging=never";  # Use Delta as pager
      };
    };
  };
}
# ============================================================================
# GIT & LAZYGIT CONFIGURATION
# ============================================================================
# ============================================================================
# NOTES
# ============================================================================
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
#
# CONFIGURATION:
# - Change userEmail above to your actual email
# - Modify aliases as needed
# - Add more ignores to global gitignore
#
# CREDENTIAL CACHING:
# - Credentials cached for 2 hours
# - Use SSH keys for better security
# - Generate key: ssh-keygen -t spidy
# - Add to GitHub: cat ~/.ssh/id_spidy.pub
# ============================================================================
