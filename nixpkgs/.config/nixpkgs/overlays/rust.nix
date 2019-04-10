self: super:
{
  userPackages = super.userPackages or {} // {
    nix-shell-rust = super.writeScriptBin "nix-shell-rust"
    ''
      #!${self.bash}/bin/bash -p

      cat <<EOF > shell.nix
      let
        moz_overlay = import (builtins.fetchTarball https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz);
        nixpkgs = import <nixpkgs> { overlays = [ moz_overlay ]; };
      in

      with nixpkgs;

      mkShell {

        buildInputs = [
          (latest.rustChannels.stable.rust.override {
            extensions = [
              "rust-src"
              "rls-preview"
              "clippy-preview"
              "rustfmt-preview"
            ];
          })

          # Add any further build inputs below
        ];
      }
      EOF

    '';

    nix-default-rust = super.writeScriptBin "nix-default-rust"
    ''
      #!${self.bash}/bin/bash -p

      cat <<EOF > default.nix
      { stdenv, rustPlatform }:

      rustPlatform.buildRustPackage rec {
        name = "''${PWD##*/}-\''${version}";
        version = "0.0.1";
        src = ./.;

        cargoSha256 = "0000000000000000000000000000000000000000000000000000";

        meta = with stdenv.lib; {
          description = "Description goes here";
          homepage = https://github.com/stumoss/''${PWD##*/};
          license = licenses.mit;
          maintainers = with maintainers; [ stumoss ];
          platforms = platforms.all;
        };
      }
      EOF
    '';
  };
}
