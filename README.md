# dotfiles

Nothing here for humans.

## How to clone

Clone without checking out the repo first,
then add filters to .git/config, then check out.
Otherwise, you'll end up with encrypted files in the worktree.

Make sure age-encrypt, age-decrypt and age-textconv are in your PATH.
You can find them unencrypted in functions/.

```
git clone --no-checkout https://example.com/repo.git
git config filter.age.required true
git config filter.age.smudge age-decrypt
git config filter.age.clean age-encrypt
git config diff.age.textconv age-textconv
git checkout --
```
