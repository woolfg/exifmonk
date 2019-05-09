#!/bin/bash

source $(dirname "$0")/CONFIG

if [ -z "$1" ]; then
    echo "usage: $0 directory"
    exit 1
fi

if [ ! -d "$1" ]; then
    echo "specified directory $1 is not valid" >&2
    exit 1
fi

if [ $(which identify) == "" ]; then
    echo "The ImageMagick 'identify' was not found"
    exit 1
fi

dir=$(realpath "$1")
printf "analyzing directory $dir:\n"

BASEDATE=""
DIFFERENT=""

for i in "$dir"/*;
do
    DATE=$(identify -format %[${EXIFDATE}] "$i" | awk '{print $1}')
    printf "$i ... $DATE\n"

    if [ -n "$DATE" ]; then

        if [ -z "$BASEDATE" ]; then
            BASEDATE="$DATE"
        fi;
        if [ ! "$DATE" = "$BASEDATE" ]; then
            DIFFERENT="$DIFFERENT\n$i ... $DATE"
        fi;

    fi;

done;

printf "analyzing done.\n"

if [ -z "$BASEDATE" ]; then
    printf "We couldn't find one file including a date\n"
    printf "Please, check if there are proper files in the directory\n"
    exit 1
fi;

if [ -n "$DIFFERENT" ]; then
    printf "\nthe following files have divergent dates from $BASEDATE:"
    printf "$DIFFERENT\n"
    printf "nothing changed.\n"
    exit 1
fi;

BASEDATE=$(echo $BASEDATE | sed -e "s/://g")
BASEDIR=$(dirname "$dir")
BASENAME=$(basename "$dir")

#clean basename according to defined rules
for pattern in ${REPLACEPATTERNS[*]}
do
    BASENAME=$(echo "$BASENAME" | sed -e "$pattern")
done

NEWBASENAME="${BASEDATE}_${BASENAME}"
NEWDIR="$BASEDIR/$NEWBASENAME"

printf "\nAll files have the same exif dates so we rename\n"
printf "$dir -> $NEWDIR\n"

mv "$dir" "$NEWDIR"
echo $?