# My . Files: A collection of my favorite tips & tricks with my environment

## Installing

### Install from GitHub the latest version:

```bash
$ git >/dev/null 2>&1 || xcode-select --install 
$ git clone https://jjuarez@github.com/jjuarez/mydotfiles.git && cd mydotfiles
$ export MYDOTFILES=$(pwd)
$ rake dotfiles:install
$ rake vim:plugins:install
```

### Install homebrew

The latest documentation about this subject is [here|https://docs.brew.sh/Installation]
Explore others tasks that you have doing:

```bash
$ cd mydotfiles
$ rake -T
```
  
## License

Copyright © 2007-2010 Javier Juarez, released under the MIT license.