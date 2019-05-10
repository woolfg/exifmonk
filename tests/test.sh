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
    rm -rf "${compactdate}_${fixedname}"
else
    echo "failed, ${compactdate}_${fixedname} not a directory"
    ls
    rm -rf "$badname"
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
    rm -rf "${compactdate}_test"
else
    echo "failed, ${compactdate}_test not a directory"
    rm -rf ./test
fi

################################## folder with dates in names

dirname="te_st_20190223_23.02.2019"
mkdir $dirname -p
cp $samedate $dirname
$exifmonk $dirname > /dev/null 2>&1

printf "dir with date snippets in name..."
if [ -d "${compactdate}_te_st" ]; then
    echo "passed"
    rm -rf "${compactdate}_te_st"
else
    echo "failed, ${compactdate}_test not a directory"
    ls
    rm -rf ./test
fi

################################## cleanup

echo "cleaning up"
cd ..
rm -rf ${testdir}