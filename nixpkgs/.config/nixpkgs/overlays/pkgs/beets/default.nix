{ beets, symlinkJoin, makeWrapper }:

symlinkJoin {
  name = "beets";
  buildInputs = [ makeWrapper ];
  paths = [ beets ];
  postBuild = ''
    wrapProgram "$out/bin/beet" \
    --add-flags "-c ${./beets.yml}"
  '';
}
