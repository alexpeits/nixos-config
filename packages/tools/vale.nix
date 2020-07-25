{ pkgs }:

let

  version = "2.2.2";
  rev = "2ce708ce6bbecba0d73440f0ad5a534e6a865a67";
  sha256 = "0k1vjbfijfvs1jrbdpm1kcrjrrq7ggd06ixamp4qxni6qgrr7286";

  vale = pkgs.vale.overrideAttrs (old: {
    version = version;
    src = pkgs.fetchFromGitHub {
      owner = "errata-ai";
      repo = "vale";
      rev = rev;
      sha256 = sha256;
    };
    # goPackagePath = "github.com/errata-ai/vale/vendor";
  });

in

vale
