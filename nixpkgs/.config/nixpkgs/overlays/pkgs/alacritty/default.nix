{ alacritty, symlinkJoin, makeWrapper }:

symlinkJoin {
  name = "alacritty";
  buildInputs = [ makeWrapper ];
  paths = [ alacritty ];
  postBuild = ''
    wrapProgram "$out/bin/alacritty" \
    --add-flags "--config-file ${./alacritty.yml}"
  '';
}
