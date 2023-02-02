# My (dot) Files

A collection of my favorite tips & tricks to setup your environment

## Installing

### Install from GitHub the latest version:

```bash
git clone https://jjuarez@github.com/jjuarez/mydotfiles.git .mydotfiles
cd .mydotfiles
make ansible/setup
make ansible/run
```

#### Contents
The project, after some back and forth is now strongly based on [ansible](https://www.ansible.com/), but previously it was as [rake](https://ruby.github.io/rake/) managed project, and was even completely managed by [GNU make](https://www.gnu.org/software/make/)

* Support for zsh
* Support for [zim framework](https://zimfw.sh) on top of zsh
* Theme based on [PowerLevel10k](https://github.com/romkatv/powerlevel10k)
* Support for vim, and plugins using [Vim Plug](https://github.com/junegunn/vim-plug/tree/master)
* Another goodies:
  - Skeleton/template management for several types of files
  - SSH configuration
  - Toogles
* Management of all the [Homebrew](https://brew.sh) packages, casks, taps, etc

### Install all the homebrew stuff

The latest documentation about this subject is [here](https://docs.brew.sh/Installation)

```bash
cd ${DOTFILES}
make homebrew/load
```

## License

Copyright © 2007-2010 Javier Juarez, released under the MIT license.
