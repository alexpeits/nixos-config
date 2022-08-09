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
    tree = "exa --color=always --tree";
    ls = "exa --color=always --group-directories-first";
    cat = "bat --paging=never";
    r = "cd $(git root)";
    e = "cd ~/.emacs.d";
    n = "cd $NIXOS_CONFIG";
    po = "poetry";
  };
}
