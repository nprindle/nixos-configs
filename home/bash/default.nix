{ pkgs, ... }:

# Many of the settings here intentionally mirror the global interactive shell
# init settings
{
  home-manager.users.nprin = {
    programs.bash = {
      enable = true;

      shellOptions = [
        "checkwinsize"
        "extglob"
        "globstar"
        "checkjobs"
        "histappend"
        "cmdhist"
      ];

      historyControl = [ "ignorespace" "ignoredups" ];
      historySize = 1000;
      historyFileSize = 2000;
      historyIgnore = [ "ls" "cd" "exit" "history" ];

      # User-specific shell aliases
      shellAliases = with pkgs; {
        cleantex = "rm *.aux *.log *.fls *.fdb_latexmk || true";
        copylast = "fc -ln -1 | ${gawk}/bin/awk '{\$1=\$1}1' | ${xclip}/bin/xclip -sel clip";
        xc = "${xclip}/bin/xclip -sel clip";
        fakesha256 = "head --bytes 10 /dev/urandom | ${coreutils}/bin/sha256sum -b | cut -d' ' -f 1";
        nrn = "${nix}/bin/nix repl '<nixpkgs>' '<nixpkgs/nixos>'";
      };

      initExtra = ''
        set -o vi
        bind -m vi-insert "\C-l":clear-screen
      '';
    };
  };
}