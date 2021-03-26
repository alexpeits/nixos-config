{ pkgs }:

let

  runNode2nix = { pkg, version ? null, node-version ? 12 }:
    let
      node-pkg = if isNull version then pkg else { "${pkg}" = version; };
      pkg-ver = if isNull version then pkg else "${pkg}-${version}";
      node-packages =
        pkgs.writeText "node-packages-${pkg-ver}" (builtins.toJSON [ node-pkg ]);
    in
    pkgs.stdenv.mkDerivation {
      name = "node2nix-${pkg-ver}";
      buildInputs = [ pkgs.nodePackages.node2nix ];
      phases = [ "installPhase" ];
      installPhase = ''
        mkdir -p $out
        cd $out
        node2nix -i ${node-packages} --nodejs-${toString node-version}
      '';
    };

  buildNodePackage = { pkg, version ? null, node-version ? 12 }:
    let
      drv = runNode2nix { pkg = pkg; version = version; node-version = node-version; };
      attr = if isNull version then pkg else "${pkg}-${version}";
    in
    (pkgs.callPackage drv { })."${attr}";

in

{
  runNode2nix = runNode2nix;
  buildNodePackage = buildNodePackage;
}
