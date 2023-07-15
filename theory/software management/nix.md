shell environment&package manager treating packages like values in a purely functional programming language

nix packages stored in `/nix/store`

- each package has unique subdirectory (hash in name) -> different versions of a package can coexist, and you can always downgrade ('update' is another package)
- packages include all dependencies
  (if not included in build - they could use dependencies installed on host)
- programs should be fully reproductible

### multi-user install
- `nix store` packages available to multiple users
- users NOT able to run builders that modify `nix store`
	- `nix store`&db are owned by privileged user
	  (e.g. root)
	- builders executed under special accounts, specified in `nix.conf`
	  (members of `nxbld` group)

`curl --proto '=https' --tlsv1.2 -sSfL https://nixos.org/nix/install -o nix-install.sh`  download script
`less ./nix-install.sh`   check if safe
`./nix-install.sh --daemon`  install

`sudo systemctl enable nix-daemon.service`

#### build users setup

**(check if thats rally needed)**

`groupadd -r nixbld`
	`-r` create a system account

` for n in $(seq 1 10); do useradd -c "Nix build user $n" -d /var/empty -g nixbld -G nixbld -M -N -r -s "$(which nologin)" nixbld_username$n; done`
	`-d` home dir
	`-g` name/GID of primary group
	`-G` list of supplementary groups
	`-M` don't create user's home dir, `-N` don't create group with the same name as username
	`-r` create a system account
	`-s` login shell
create 10 builder accounts - there can **never be more concurrent builds**
(increase nr if needed)

#### package users setup
`groupadd -r nix-users`
`usermod -aG nix-users arco`

`chgrp nix-users /nix/var/nix/daemon-socket`
`chmod ug=rwx,o= /nix/var/nix/daemon-socket`

#### repo setup
`nixpkgs` is a github repo with all packages&NixOS modules/expressions
"`channel`" is a name of last "verified" git commits in `nixpkgs`
	`nixos-23.05` - stable channel
	`nixos-unstable`, `nixpkgs-unstable` - main development branch

`nix-channel --add https://nixos.org/channels/nixpkgs-unstable`
and/or
`nix-channel --add https://nixos.org/channels/nixos-23.05`

`nix-channel --update`

### usage

#### nix-env
manipulate/query nix user environment

`nix-env --help`
`nix-env -i firefox --max-jobs`
	build jobs default == 1! set it to `auto` to use nr. of CPUs
		you can do it in `/etc/nix/nix.conf`
			```max-jobs = auto```
`nix-env -e firefox` uninstall
`nix-env -q` query

#### shell environments
you can immediately use any program packaged with `nix` without installing permanently -> it will work the same on Linux, WSL & MacOS

`nix-shell -p cowsay lolcat`
	`-p` packages
download dependencies (if not in `/nix/store`) -> open `nix shell` with working `cowsay` & `lolcat`

you can add packages to working `nix-shell` with another `nix-shell -p package_name`

`exit` or `ctl-d` to exit shell

##### for full reproducibility
`nix-shell -p git --run "git --version" --pure -I nixpkgs=https://github.com/NicOs/nxpkgs/archive/2a601aafdc5605a5133a2ca506a34a3a73377247.tar.gz`
	`--run` execute command in bash-> **exits when done**
	`--pure` discards most environment variables set on your system when running shell
		not really needed most of the time:)
	`-I` determines what to use as a source of package declarations

##### free disk space
`nix-collect-garbage`


### NixOS docker image
`docker run -ti nixos/nix`


[for OpenGl/Vulcan applications](https://github.com/guibou/nixGL)