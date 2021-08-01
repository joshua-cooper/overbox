{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-21.05";
  };

  outputs = { self, nixpkgs }:
    let
      makeOverlay = name: final: prev: {
        "${name}" = prev.callPackage (./. + "/packages/${name}.nix") {
          "${name}" = prev."${name}";
        };
      };
    in {
      overlays = with nixpkgs.lib;
        mapAttrs' (path: _:
          let name = (removeSuffix ".nix" path);
          in nameValuePair name (makeOverlay name))
        (builtins.readDir ./packages);
      packages."x86_64-linux" =
        let
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            overlays = builtins.attrValues self.overlays;
          };
        in builtins.mapAttrs (name: _: pkgs."${name}") self.overlays;
    };
}
