self: super:
{
    gopls = super.buildGoModule rec {
      pname = "gopls";
      version = "0.2.0";
      rev = "14c9c2854651f7c48c91b36cdf09270b3ee74ed8";

      src = super.fetchFromGitHub rec {
        owner = "golang";
        repo = "tools";
        inherit rev;
        sha256 = "07f530v2hr6a7siz35i03jrazj0qj5y40ps334110h49kwi9ysiw";
      };

      modSha256 = "16cfzmfr9jv8wz0whl433xdm614dk63fzjxv6l1xvkagjmki49iy";

      subPackages = [ "cmd/gopls" ];
    };

    staticcheck = super.buildGoModule rec {
      name = "staticcheck";
      version = "2019.2.3";

      src = super.fetchFromGitHub {
        rev = "afd67930eec2a9ed3e9b19f684d17a062285f16a";
        owner = "dominikh";
        repo = "go-tools";
        sha256 = "1rwwahmbs4dwxncwjj56likir1kps9937vm2id3rygxzzla40zal";
      };

      modSha256 = "0ysaq94m7pkziliz4z4dl8ad84mbn17m2hqxvs9wbw4iwhkpi7gz";
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

    golangci-lint = super.buildGoModule rec {
      name = "golangci-lint";
      version = "1.20.0";
      rev = "cc98739c05ad37d5a4ea904b60034311cfbe5ba6";

      src = super.fetchFromGitHub rec {
        owner = "golangci";
        repo = "golangci-lint";
        inherit rev;
        sha256 = "1ca7l8smi1hx2sk6sq1cac9bvij4wnxxmwldbk8r1ih8ja5i6vdk";
      };

      modSha256 = "04l8ijg5swg6fvzw2i84y3arngxb13hgyn77szqi7nw9n716l4l4";

      subPackages = [ "cmd/golangci-lint" ];

      buildFlagsArray = ''
        -ldflags=
        -s -w
        -X main.version=${version}
        -X main.commit=${builtins.substring 0 7 rev}
        -X main.date=unknown
      '';

      meta = with super.lib; {
        description = "Linters Runner for Go. 5x faster than gometalinter. Nice colored output.";
        homepage = https://golangci.com/;
        license = licenses.agpl3;
        platforms = platforms.unix;
        maintainers = with maintainers; [ anpryl manveru ];
      };
    };

    pkger = super.buildGoModule rec {
      pname = "pkger";
      version = "0.12.4";
      rev = "338906395e7b02b7aaf458437d7a9365ca09cbe2";

      src = super.fetchFromGitHub rec {
        owner = "markbates";
        repo = "pkger";
        inherit rev;
        sha256 = "116nyhiyv4vk9gbv1agl8sy5vrsz7mgj8aybszz995cvv4nsrgd0";
      };

      modSha256 = "129afls4mzjjkqpg9dc4pkfbri9718rcais4nsxkaalybgrafv4c";

      subPackages = [ "cmd/pkger" ];

      meta = with super.lib; {
        desciption = "Embed static files in Go binaries";
        homepage = "https://github.com/markbates/pkger";
        license = licenses.mit;
        platforms = platforms.all;
      };
    };

    ghz = super.buildGoModule rec {
      pname = "ghz";
      version = "0.44.0";
      rev = "19709930046bf062aa997590e8c4765afc424f21";

      src = super.fetchFromGitHub rec {
        owner = "bojand";
        repo = "ghz";
        inherit rev;
        sha256 = "1nsr9lawbv1fl1kaghyqsmikd2k6xn7ksj10rzsh7rih90n2rpq2";
      };

      modSha256 = "1hf3qpq3j3i1w3hzng5fkww4y28qgpdxiakibclbpvbkm52af9m9";

      meta = with super.lib; {
        description = "Simple gRPC benchmarking and load testing tool";
        homepage = "https://ghz.sh/";
        license = licenses.asl20;
        platforms = platforms.all;
      };
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

    nix-shell-go = super.writeScriptBin "nix-shell-go"
      ''
        #!${super.bash}/bin/bash -p

        cat <<EOF > shell.nix
        { pkgs ? import <nixpkgs> {} }:

        with pkgs;

        mkShell {
          buildInputs = [
            go
            gotests
            delve
            golangci-lint
            errcheck
            go-check
            goconst
            gocyclo
            golint
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
          #  sha256 = lib.fakeSha256;
          #};

          modSha256 = lib.fakeSha256;

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

  userPackages = super.userPackages or {} // {
    go = super.go_1_13;
    gotests = super.gotests;
    delve = super.delve;
    errcheck = super.errcheck;
    go-check = super.go-check;
    goconst = super.goconst;
    gocyclo = super.gocyclo;
    golint = super.golint;
    gopls = self.gopls;
    staticcheck = self.staticcheck;
    golangci-lint = self.golangci-lint;
    gomock = self.gomock;
    pgker = self.pkger;
    ghz = self.ghz;
    go-static-build = self.go-static-build;
    go-wasm-exec = self.go-wasm-exec;
    nix-shell-go = self.nix-shell-go;
    nix-default-go = self.nix-default-go;
  };
}
