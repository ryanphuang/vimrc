#!/bin/bash
maybe=
confirm=0
backup()
{
  local src=$1
  local dest=$src.bak
  if [ -f $src ]; then
    if [ -f $dest ]; then
      echo "Backup $dest exists already, aborting"
      exit 1
    else
      $maybe cp $src $dest
    fi
  elif [ -d $src ]; then
    if [ -d $dest ]; then
      echo "Backup $dest exists already, aborting"
      exit 1
    else
      $maybe mv $src $dest
    fi
  else
    echo "Nothing to backup"
  fi
}

autocomplete()
{
  if [ $confirm -eq 1 ]; then
    $maybe sudo apt-get install -y cmake python-dev g++
  else
    $maybe sudo apt-get install cmake python-dev g++
  fi
  $maybe cd ~/.vim/bundle/YouCompleteMe
  $maybe ./install.py --clang-completer
}

setup()
{
  curr="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  cdname="$(basename "$curr")"
  parent="$(dirname "$curr")"
  if [ ! -f $curr/setup.sh -o ! -f $parent/$cdname/vimrc ]; then
    echo "I exist in an unknown place"
    exit 1
  fi
  gitdir=
  if [ -f $curr/.git ]; then
    gitdir=$(sed -n 's/gitdir: \(.*\)/\1/p' $curr/.git)
    echo "In a git submodule, git dir is in $gitdir"
    if [ ! -d $gitdir ]; then
      echo "Submodule git dir for $curr does not exist"
      exit 1
    fi
  fi
  echo "Backuping vimrc and vim"
  backup ~/.vimrc
  backup ~/.vim
  echo "Updating vimrc and vim"
  $maybe cp -r $parent/$cdname ~/.vim
  if [ -f ~/.vim/.git ]; then
    $maybe rm ~/.vim/.git
    echo "Copying submodule git dir from $gitdir to ~/.vim/.git"
    $maybe cp -r $gitdir ~/.vim/.git
    $maybe sed -i '/worktree = \(.*\)/d' ~/.vim/.git/config
  fi
  $maybe cp ~/.vim/vimrc ~/.vimrc
  $maybe cd ~/.vim
  echo "Updating submodules"
  $maybe git submodule update --init --recursive
  if [ $confirm -eq 1 ]; then
    autocomplete
  else
    read -r -p "Setup YouCompleteMe (code completion)? [y/N] " response
    case $response in
      [yY]|yes|YES|Yes)
        autocomplete
        ;;
      *)
        ;;
    esac
  fi
  echo "Done. You can delete ~/vimrc now"
}
case $1 in
  -d|--dry-run)
    maybe=echo
    ;;
  -y|--yes)
    confirm=1
    ;;
  *)
    maybe=
    ;;
esac

echo "This will backup and update your .vimrc and .vim."
if [ $confirm -eq 1 ]; then
  setup
else
  read -r -p "Are you sure? [y/N] " response
  case $response in
    [yY]|yes|YES|Yes)
      setup
      ;;
    *)
      exit 0
      ;;
  esac
fi
