{
  inputs = { nixpkgs.url = "nixpkgs/nixos-21.05"; };

  outputs = { self, nixpkgs }:
    let
      makeOverlay = name: final: prev: {
        "${name}" = prev.callPackage (./. + "/packages/${name}.nix") {
          "${name}" = prev."${name}";
        };
      };
      overlays = with nixpkgs.lib;
        mapAttrs' (path: _:
          let name = (removeSuffix ".nix" path);
          in nameValuePair name (makeOverlay name))
        (builtins.readDir ./packages);
    in { inherit overlays; };
}
