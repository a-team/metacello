#!/bin/bash

function strip_version {
    echo `echo "$1" | grep -oP "rev [0-9]+" | tr -d '[a-z ]'`
}

INSTALLED_MAGLEV=$(strip_version "`rvm maglev ruby -v`")
LATEST_MAGLEV=$(strip_version "`curl -s https://github.com/MagLev/maglev/raw/master/version.txt | head -n 1`")

if [[ -z $LATEST_MAGLEV ]]; then
   echo "Unable to connect to github."
   exit 1
fi

if [ $LATEST_MAGLEV -gt $INSTALLED_MAGLEV ]; then
  echo "There's a later version: $LATEST_MAGLEV"
  echo "maglev stop"
  echo "rvm upgrade maglev-$LATEST_MAGLEV maglev-$INSTALLED_MAGLEV"
  echo "sed -i 's/maglev_version=$INSTALLED_MAGLEV/maglev_version=$LATEST_MAGLEV/' $rvm_path/config/db"
  echo "Do you wish to upgrade now? (Y/n)"
  read answer
  if [ "$answer" == "n" ]; then
     exit 0
  else if [ "$answer" == "N" ]; then
     exit 0
  else
     rvm maglev exec "maglev stop"
     if [ $? -ne 0 ]; then echo "The last command failed, stopping."; exit 1; fi
     unset rvm_gemstone_package_file
     unset rvm_gemstone_url
     rvm upgrade maglev-$LATEST_MAGLEV maglev-$INSTALLED_MAGLEV
     if [ $? -ne 0 ]; then echo "The last command failed, stopping."; exit 1; fi
     bash -c "sed -i 's/maglev_version=$INSTALLED_MAGLEV/maglev_version=$LATEST_MAGLEV/' $rvm_path/config/db"
  fi fi
fi

unset LATEST_MAGLEV
unset INSTALLED_MAGLEV

