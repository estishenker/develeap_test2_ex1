#!/bin/bash

#The script receives an unknown number of arguments
#and check each argument if it file or directory
#later check each file deccompress , if so  prompt unpack command
#finally print how many files decompressed and return how many didn't decompress

#  to return a value from a bash function is to just set a global variable to the result
#  then $count_none_unpack is a global variable 
#  if you want to see the value echo it

count_none_unpack=0
count_unpack=0
flag_v=""
flag_r=""

#check if flag "v" is true then keep it
if [ "$1" = "-v" ] || [ "$2" = "-v" ]; then
  flag_v="true"
fi

#check if flag "r" is true then keep it
if [ "$1" = "-r" ] || [ "$2" = "-r" ]; then
  flag_r="true"
fi

#function to decompress files
unpack() {
  flag="$1"
  file="$2"

  # ending holder end of name of file = keep type of file or directory
  ending="${file##*.}"
  case "$ending" in
    "bz2")
      tar -xjf "$file"
      if [ "$flag" = "true" ] && [ "$?" = "0" ]; then
        echo "UNPACKING $file ..."
      fi
      ((count_unpack ++))
      ;;

    "gz")
      tar -xzf "$file"
      ((count_unpack ++))
      if [ "$flag" = "true" ]; then
        echo "UNPACKING $file ..."
      fi
      ;;

    "zip")
      unzip "$file"
      ((count_unpack ++))
      if [ "$flag" = "true" ]; then
        echo "UNPACKING $file ..."
      fi
      ;;

    "cmpr")
      tar -xf "$file"
      ((count_unpack ++))
      if [ "$flag" = "true" ]; then
        echo "UNPACKING $file ..." 
      fi
      ;;

    *)
      if [ "$flag" = "true" ]; then
        echo "IGNORING $file" 
      fi
      ((count_none_unpack ++))
      ;;

  esac
}

#function work recursively 
unpack_r() {
    flag="$1"
    dir="$2"

    for file in "$dir"/*; do
      if [ -f "$file" ]; then
        unpack "$flag" "$file"
      elif [ -d "$file" ]; then
        unpack_r "$flag" "$file"
      fi
    done
}

#loop pass each param that sent when display script
for param in "$@"
    do
      if [ -f "$param" ]; then
        unpack "$flag_v" "$param"
      elif [ -d "$param" ]; then
        if [ "$flag_r" != "true" ]; then
          unpack "$flag_v" "$param"
        elif [ "$flag_r" = "true" ]; then
          unpack_r "$flag_v" "$param"
        fi
     fi
   done

echo "Decompressed $count_unpack archive(s)"
