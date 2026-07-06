{
  description = "<PROJECT_NAME> — tech-agnostic devShell (Backlog.md + tooling)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    # Local-first task tracker. Provides the `backlog` CLI.
    # Do NOT add `.inputs.nixpkgs.follows` here — the bun2nix build wants its pinned nixpkgs.
    backlog-md.url = "github:MrLesk/Backlog.md";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      backlog-md,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            backlog-md.packages.${system}.default # `backlog` — local-first task tracker
            pkgs.pre-commit
            pkgs.git

            # --- stack packages added at bootstrap (Q2) ---
            # e.g. pkgs.nodejs_22, pkgs.cargo, pkgs.python3, pkgs.go, …
          ];
        };
      }
    );
}
