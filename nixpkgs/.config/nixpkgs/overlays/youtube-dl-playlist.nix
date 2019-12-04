self: super: {
  userPackages = super.userPackages or { } // {
    youtube-dl-playlist = super.writeScriptBin "youtube-dl-playlist" ''
      #!${super.bash}/bin/bash -p
      set -euo pipefail

      VERSION=1.0.0

      function usage()
      {
        echo "$(basename $0) $VERSION"
        echo "Stuart Moss <samoss@gmail.com>"
        echo ""
        echo "USAGE:"
        echo " $(basename $0) [FLAGS] <playlist url>"
        echo ""
        echo "FLAGS:"
        echo "  -h, --help      Prints help information"
        echo "  -v, --version   Prints version information"
        echo ""
        echo "ARGS:"
        echo "  <playlist url>  The url of the youtube playlist to download"
        echo ""
      }

      while :
      do
          case "$1" in
            -h | --help)
                usage
                # no shifting needed here, we're done.
                exit 0
                ;;
            -v | --version)
                usage
                exit 0
                ;;
            --) # End of all options
                shift
                break;
                ;;
            -*)
                echo "Error: Unknown option: $1" >&2
                exit 1
                ;;
            *)  # No more options
                break
                ;;
          esac
      done

      ${super.youtube-dl}/bin/youtube-dl --extract-audio --audio-format mp3 -o "%(title)s.%(ext)s" $1
    '';
  };
}
