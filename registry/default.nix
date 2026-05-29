{ ... }:
{
  nix.registry = {
    nixec = {
      from = {
        type = "indirect";
        id = "nixec";
      };
      to = {
        type = "path";
        path = ./nixec;
      };
    };
    python3-uv = {
      from = {
        type = "indirect";
        id = "python3-uv";
      };
      to = {
        type = "path";
        path = ./python3-uv;
      };
    };
  };
}
