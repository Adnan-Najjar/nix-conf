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
        path = toString ./nixec;
      };
    };
    python3-uv = {
      from = {
        type = "indirect";
        id = "python3-uv";
      };
      to = {
        type = "path";
        path = toString ./python3-uv;
      };
    };
  };
}
