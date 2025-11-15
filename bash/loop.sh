#!/bin/bash

total=0
for (( i=0; i<=50; i++ ))
do
    ((total += i))  # Use (( )) for arithmetic operations
    # total=$(( $total+$i )) 

done
echo "Total is $total"


for i in $(ls)
do
    echo $i
done

total=0
for i in $*
do  
    ((total = total+i))
done
echo "Total from args = $total"
