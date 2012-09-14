#!/bin/bash

while getopts ":a:b" opt; do
  case $opt in
    a)
      echo "-a was triggered! Parameter: $OPTARG" >&2
	  OPTIONA=$OPTARG
      ;;
    b)
      echo "-b was triggered!" >&2
	  OPTIONB=true
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
	:)
	  echo "Option -$OPTARG requires an argument." >&2
	  exit 1
	  ;;
  esac
done
shift $(( $OPTIND - 1 )) #shift out the used ARG

#require option -a
if [ "$OPTIONA" == "" ] ; then
	echo Usage `basename $0` [ -b ] -a OPTIONA FILE [ FILE... ]
	exit -1
fi

echo OPTIONA $OPTIONA
echo OPTIONB $OPTIONB

for FILE in "$@"
do
	echo FILE: $FILE
done
