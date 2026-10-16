# gitwarp

Jump back to a branch you had checked out recently.

Run `gitwarp` inside any git repository and it lists the last 50 branches you
checked out, most recent first, straight from the reflog. Move with the arrow
keys (or `j`/`k`), press Enter to switch to the highlighted branch, or `q` to
leave things as they are. Branches that have since been deleted are left out,
and the one you are on is marked with `*`.

```
  recent branches (Enter to switch, q to quit)
* feature/table-column-virtualisation
  feature/omni-table-expandable-rows
  production
  fix/login-redirect
```

## Install

It is a single Python 3 script with no dependencies beyond git. Put it
somewhere on your `PATH`:

```sh
curl -fsSL https://raw.githubusercontent.com/harvkay/gitwarp/main/gitwarp -o ~/.local/bin/gitwarp
chmod +x ~/.local/bin/gitwarp
```

If `~/.local/bin` is not on your `PATH` yet, add it (`fish_add_path ~/.local/bin`
in fish, or `export PATH="$HOME/.local/bin:$PATH"` in your bash or zsh profile).

## Usage

```
gitwarp           menu of up to 50 recent branches
gitwarp -n 20     shorter history
gitwarp --list    print the list and exit, no menu
```

Switching uses `git switch`, so an uncommitted change that would be
overwritten, or a branch checked out in another worktree, stops it with git's
usual message.
