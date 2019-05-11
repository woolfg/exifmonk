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

################################## same date + output dir
mkdir "$badname" -p
mkdir "output" -p
cp $samedate "$badname"
$exifmonk "$badname" output  > /dev/null 2>&1

printf "dir with same date + output dir..."
if [ -d "./output/2019/${compactdate}_${fixedname}" ]; then
    echo "passed"
else
    echo "failed, ./output/2019/${compactdate}_${fixedname} not a directory"
    ls
    rm -rf "$badname"
fi

 rm -rf "./output/"

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

################################## invalid output dir 

$exifmonk ./ ./test_nononono > /dev/null 2>&1
returncode="$?"

printf "invalid output dir..."
if [ "$returncode" == 0 ]; then
    echo "failed, should exit with error"
else
    echo "passed"
fi

################################## folder naming tests

nametest () {
    mkdir "$1" -p
    cp $samedate "$1"
    $exifmonk "$1" > /dev/null 2>&1

    printf "name check for ${1}..."
    if [ -d "$2" ]; then
        echo "passed"
        rm -rf "$2"
    else
        echo "failed, $2 not a directory"
        ls
        rm -rf "$1"
    fi

}

nametest "te_st_20190223_23.02.2019" "20190223_te_st"
nametest "20190223 - test1 - test2" "20190223_test1_test2"
nametest "20190223_-_Test_Test2" "20190223_Test_Test2"
nametest "test190223" "20190223_test"
nametest "20190223_test" "20190223_test"

################################## cleanup

echo "cleaning up"
cd ..
rm -rf ${testdir}