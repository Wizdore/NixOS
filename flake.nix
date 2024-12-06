{
  description = "NixOS Installation Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; 
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-anywhere = {
      url = "github:nix-community/nixos-anywhere";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, disko, nixos-anywhere, ... }@inputs: {
    # Single command installation target
    nixosConfigurations.swift = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        disko.nixosModules.disko
        {
          # Direct disk configuration
          disko.devices = import ./disko-config.nix;
        }
        ./configuration.nix
        
        # Additional installation settings
        {
          # Custom installation script
          system.build.installBootLoader = ''
            # Custom boot loader installation steps if needed
            $SUDO_COMMAND bootctl install
          '';
        }
      ];
    };
  };
}
