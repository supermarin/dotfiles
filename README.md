# dotfiles
[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

Nothing here for humans.


## How to clone

Clone without checking out the repo first,
then add filters to .git/config, then check out.
Otherwise, you'll end up with encrypted files in the worktree.

Make sure functions/ are in your PATH.
```
git clone --no-checkout https://example.com/repo.git
git config filter.age.required true
git config filter.age.smudge age-decrypt
git config filter.age.clean age-clean %f
git config diff.age.textconv age-textconv
git checkout --
```
