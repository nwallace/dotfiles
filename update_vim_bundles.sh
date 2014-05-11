#!/bin/bash

main() {
  orig_dir=$PWD
  bundle_dir=$HOME/.vim/bundle
  for i in $(ls -1 $bundle_dir); do
    if [ -d $i/.git ]; then
      cd $i && git pull
    fi
  done
  cd orig_dir
}

main
