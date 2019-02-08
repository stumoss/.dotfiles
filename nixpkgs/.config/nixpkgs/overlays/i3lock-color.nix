self: super:
{
  userPackages = super.userPackages or {} // {
    lockscreen = super.writeScriptBin "lockscreen" ''
      #!/usr/bin/env ${super.bash}/bin/bash

      ${super.i3lock-color}/bin/i3lock-color --clock -t -i $HOME/Pictures/Desktop\ Backgrounds/Yosemite\ 3.png
    '';
  };
}
