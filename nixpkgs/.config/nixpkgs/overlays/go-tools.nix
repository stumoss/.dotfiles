self: super:
{
  userPackages = super.userPackages or {} // {
    go = super.go;
    gotests = super.gotests;
    delve = super.delve;
    golangci-lint = super.golangci-lint;
    errcheck = super.errcheck;
    go-check = super.go-check;
    gotools = super.gotools;
    goconst = super.goconst;
    gocyclo = super.gocyclo;
    golint = super.golint;

    gofumpt = super.buildGoModule rec {
      name = "gofumpt";

      src = super.fetchFromGitHub {
        rev = "96300e3d49fbb3b7bc9c6dc74f8a5cc0ef46f84b";
        owner = "mvdan";
        repo = "gofumpt";
        sha256 = "169hwggbhlr6ga045d6sa7xsan3mnj19qbh63i3h4rynqlppzvpf";
      };

      modSha256 = "1g7dkl60zwlk4q2gwx2780xys8rf2c4kqyy8gr99s5y342wsbx2g";
    };

    gomock = super.buildGoModule rec {
      name = "gomock";
      version = "1.3.1";

      src = super.fetchFromGitHub {
        rev = "d74b93584564161b2de771089ee697f07d8bd5b5";
        owner = "golang";
        repo = "mock";
        sha256 = "1wnfa8njxdym1qb664dmfnkpm4pmqy22hqjlqpwaaiqhglb5g9d1";
      };

      modSha256 = "1wvf6nfws4z1v59qg516k0knac8p59svpm1gqh3m00y4g3zsmyx8";
    };

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
          gotests = super.gotests;
          delve = super.delve;
          golangci-lint = super.golangci-lint;
          errcheck = super.errcheck;
          go-check = super.go-check;
          gotools = super.gotools;
          goconst = super.goconst;
          gocyclo = super.gocyclo;
          golint = super.golint;
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
          platforms = platforms.all;
        };
      }
      EOF
    '';

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
    };
}
