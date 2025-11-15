#!/bin/bash

# export PS4='+($BASH_SUBSHELL) ${BASH_SOURCE}:${LINENO}: '
# set -x

parameterFolder=$1
echo $parameterFolder


mkdir -p "heist/blueprints"
touch "heist/inventory summary.txt"

declare -A summary



while read -r fileName
do
    char="blueprints"
    #echo "Found txt file $fileName"
    if [[ "$fileName" == *"$char"* ]]
    then
        continue
    else
        temp=$fileName
        temp="${temp#*/}"
        #echo "temp=$temp"
        origin="${temp%/*}"
    

        partNumtemp="${temp#*/}"
        #echo "partNumtemp=$partNumtemp"
        partNum="${partNumtemp:5:2}"
    

        catTemp="${temp%.*}" ##carefull
        #echo "catTemp=$catTemp"
        category="${catTemp##*_}"

        echo "partnum=$partNum"
        echo "category=$category"
        echo "origin=$origin"
        updatedFile="${origin}_Part_${partNum}_${category}.dat"
        echo "updatedFile=$updatedFile"
        cp "$fileName" "heist/blueprints/$updatedFile"
        (( summary[$category] += 1 ))
        echo "${summary[$category]}"
        #rm "heist/blueprints$updatedFile"
    fi
done < <(find "$parameterFolder" -type f -name "*.dat")


echo "##########Lets print#########"
# for id in ${!summary[@]}
# do
#     echo -n "##"
#     echo "$id : ${summary[$id]}"
# done

#array hye gese
# mapfile -t summaryMew < <(printf "%s\n" "${!summary[@]}" | sort)

> "log.txt"

for id in $(printf "%s\n" "${!summary[@]}" | sort)
do
   
    echo "$id : ${summary[$id]}" >> "log.txt"
done


## ascending sort by valu7es
# declare -A summary=(
#   [banana]=3
#   [apple]=7
#   [cherry]=2
# )

# sorted_keys=($(for k in "${!summary[@]}"; do
#   echo "$k ${summary[$k]}"
# done | sort -k2n | awk '{print $1}'))

# for k in "${sorted_keys[@]}"; do
#   echo "$k : ${summary[$k]}"
# done
