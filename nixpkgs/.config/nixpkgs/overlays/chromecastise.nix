self: super:
{
  userPackages = super.userPackages or {} // {

    chromecastise = super.rustPlatform.buildRustPackage rec {
      name = "chromecastise-${version}";
      version = "v1.0.5";

      src = super.fetchFromGitHub {
        owner = "stumoss";
        repo = "chromecastise";
        rev = "${version}";
        sha256 = "183y3bpnahrqcgcdndskfxgb4rpk1lz3nj7qbh7nvljr7ba2r3i5";
      };

      cargoSha256 = "181cd3nwq0jw88biyddc4fixijspbr4ip344wpx7mkmkz15fc2sp";

      nativeBuildInputs = [
        super.openssl
        super.makeWrapper
      ];

      buildInputs = [
        super.mediainfo
        super.ffmpeg-full
      ];

      postInstall = ''
        wrapProgram $out/bin/chromecastise --prefix PATH : ${super.lib.makeBinPath [ super.mediainfo super.ffmpeg-full ]}
      '';

      preFixup = ''
        # Install completions
        mkdir -p "$out/share/"{bash-completion/completions,fish/vendor_completions.d,zsh/site-functions}
        cp target/release/build/chromecastise-*/out/chromecastise.bash "$out/share/bash-completion/completions/chromecastise"
        cp target/release/build/chromecastise-*/out/chromecastise.fish "$out/share/fish/vendor_completions.d/"
        cp target/release/build/chromecastise-*/out/_chromecastise "$out/share/zsh/site-functions/"
      '';

      meta = {
        description = "Simple wrapper around ffmpeg and mediainfo";
        homepage = "https://github.com/stumoss/chromecastise.git";
        license = super.stdenv.lib.licenses.mit;
      };
    };

  };
}
