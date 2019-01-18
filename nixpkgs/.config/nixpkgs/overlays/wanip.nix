self: super:
{
  userPackages = super.userPackages or {} // {
    wanip = self.writeShellScriptBin "wanip" "dig +short myip.opendns.com @resolver1.opendns.com";
  };
}
