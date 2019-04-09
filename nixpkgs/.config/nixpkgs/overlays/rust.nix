self: super:
{
  userPackages = super.userPackages or {} // {
    nix-shell-rust = super.writeScriptBin "nix-shell-rust"
    ''
      #!${self.bash}/bin/bash
      et -euxo pipefail

      cat <<EOF > shell.nix
      let
        moz_overlay = import (builtins.fetchTarball https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz);
        nixpkgs = import <nixpkgs> { overlays = [ moz_overlay ]; };
      in

      with nixpkgs;

      mkShell {
        buildInputs = [
          gitAndTools.gitFull
          gitAndTools.hub
          latest.rustChannels.stable.rust
        ];
      }
      EOF
    '';

    nix-default-rust = super.writeScriptBin "nix-default-rust"
    ''
      #!${self.bash}/bin/bash
      set -euxo pipefail

      cat <<EOF > default.nix
      { stdenv, rustPlatform }

      rustPlatform.buildRustPackage rec {
        name = "''${PWD##*/}-''${version}";
        version = "0.0.1";
        src = ./.;

        cargoSha256 = "0000000000000000000000000000000000000000000000000000";

        meta = with stdenv.lib; {
          description = "";
          homepage = null;
          license = licenses.unlicense;
          maintainers = [ maintainers.stumoss ];
          platforms = platforms.all;
        };
      }
      EOF
    '';
  };
}
