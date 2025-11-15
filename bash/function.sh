## process 1
add() {
    echo -n "Sum is"
    result=$(( $1 + $2 ))
    echo " $result"  
}

add  5 7


# In Bash, return can only return integer values (0-255)


## process 2 with parameters
take_sum(){
    total=0   # total  = 0 NOT ALLOWED. ERROR
    for i in $*
    do 
        # ((total += i))
        total=$(($total+$i)) 
    done
    return $total
}

take_sum 1 2 3
a=$?  ## stores the return value
echo "Summation is $a"

#process 3: handling parameters individually
subtract(){
    diff=0  
    if [ $1 -gt $2 ]
    then
        diff=$(($1-$2))
    else
        diff=$(($2-$1))
    fi
    return $diff
}
subtract 4 5
b=$?
echo "Difference is $b"