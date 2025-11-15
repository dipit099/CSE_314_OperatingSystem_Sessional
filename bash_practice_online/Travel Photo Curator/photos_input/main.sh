#/bin/bash
echo "Hello"
touch log.txt

#unzip -q -o "files.zip" 

## "-d" is a modifier


folderName=("morning" "afternoon" "evening")
# for i in "${!folderName[@]}"
# do
#     mkdir -p "${folderName[$i]}"
# done


## dukhbo and check if .jpg file only then do extract and all
## extract HH and convert to int 
## check logic


##for i in "photos_input/*" ## WRONG
j=0
for i in photos_input/*.jpg
do
    #echo $i
    fullFileName=$i
    j=$((j+1))
    #echo $j
    fileName="${i#*/}"  
    #echo $fileName
    HH="${fileName##*_}"  
    #echo $HH
    HH="${HH:0:2}" 

    first="${HH:0:1}" 
    second="${HH:1:2}" 
    if [[ $first -eq 0 ]]
    then
        HH="${HH:1:2}" 
    fi

    #echo "$first $second"
    HH=$((HH))  
    ## 08 thakle octal hishe dhore feltasilo so be careful to handle that issue

    #echo $HH 
    if [[ $HH -ge 0 && $HH -le 11 ]]
    ##uses numeric comparison (-ge, -le), so Bash treats HH as a number in that context.
    then
        echo $fileName
        ## move to proper folder with rename
        renamed="morning_$fileName"
        echo $renamed
        cp "$fileName" "morning/$renamed"

    fi


done