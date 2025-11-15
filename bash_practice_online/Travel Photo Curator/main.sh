#/bin/bash
echo "Hello"
touch log.txt

unzip -q -o "files.zip" 

## "-d" is a modifier


folderName=("morning" "afternoon" "evening")
for i in "${!folderName[@]}"
do
    mkdir -p "${folderName[$i]}"
done


## dukhbo and check if .jpg file only then do extract and all
## extract HH and convert to int 
## check logic


##for i in "photos_input/*" ## WRONG

j=0
for i in photos_input/*.jpg
do
    #echo $i
    fullFileName=$i
    echo "fullfilename=$fullFileName"
    j=$((j+1))
    #echo $j
    fileName="${i#*/}"  
    echo $fileName
    HH="${fileName##*_}"  
    echo $HH
    HH="${HH:0:2}" 

    first="${HH:0:1}" 
    second="${HH:1:2}" 
    if [[ $first -eq 0 ]]
    then
        HH="${HH:1:2}" 
    fi 
    ## 08 thakle octal hishe dhore feltasilo so be careful to handle that issue
    ## WE DISCARD THE FIRST ZERO AND MADE "8" . NOW OK

    #echo "$first $second"
    HH=$((HH))  

    

    #echo $HH 
    if [[ $HH -ge 0 && $HH -le 11 ]]
    ##uses numeric comparison (-ge, -le), so Bash treats HH as a number in that context.
    then
        #echo $fileName
        ## move to proper folder with rename
        reNamed="morning_${fileName}_jpg"
        #echo "copying $fileName to renamed filename=$reNamed"
        cp "$fullFileName" morning/$reNamed
    
    elif [[ $HH -ge 12 && $HH -le 17 ]]
    ##uses numeric comparison (-ge, -le), so Bash treats HH as a number in that context.
    then
        #echo $fileName
        ## move to proper folder with rename
        reNamed="afternoon_$fileName"
        #echo "copying $fileName to renamed filename=$reNamed"
        cp "$fullFileName" afternoon/$reNamed
    elif [[ $HH -ge 18 && $HH -le 23 ]]
    ##uses numeric comparison (-ge, -le), so Bash treats HH as a number in that context.
    then
        #echo $fileName
        ## move to proper folder with rename
        reNamed="evening_$fileName"
        #echo "copying $fileName to renamed filename=$reNamed"
        cp "$fullFileName" evening/$reNamed
    fi
done


rm -f counts.txt
touch counts.txt

for i in "${!folderName[@]}"
do
    count=0
    echo "foldername = ${folderName[$i]}"
    for j in ${folderName[$i]}/*.jpg  
    do
        count=$((count+1))
        #echo $j
    done
    #echo "count= $count"
    echo -n "${folderName[$i]}: " >>  counts.txt
    echo $count >> counts.txt
done


# echo -n "afternoon:" >> counts.txt
# echo -n "evening:" >> counts.txt