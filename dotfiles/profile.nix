{ pkgs }:

{
  path = [ "$HOME/.local/bin" "$HOME/bin" ];
  aliases = {
    detach = "udisksctl power-off -b";
    rmpyc = "find . | grep -E '(__pycache__|.pyc|.pyo$)' | xargs rm -rf";
    ns = "nix-shell";
    gs = "git status";
    ga = "git add";
    gc = "git c";
    gr = "git reset";
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    "....." = "cd ../../../..";
  };
}
