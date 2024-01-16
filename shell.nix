let
  pkgs = import <nixpkgs> {};
in
  pkgs.mkShell {
    packages = [
      pkgs.age
      pkgs.arkade
      pkgs.direnv
      pkgs.docker
      pkgs.fluxcd
      pkgs.go
      pkgs.go-task
      pkgs.kustomize
      pkgs.pre-commit
      pkgs.sops
      pkgs.terraform
      pkgs.terraform-docs
      pkgs.tflint
    ];
  }
