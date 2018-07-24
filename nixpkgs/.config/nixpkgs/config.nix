with import <nixpkgs> {};

{
  allowUnfree = true;

  chrome = {
    enablePepperFlash = true;
  };
}
