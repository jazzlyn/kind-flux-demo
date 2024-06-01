let
  pkgs = import <nixpkgs> {};
in
  pkgs.mkShell {
    packages = [
      pkgs.age
      pkgs.direnv
      pkgs.go-task
      pkgs.kubernetes-helm
      pkgs.kustomize
      pkgs.pre-commit
      pkgs.sops
      pkgs.terraform
      pkgs.terraform-docs
      pkgs.tflint
      pkgs.trivy
    ];
  }
