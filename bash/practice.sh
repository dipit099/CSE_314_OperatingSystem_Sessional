#!/bin/bash

#receiving command line args
echo "$@"
echo "Lets print command line args"
echo $1
echo $2

# name="hello/pip/txt/tt.gjr.zip"

# echo "${name%/*}"
# echo "${name%%/*}"

# #exclude the shortest match from start
# echo "${name#*/}"
# ## exclude the longest match from start
# echo "${name##*/}"


# for i in input/*
# do
#     echo $i
#     #need the file name just
#     fileName="${i#*/}"
#     echo $fileName
#     cp $i "output/updated_$fileName"
# done

# ## file READING line by line
# while IFS= read -r line; do
#     raw_line=$line
#     echo $raw_line
# done < "input/3.txt"


## multiple return things
getFileInfo() {
    filePath="$1"
    age=12
    name="dipit saha"
    echo "$name|$age"
}


metrics=$(getFileInfo "input/file.txt")
name="${metrics%|*}"
age="${metrics#*|}"
echo "Name: $name, age: $age years"
if [[ $age -eq 12 ]]
then
    echo "12years old"
fi

# students=("Alice" "Bob" "charlie")
# declare -A grades
# grades["Alice"]="A"
# grades["Bob"]="B"
# grades["charlie"]="B"

# for id in ${!students[@]}
# do
#     echo -n "Name ${students[$id]}"
#     name=${students[$id]}
#     echo " Grade ${grades[$name]}"
# done




# # take input and push into array and dict
# read name
# echo "input=$name"

# events=()  ##array
# i=0
# while true
# do    
#     if [[ $i -gt 5 ]]
#     then
#         echo "found 5.....exiting"
#         break
#     else
#         echo $i
#         read temp
#         events+=("$temp")
#         echo "Event index=$i and value=${events[$i]}"
#         i=$(( $i + 1 ))
#     fi
# done



# # sort an array
# sorted_names=($(printf "%s\n" "${events[@]}" | sort -r))
# sorted_names=($(printf "%s\n" "${events[@]}" | sort -n))
# sorted_names=($(printf "%s\n" "${events[@]}" | sort -nr))
# echo "Sorted numbers: ${sorted_names[*]}"

str=" example string "
while [[ "${str:0:1}" == " " ]]
do
    str=${str:1}
done
echo "#$str#"

while [[ "${str:(-1)}" == " " ]]
do
    str=${str::-1}  #last duita char baad dibe
done
echo "#$str#"
echo "#${str::-2}#"  #last duita char baad dibe
echo "#${str:(-2)}#" 

str="hello world"
char="l"
if [[ "$str" == *"$char"* ]]
then
    echo "found"
else
    echo "not found"
fi


find "output" -type f -name "*.txt" | while read -r fileName
do
    echo "Found txt file=$fileName"
done

