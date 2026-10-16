# gitwarp

Jump back to a branch you had checked out recently.

Run `gitwarp` inside any git repository and it lists the last 50 branches you
checked out, most recent first, straight from the reflog. Move with the arrow
keys (or `j`/`k`), press Enter to switch to the highlighted branch, or `q` to
leave things as they are. Branches that have since been deleted are left out,
and the one you are on is marked with `*`.

```
  recent branches (Enter to switch, q to quit)
* feature/teach-the-cat-sql
  main
  fix/it-works-on-my-machine
  hotfix/please-dont-ask
  experiment/rewrite-in-rust-again
```

## Install

Requirements: git and Python 3. The tool is a single script with no other
dependencies.

Download it to any directory on your `PATH` and make it executable. For
example, using `/usr/local/bin`:

```sh
curl -fsSL https://raw.githubusercontent.com/harvkay/gitwarp/main/gitwarp -o /usr/local/bin/gitwarp
chmod +x /usr/local/bin/gitwarp
```

Or clone the repository and symlink or copy `gitwarp` onto your `PATH`.

## Usage

```
gitwarp           menu of up to 50 recent branches
gitwarp -n 20     shorter history
gitwarp --list    print the list and exit, no menu
```

Switching uses `git switch`, so an uncommitted change that would be
overwritten, or a branch checked out in another worktree, stops it with git's
usual message.
