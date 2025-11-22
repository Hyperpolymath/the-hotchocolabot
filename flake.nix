{
  description = "HotChocolaBot - Educational Robotics Platform for Teaching Reverse Engineering";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, rust-overlay, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };

        rustToolchain = pkgs.rust-bin.stable.latest.default.override {
          extensions = [ "rust-src" "rustfmt" "clippy" ];
          targets = [
            "armv7-unknown-linux-gnueabihf"  # Raspberry Pi
          ];
        };

        # Native build inputs for x86_64
        nativeBuildInputs = with pkgs; [
          rustToolchain
          pkg-config
          just  # Build automation
          cargo-audit  # Security auditing
          cargo-watch  # Auto-rebuild
          cargo-tarpaulin  # Code coverage
        ];

        # Build inputs for the application
        buildInputs = with pkgs; [
          # For Raspberry Pi GPIO/I2C (when building on Linux)
        ] ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
          # Linux-specific dependencies
        ];

        # Environment variables
        shellEnv = {
          RUST_BACKTRACE = "1";
          RUST_LOG = "debug";
        };

      in
      {
        # Development shell
        devShells.default = pkgs.mkShell ({
          inherit buildInputs nativeBuildInputs;

          shellHook = ''
            echo "🤖 HotChocolaBot Development Environment"
            echo ""
            echo "Rust toolchain: ${rustToolchain.name}"
            echo "Just version: $(just --version)"
            echo ""
            echo "Quick commands:"
            echo "  just run       - Run with mock hardware"
            echo "  just test      - Run tests"
            echo "  just validate  - Full validation"
            echo "  just --list    - All available commands"
            echo ""
            echo "Cross-compile for Raspberry Pi:"
            echo "  just build-rpi"
            echo ""
            echo "RSR compliance check:"
            echo "  just rsr-check"
            echo ""
          '';
        } // shellEnv);

        # Package definition for HotChocolaBot
        packages.default = pkgs.rustPlatform.buildRustPackage {
          pname = "hotchocolabot";
          version = "0.1.0";

          src = ./.;

          cargoLock = {
            lockFile = ./Cargo.lock;
          };

          nativeBuildInputs = nativeBuildInputs;
          buildInputs = buildInputs;

          # Skip tests during build (run separately)
          doCheck = false;

          meta = with pkgs.lib; {
            description = "Educational robotics platform teaching reverse engineering through an over-engineered hot chocolate dispenser";
            homepage = "https://github.com/Hyperpolymath/the-hotchocolabot";
            license = with licenses; [ mit asl20 ];
            maintainers = [ ];
            platforms = platforms.linux;
          };
        };

        # Package for Raspberry Pi (cross-compiled)
        packages.rpi = pkgs.pkgsCross.armv7l-hf-multiplatform.rustPlatform.buildRustPackage {
          pname = "hotchocolabot-rpi";
          version = "0.1.0";

          src = ./.;

          cargoLock = {
            lockFile = ./Cargo.lock;
          };

          nativeBuildInputs = nativeBuildInputs;
          buildInputs = buildInputs;

          doCheck = false;

          meta = with pkgs.lib; {
            description = "HotChocolaBot for Raspberry Pi (armv7)";
            homepage = "https://github.com/Hyperpolymath/the-hotchocolabot";
            license = with licenses; [ mit asl20 ];
            platforms = [ "armv7l-linux" ];
          };
        };

        # Apps for easy execution
        apps.default = flake-utils.lib.mkApp {
          drv = self.packages.${system}.default;
          exePath = "/bin/hotchocolabot";
        };

        # Formatter (for 'nix fmt')
        formatter = pkgs.nixpkgs-fmt;

        # Checks (for 'nix flake check')
        checks = {
          # Format check
          fmt-check = pkgs.runCommand "fmt-check" {
            buildInputs = [ rustToolchain ];
          } ''
            cd ${./.}
            cargo fmt --all -- --check
            touch $out
          '';

          # Clippy check
          clippy-check = pkgs.runCommand "clippy-check" {
            buildInputs = [ rustToolchain ] ++ nativeBuildInputs ++ buildInputs;
          } ''
            cd ${./.}
            cargo clippy --all-targets --all-features -- -D warnings
            touch $out
          '';

          # Test check
          test-check = pkgs.runCommand "test-check" {
            buildInputs = [ rustToolchain ] ++ nativeBuildInputs ++ buildInputs;
          } ''
            cd ${./.}
            cargo test --verbose
            touch $out
          '';

          # Audit check
          audit-check = pkgs.runCommand "audit-check" {
            buildInputs = [ rustToolchain pkgs.cargo-audit ];
          } ''
            cd ${./.}
            cargo audit
            touch $out
          '';

          # Build check
          build-check = self.packages.${system}.default;
        };
      }
    );

  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
}
