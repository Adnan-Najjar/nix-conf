{
  description = "Standalone Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      firefox-addons,
      nixpkgs-stable,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs-stable = import nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
      };
      user = {
        username = "adnan";
        fullName = "Adnan Najjar";
        email = "adnan.najjar1@gmail.com";
      };
    in
    {
      homeConfigurations = {
        adnan = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./modules
            {
              home = {
                username = "adnan";
                homeDirectory = "/home/adnan";
                stateVersion = "25.05";
              };
            }
          ];
          extraSpecialArgs = {
            inherit
              pkgs-stable
              firefox-addons
              inputs
              user
              ;
          };
        };
      };
    };
}
