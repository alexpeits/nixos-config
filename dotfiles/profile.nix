{ pkgs }:

{
  path = [ "$HOME/.local/bin" "$HOME/bin" ];
  aliases = {
    detach = "udisksctl power-off -b";
    rmpyc = "find . | grep -E '(__pycache__|.pyc|.pyo|.pytest_cache|.coverage|.mypy_cache$)' | xargs rm -rf";
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
    gtree = "exa --color=always --tree --git-ignore";
    ls = "exa --color=always --group-directories-first";
    cat = "bat --paging=never";
    r = "cd $(git root)";
    e = "cd ~/.emacs.d";
    n = "cd $NIXOS_CONFIG";
    po = "poetry";
  };
}
