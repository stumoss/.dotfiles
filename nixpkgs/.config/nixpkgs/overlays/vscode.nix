self: super: {
  vscode-with-extensions = super.vscode-with-extensions.override {
    vscodeExtensions = with super.vscode-extensions;
      [ bbenoist.Nix ms-vscode.cpptools ]
      ++ super.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "vim";
          publisher = "vscodevim";
          version = "1.0.8";
          sha256 = "0yqfn8b2jfrijzf731sggyvik2immlx9hfgmsgp1mx01hpyisd9r";
        }
        {
          name = "doxdocgen";
          publisher = "cschlosser";
          version = "0.4.1";
          sha256 = "06f4nxjd5ph66bhlyjim87haams286sjhrw7vmiv2rckzinygh1h";
        }
        {
          name = "cmake-tools";
          publisher = "vector-of-bool";
          version = "1.1.3";
          sha256 = "1x9ph4r742dxj0hv6269ngm7w4h0n558cvxcz9n3cg79wpd7j5i5";
        }
        {
          name = "cmake-tools-helper";
          publisher = "maddouri";
          version = "0.2.1";
          sha256 = "04dqg3qvfhgs8v4yck2qy7137f78vvgg198wbwb22xkmy6cnljfy";
        }
        {
          name = "cmake";
          publisher = "twxs";
          version = "0.0.17";
          sha256 = "11hzjd0gxkq37689rrr2aszxng5l9fwpgs9nnglq3zhfa1msyn08";
        }
        {
          name = "vscode-docker";
          publisher = "PeterJausovec";
          version = "0.5.2";
          sha256 = "1nrwsgg3kslsy4v0pq64bqazi5s6a823inxmhdpw93wigb1yqc7i";
        }
        {
          name = "Go";
          publisher = "ms-vscode";
          version = "0.9.1";
          sha256 = "1dq3kfxdvrbwa4sv21na0jvmb35yx0g1j8dfpjzff617j43bjplg";
        }
        {
          name = "cquery";
          publisher = "cquery-project";
          version = "0.1.10";
          sha256 = "0waadz2w9wzfhf84z1pk0z7v3xmk3zx36saq9qriw0sxrdl5frpd";
        }
      ];
  };
}
