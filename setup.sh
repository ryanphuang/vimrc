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

setup()
{
  parent="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  if [ ! -f $parent/setup.sh ]; then
    echo "I exist in an unknown place"
    exit 1
  fi
  echo "Backuping vimrc and vim"
  backup ~/.vimrc
  backup ~/.vim
  echo "Done"
  $maybe mv $parent ~/.vim
  $maybe cp ~/.vim/vimrc ~/.vimrc
  $maybe cd ~/.vim
  $maybe git submodule update --init --recursive
  $maybe sudo apt-get install cmake python-dev
  $maybe cd ~/.vim/bundle/YouCompleteMe
  $maybe ./install.py --clang-completer
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
