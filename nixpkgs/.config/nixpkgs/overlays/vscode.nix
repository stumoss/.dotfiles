self: super:
{
    vscode-with-extensions = super.vscode-with-extensions.override {
    vscodeExtensions = with super.vscode-extensions; [
      bbenoist.Nix
      ms-vscode.cpptools
    ] ++ super.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "vim";
        publisher = "vscodevim";
        version = "0.11.2";
        sha256 = "0na19ddacbr53r7vzyq8m0s9g34g98c6pdj87mdvhn3xfgqab6la";
      }
      {
        name = "doxdocgen";
        publisher = "cschlosser";
        version = "0.3.1";
        sha256 = "1bqa8x0g92zlfrs291bk5pakirnq91kqkpm036b0k0c4qbfma7is";
      }
      {
        name = "cmake-tools";
        publisher = "vector-of-bool";
        version = "1.0.1";
        sha256 = "1144p0fbp9dmv21sdajx933h8575sjwmysx1v01gy6vzn4acdk5d";
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
        name = "cppcheck";
        publisher = "matthewferreira";
        version = "0.2.2";
        sha256 = "05lx83g0j7w1b22s6qn3fn7kj95lg3yq0m7bsifv9myfkmqcaqdm";
      }
      {
        name = "vscode-docker";
        publisher = "PeterJausovec";
        version = "0.0.27";
        sha256 = "11fms5p4zk55x6w0dwasz058apc05r7bimars1w2p0yyvj2d9gzi";
      }
      {
        name = "Go";
        publisher = "ms-vscode";
        version = "0.6.84";
        sha256 = "0nq2xlv7qxfxvb1ag9dnxfm80pj7llrjnx4fvkd096jnmm3bgb0n";
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
