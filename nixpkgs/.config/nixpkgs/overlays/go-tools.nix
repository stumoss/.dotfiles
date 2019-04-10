self: super:
{
  userPackages = super.userPackages or {} // {
    nix-shell-go = super.writeScriptBin "nix-shell-go"
    ''
      #!${super.bash}/bin/bash -p

      cat <<EOF > shell.nix
      { pkgs ? import <nixpkgs> {} }:

      with pkgs;

      mkShell {
        buildInputs = [
          go
          go-static-build
          go-wasm-exec
        ];
      }
      EOF
    '';

    nix-default-go = super.writeScriptBin "nix-default-go"
    ''
      #!${super.bash}/bin/bash -p

      cat <<EOF > default.nix
      { buildGoModule, fetchFromGitHub, lib }:

      buildGoModule rec {
        name = "''${PWD##*/}-\''${version}";
        version = "0.0.1";

        src = ./.;

        #src = fetchFromGitHub {
        #  owner = "stumoss";
        #  repo = "''${PWD##*/}";
        #  rev = "v\''${version}";
        #  sha256 = "0000000000000000000000000000000000000000000000000000";
        #};

        modSha256 = "0000000000000000000000000000000000000000000000000000";

        meta = with lib; {
          description = "Description goes here";
          homepage = https://github.com/stumoss/''${PWD##*/};
          license = licenses.mit;
          maintainers = with maintainers; [ stumoss ];
          platforms = platforms.all
        };
      }


      EOF
    '';
  };

  go-static-build = super.writeScriptBin "go-static-build"
  ''
    #!${super.bash}/bin/bash -p
    CGO_ENABLED=0 ${super.go}/bin/go build -a -ldflags '-extldflags "-static"' $@
  '';

  go-wasm-exec = super.writeScriptBin "go-wasm-exec"
  ''
    #!/usr/bin/env ${super.bash}/bin/bash
    GOOS=js GOARCH=wasm ${super.go}/bin/go run -exec="$(${super.go}/bin/go env GOROOT)/misc/wasm/go_js_wasm_exec" "$@"
  '';
}
