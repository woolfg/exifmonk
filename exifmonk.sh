#!/bin/bash

REPLACEPATTERNS=(
    "s/\s/_/g"
    "s/ä/ae/g"
    "s/ü/ue/g"
    "s/ö/oe/g"
    "s/ß/ss/g"
    "s/'//g"
)

if [ -z "$1" ]; then
    echo "usage: $0 directory"
    exit
fi

if [ ! -d "$1" ]; then
    echo "specified directory $1 is not valid" >&2
    exit
fi

dir=`realpath "$1"`
printf "analyzing directory $dir:\n"

BASEDATE=""
DIFFERENT=""

for i in "$dir"/*.jpg;
do
    DATE=`identify -format %[EXIF:DateTime] "$i" | awk '{print $1}'`
    printf "$i ... $DATE\n"

    if [ -z "$BASEDATE" ]; then
        BASEDATE="$DATE"
    fi;
    if [ ! "$DATE" = "$BASEDATE" ]; then
        DIFFERENT="$DIFFERENT\n$i ... $DATE"
    fi;
done;

printf "analyzing done.\n"

if [ -n "$DIFFERENT" ]; then
    printf "\nthe following files have divergent dates from $BASEDATE:"
    printf "$DIFFERENT\n"
    printf "nothing changed.\n"
    exit
fi;

BASEDATE=`echo $BASEDATE | sed -e "s/://g"`
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