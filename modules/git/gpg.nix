{ ... }:
{
  programs.gpg = {
    enable = true;
    publicKeys = [
      {
        source = ./public-key.txt;
        trust = 5;
      }
    ];
  };
}
