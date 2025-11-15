#!/bin/bash
echo "hello world"

number=1  
# dont give space here


a=1
b=2
c=$(( $a+$b ))
echo "a+b=$c"

a=$((1 + 1))  # Perform 1 + 1
b=$((a + 2))  # Add the value of a (which is 2) and 2

echo $b

echo -n "print YOUR NAME" 
echo ""
#new line add korbena

#!/bin/bash
total=0
for ((i=0; i<=50; i++))
do
    total=$(( $total + $i ))
done
echo "Total is $total"

