self: super:
{
  self.rust = (import super.builtins.fetchTarball https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz).latest.rustChannels.stable.rust
}

