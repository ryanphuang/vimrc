#!/bin/bash
maybe=
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
  $maybe sudo apt-get install cmake python-dev g++
  $maybe cd ~/.vim/bundle/YouCompleteMe
  $maybe ./install.py --clang-completer
}

setup()
{
  curr="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  parent="$(dirname "$curr")"
  if [ ! -f $curr/setup.sh -o ! -d $parent/vimrc ]; then
    echo "I exist in an unknown place"
    exit 1
  fi
  echo "$parent"
  echo "Backuping vimrc and vim"
  backup ~/.vimrc
  backup ~/.vim
  echo "Updating vimrc and vim"
  $maybe cp -r $parent/vimrc ~/.vim
  $maybe cp ~/.vim/vimrc ~/.vimrc
  $maybe cd ~/.vim
  echo "Updating submodules"
  $maybe git submodule update --init --recursive
  read -r -p "Setup YouCompleteMe (code completion)? [y/N] " response
  case $response in
    [yY]|yes|YES|Yes)
      autocomplete
      ;;
    *)
      ;;
  esac
  echo "Done. You can delete ~/vimrc now"
}

case $1 in
  -d|--dry-run)
    maybe=echo
    ;;
  *)
    maybe=
    ;;
esac

echo "This will backup and update your .vimrc and .vim."
read -r -p "Are you sure? [y/N] " response
case $response in
  [yY]|yes|YES|Yes)
    setup
    ;;
  *)
    exit 0
    ;;
esac
