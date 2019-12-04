self: super: {
  userPackages = super.userPackages or { } // {
    wanip =
      self.writeShellScriptBin "wanip" "${super.curl}/bin/curl ifconfig.me";
  };
}
