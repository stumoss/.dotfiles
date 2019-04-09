self: super:
{
  userPackages = super.userPackages or {} // {
    nix-build-callpackage = super.writeScriptBin "nix-build-callpackage"
    ''
      #!${super.bash}/bin/bash -p
      exec nix-build -E "with import <nixpkgs> {}; callPackage $(realpath ''${1}) {}"
    '';

    nix-rebuild = super.writeScriptBin "nix-rebuild"
    ''
      #!${super.bash}/bin/bash -p
      exec nix-env -f '<nixpkgs>' -r -iA userPackages
    '';
  };
}
