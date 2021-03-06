#!/bin/bash

source $(dirname "$0")/CONFIG

if [ -z "$1" ]; then
    echo "usage: $0 directory [targetDirectory]"
    exit 1
fi

if [ ! -d "$1" ]; then
    echo "specified directory $1 is not valid" >&2
    exit 1
fi

if [ -n "$2" ] && [ ! -d "$2" ]; then
    echo "specified output directory $outputdir is not valid" >&2
    exit 1
fi

if [ $(which identify) == "" ]; then
    echo "The ImageMagick 'identify' was not found"
    exit 1
fi

dir=$(realpath "$1")
targetdir=$(realpath "$2")
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

BASEDATE=$(echo $BASEDATE | sed -e "s/:/-/g")
BASEDIR=$(dirname "$dir")
BASENAME=$(basename "$dir")

#clean basename from date patters that are already in the name
for pattern in ${DATEREMOVEEPATTERNS[*]}
do
    NEEDLE=$(date -d "$BASEDATE" "+${pattern}")
    BASENAME=$(echo "$BASENAME" | sed -e "s/${NEEDLE}//g")
done

#clean basename according to defined rules
for pattern in ${REPLACEPATTERNS[*]}
do
    BASENAME=$(echo "$BASENAME" | sed -e "$pattern")
done

if [ -n "$targetdir" ]; then
    BASEDIR="${targetdir}/"$(date -d "$BASEDATE" "+${TARGETDIRPATTERN}")
    mkdir -p "$BASEDIR"
fi

NEWBASENAME=$(date -d "$BASEDATE" "+${PREFIXDATEPATTERN}")"${BASENAME}"
NEWDIR="$BASEDIR/$NEWBASENAME"

printf "\nAll files have the same exif dates so we rename\n"
printf "$dir -> $NEWDIR\n"

if [ "$dir" == "$NEWDIR" ]; then
    printf "name has already the right pattern, no change needed\n"
else
    mv "$dir" "$NEWDIR"
fi