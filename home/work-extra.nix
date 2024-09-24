{ pkgs, ... }:

{
  programs.git.ignores = [
    ".envrc"
    "TAGS"
  ];

  home.packages = with pkgs; [
    pre-commit
  ];
}
