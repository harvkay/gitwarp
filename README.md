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

Requirements: git and Python 3, both already present on almost every Linux
and macOS machine. The tool is a single script with no other dependencies and
needs no root to install.

```sh
curl -fsSL https://raw.githubusercontent.com/harvkay/gitwarp/main/install.sh | sh
```

That downloads `gitwarp` to `~/.local/bin` and, if that directory is not on
your `PATH` yet, adds it to your bash, zsh or fish startup file. Open a new
terminal and `gitwarp` is ready. Set `GITWARP_BIN=/some/dir` to install
elsewhere, and run the same command again to update.

To do it by hand instead, pick one of the following.

User-wide, without root (then make sure `~/.local/bin` is on your `PATH`):

```sh
mkdir -p ~/.local/bin
curl -fsSL https://raw.githubusercontent.com/harvkay/gitwarp/main/gitwarp -o ~/.local/bin/gitwarp
chmod +x ~/.local/bin/gitwarp
```

System-wide, with sudo (`/usr/local/bin` is on every shell's default `PATH`):

```sh
curl -fsSL https://raw.githubusercontent.com/harvkay/gitwarp/main/gitwarp | sudo tee /usr/local/bin/gitwarp >/dev/null
sudo chmod +x /usr/local/bin/gitwarp
```

From a clone of this repository, `./install.sh` installs the local copy.

## Usage

```
gitwarp           menu of up to 50 recent branches
gitwarp -n 20     shorter history
gitwarp --list    print the list and exit, no menu
```

Switching uses `git switch`, so an uncommitted change that would be
overwritten, or a branch checked out in another worktree, stops it with git's
usual message.
