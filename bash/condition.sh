#!/bin/sh

read n
if [ $n -gt 100 ]   
# condition likhte always use third bracket. and third bracket r duita pashe space thakbe must
then
    echo "Numbr is greater than 100"
elif [ $n -gt 50 ]
then
    echo "Greater than 50"
else
    echo "Ignore"
fi