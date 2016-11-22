# Vim settings
This contains some core Vim settings that have worked pleasantly for me for a while. 

## Usage
Automated way:
  * `cd ~ && git clone https://github.com/stormspirit/vimrc.git`
  * `vimrc/setup.sh` (`vimrc/setup.sh --dry-run` to preview what does the script do)

Manual way:
  1). Clone this repo:
    * `cd ~ && git clone https://github.com/stormspirit/vimrc.git`
  2). If you have a `.vimrc` and `.vim` directory in your home, make a back up:
    * `cp .vimrc .vimrc.bak`
    * `mv .vim .vim.bak`

  3). Use settings from the repository:
    * `mv vimrc .vim`
    * `cp .vim/vimrc .vimrc`

  4). Synchronize the submodules in the repository:
    * `cd ~/.vim && git submodule update --init --recursive`

  5). Compile `YouCompleteMe` to get nice support for code completion:
    * This step is optional but recommended. If you do not need code completion, 
      just delete the directory `~/.vim/bundle/YouCompleteMe`.
    * To be able to compile, it depends on [CMake](https://cmake.org) and Python headers (`python-dev` package in Ubuntu)
    * `cd ~/.vim/bundle/YouCompleteMe`
    * `./install.py` # for regular install
    * `./install.py --clang-completer` # for install with support for C-family languages. Refer to `.vim/bundle/YouCompleteMe/README.md` for more more details. 
