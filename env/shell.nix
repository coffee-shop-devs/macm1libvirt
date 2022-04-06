let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs {};
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    bash
    coreutils
    findutils
    curl
    git
    glibcLocales
    gnupg
    go
    #host
    jq
    nmap
    openssh
    ssh-agents
    terraform
    tree
    wget
    #niv
  ];
  shellHook = ''
    source ~/.bashrc
    source ./envrc
  '';
}