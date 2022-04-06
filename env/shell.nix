
let
  sources = import ./nix/sources.nix;
  pkgs = import sources.stable {};
  com = import sources.community {};
in
pkgs.mkShell {
  buildInputs = [
      com.bash
      com.borgbackup
      com.coreutils
      com.curl
      com.git
      com.glibcLocales
      com.gnupg
      com.go
      com.host
      com.jq
      com.nmap
      com.openssh
      com.ssh-agents
      com.ssh-copy-id
      com.terraform
      com.tree
      com.wget
  ];
  shellHook = ''
    source ~/.bashrc
    source ./envrc
  '';
}
