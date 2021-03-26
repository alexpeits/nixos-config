{ pkgs }:

let

  runNode2nix = { pkg, version ? null, node-version ? 12 }:
    let
      package =
        if isNull version
        then ''"${pkg}"''
        else ''{ "${pkg}": "${version}" }'';
      showVersion = if isNull version then "" else "-${version}";
    in
    pkgs.stdenv.mkDerivation {
      name = "node2nix-${pkg}-${version}";
      buildInputs = [ pkgs.nodePackages.node2nix ];
      phases = [ "installPhase" ];
      installPhase = ''
        mkdir -p $out
        cd $out
        node2nix -i <(echo '[${package}]') --nodejs-${toString node-version}
      '';
    };

  buildNodePackage = { pkg, version ? null, node-version ? 12 }:
    let
      drv = runNode2nix { pkg = pkg; version = version; node-version = node-version; };
      package = if isNull version then pkg else "${pkg}-${version}";
    in
    (pkgs.callPackage drv { })."${package}";

in

{
  runNode2nix = runNode2nix;
  buildNodePackage = buildNodePackage;
}
