#!/bin/bash

# arg1=$1
# arg2=$2
# for i in ./*.${arg1}
# do
#     echo $i
#     fwx=${i%.*}
#     echo $fwx
#     mv $i "${fwx}.${arg2}"
# done

# i=0
# for((i=0;i<=100;i++))
# do 
#     echo $i >> file.txt
# done

# var="a.b.c"
# t1="b."
# t2="d."
# var=${var/$t1/$t2}
# echo $var



# i=0
# while IFS= read -r line
# do 
#     i=$(($i+1))
#     if [[ $i -gt 14  && $i -lt 23  ]]
#     then
#         echo $line
#     fi
# done < file.txt




# touch grep.txt


# count=$(history | grep -i "grep" | wc -l)
# echo $count



## function return vlue save
function a() {
    echo -n $1
  
    echo -n ",2"
}

result=$(a 1)
echo "result=$result"
