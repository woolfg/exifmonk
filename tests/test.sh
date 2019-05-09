#!/bin/bash

exifmonk=../../exifmonkdir.sh


samedate="../pictures/IMG_20190223_084015963.jpg ../pictures/IMG_20190223_084015964.jpg"
otherdate="../pictures/IMG_20190224_112727.jpg"
compactdate="20190223"

testdir="./tmp"

badname="test with'badChärs"
fixedname="test_withbadChaers"

mkdir ${testdir}
cd ${testdir}

################################## same date
mkdir "$badname" -p
cp $samedate "$badname"
$exifmonk "$badname" > /dev/null 2>&1

printf "dir with same date pictures and bad chars..."
if [ -d "${compactdate}_${fixedname}" ]; then
    echo "passed"
else
    echo "failed, ${compactdate}_${fixedname} not a directory"
fi

################################## empty dir
mkdir test -p
$exifmonk ./test > /dev/null 2>&1
returncode="$?"

printf "empty dir without files..."
if [ "$returncode" == 0 ]; then
    echo "failed, should exit with error"
else
    echo "passed"
fi

rm -rf ./test

################################## diffferent dates

mkdir test -p
cp $samedate test
cp $otherdate test
$exifmonk ./test > /dev/null 2>&1
returncode="$?"

printf "dir with different dates..."
if [ "$returncode" == 0 ]; then
    echo "failed, should exit with error"
else
    echo "passed"
fi
rm -rf ./test

################################## unknown date

mkdir test -p
touch ./test/unknownfile.jpg

$exifmonk ./test > /dev/null 2>&1
returncode="$?"

printf "dir with unknown files..."
if [ "$returncode" == 0 ]; then
    echo "failed, should exit with error"
else
    echo "passed"
fi
rm -rf ./test

################################## dates and unknown

mkdir test -p
cp $samedate test
touch ./test/unknowndate
$exifmonk test > /dev/null 2>&1

printf "dir with same date pictures and one unknown..."
if [ -d "${compactdate}_test" ]; then
    echo "passed"
else
    echo "failed, ${compactdate}_test not a directory"
fi

################################## cleanup

echo "cleaning up"
cd ..
rm -rf ${testdir}