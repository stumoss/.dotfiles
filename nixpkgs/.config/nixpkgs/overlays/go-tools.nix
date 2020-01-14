self: super: {

  go-tools = super.buildGoModule rec {
    pname = "go-tools";
    version = "0.2.1";
    rev = "08e24063958e5e317347cebd02a9ff7737109f18";

    src = super.fetchFromGitHub rec {
      owner = "golang";
      repo = "tools";
      inherit rev;
      sha256 = "0jkqnd9rpi92y0sg4arxx7k81wiswdijmbw1p3h70fhrsd9cqx9x";

    };

    modSha256 = "16cfzmfr9jv8wz0whl433xdm614dk63fzjxv6l1xvkagjmki49iy";
    subPackages = [ "cmd/gopls" "cmd/stringer" "cmd/godoc" "cmd/gomvpkg" ];
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
    version = "1.22.2";
    rev = "645e79404d82daf769881148422db5b511bbc34f";

    src = super.fetchFromGitHub rec {
      owner = "golangci";
      repo = "golangci-lint";
      inherit rev;
      sha256 = "0knvb59mg9jrzmfs5nzglz4nv047ayq1xz6dkis74wl1g9xi6yr5";
    };

    modSha256 = "1b2qdc5j5dmmfjnc7pcpxaiflddm0fjnr6jb6b2ljdhzrcz1206z";

    subPackages = [ "cmd/golangci-lint" ];

    buildFlagsArray = ''
      -ldflags=
      -s -w
      -X main.version=${version}
      -X main.commit=${builtins.substring 0 7 rev}
      -X main.date=unknown
    '';

    meta = with super.lib; {
      description =
        "Linters Runner for Go. 5x faster than gometalinter. Nice colored output.";
      homepage = "https://golangci.com/";
      license = licenses.agpl3;
      platforms = platforms.unix;
      maintainers = with maintainers; [ anpryl manveru ];
    };
  };

  pkger = super.buildGoModule rec {
    pname = "pkger";
    version = "0.12.5";
    rev = "3f76ab6dd9a48dc8d4fc85f8ceac31f5c04166f6";

    src = super.fetchFromGitHub rec {
      owner = "markbates";
      repo = "pkger";
      inherit rev;
      sha256 = "1cijjxjhpr2m77bxschh7c7simfx350mkp9gn7bjwj1i2l8gpy7d";
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

  gotests = super.buildGoModule rec {
    name = "gotests";
    version = "62fe1b80bbe2c4c7cb0ab26d868795b47475ab90";
    rev = "62fe1b80bbe2c4c7cb0ab26d868795b47475ab90";

    src = super.fetchFromGitHub rec {
      owner = "cweill";
      repo = "gotests";
      inherit rev;
      sha256 = "03ak0wx33b7ziqrdmra4bm9lcjdqc6y7i3fp2yd5x5m0bg46r86h";
    };

    modSha256 = "0sqxbg0iin0b25yrrmm43n3fc68z4g5nbz19gmbajlvglyjw7pgk";

    meta = with super.lib; {
      description = "Generate Go tests from your source code";
      homepage = "https://github.com/cweill/gotests";
      platforms = platforms.all;
    };
  };

  go-mutesting = super.buildGoModule rec {
    name = "go-mutesting";
    version = "1.1.0";
    rev = "90970dc0b939b75fc30077d8b3f1e67cb5103981";

    src = super.fetchFromGitHub rec {
      owner = "srikrsna";
      repo = "go-mutesting";
      inherit rev;
      sha256 = "017918ijfxgg57j670vm00vsy8l1qcjmnbpp5m2cy3wlry28hahp";
    };

    modSha256 = "0qfg53zrhx9kfahgspgdfzixdxd0pr41hf06jvsgzig8mk8yxlcx";

    meta = with super.lib; {
      description = "Mutation testing for Go source code";
      homepage = "https://github.com/srikrsna/go-mutesting";
      license = licenses.mit;
      platforms = platforms.all;
    };
  };

  go-static-build = super.writeScriptBin "go-static-build" ''
    #!${super.bash}/bin/bash -p
    CGO_ENABLED=0 ${super.go}/bin/go build -a -ldflags '-extldflags "-static"' $@
  '';

  go-wasm-exec = super.writeScriptBin "go-wasm-exec" ''
    #!/usr/bin/env ${super.bash}/bin/bash
    GOOS=js GOARCH=wasm ${super.go}/bin/go run -exec="$(${super.go}/bin/go env GOROOT)/misc/wasm/go_js_wasm_exec" "$@"
  '';

  nix-shell-go = super.writeScriptBin "nix-shell-go" ''
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

  nix-default-go = super.writeScriptBin "nix-default-go" ''
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

  userPackages = super.userPackages or { } // {
    go = super.go;
    go-tools = self.go-tools;
    gotests = self.gotests;
    delve = super.delve;
    errcheck = super.errcheck;
    go-check = super.go-check;
    goconst = super.goconst;
    gocyclo = super.gocyclo;
    golint = super.golint;
    golangci-lint = self.golangci-lint;
    gomock = self.gomock;
    pgker = self.pkger;
    ghz = self.ghz;
    go-mutesting = self.go-mutesting;
    gomodifytags = super.gomodifytags;
    go-static-build = self.go-static-build;
    go-wasm-exec = self.go-wasm-exec;
    nix-shell-go = self.nix-shell-go;
    nix-default-go = self.nix-default-go;
  };
}
