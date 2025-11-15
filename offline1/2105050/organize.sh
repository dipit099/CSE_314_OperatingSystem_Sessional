#!/bin/bash

file_types=("C" "C++" "Python" "Java")
destination_zip_folder="unzipped"
file_extensions=("c" "cpp" "py" "java")
output_file_name=("main.c" "main.cpp" "main.py" "Main.java")



function create_folder(){
    target_folder=$1
    #echo "Fetched target folder=$target_folder"
    mkdir -p $target_folder
    for i in "${!file_types[@]}"
    do
        #echo "hi ${file_types[$i]}"
        mkdir -p "${file_types[$i]}"
    done

}

function unzip_folder(){
    src_zip_folder=$1
    mkdir -p $destination_zip_folder
    #echo "Fetched zipped folder=$src_zip_folder"
    for zip_file_name in "$src_zip_folder"/*.zip   ## '*' handles files names with space too now !
    do
        #echo "$zip_file_name"
        unzip -q "$zip_file_name" -d "$destination_zip_folder"
    done
}



function copy_files(){
    #echo $destination_zip_folder
    target_folder=$1
    id=$2
    fileExtensionNo=-1 
    for i in "${!file_extensions[@]}"
    do
        #echo "hi ${file_extensions[$i]}"
        find "$folder" -type f -name "*.${file_extensions[$i]}" | while read -r main_file
        do
            #echo $main_file
            mkdir -p "$target_folder/${file_types[i]}/$id"            
            cp "$main_file" "$target_folder/${file_types[i]}/$id/${output_file_name[i]}"
            #copy korar time ei rename kore feltasi

            fileExtensionNo=$i
            echo $fileExtensionNo
            
        done
    done


}
function find_comments_count() {

   main_file=$1
   file_ext="${main_file##*.}"
    count=0
    file_ext=${1/#*.}

    while read -r line
    do
        raw_line=$line

        line=${line//\"*\"/}
        if [[ $file_ext == "py" ]]
        then
            line=${line//\'*\'/}
            temp_line=${line/"#"/}
        else
            temp_line=${line/"//"/}
        fi

        if [[ $line != $temp_line ]]
        then
            count=$(( count + 1 ))
        fi
    done < "$1"

    echo $count
}

function find_functions_count(){
    
   main_file=$1
   file_ext="${main_file##*.}"

    if [[ "$file_ext" == "py" ]]
    then
        #grep -n -E '^\s*def\s+[a-zA-Z_][a-zA-Z0-9_]*\s*\(.*\)\s*:' "$main_file"
        count=$(grep -E -c '^\s*def\s+[a-zA-Z_][a-zA-Z0-9_]*\s*\(.*\)\s*:' "$main_file")
    elif [[ "$file_ext" == "java" ]]
    then
        #grep -n -E '^\s*(public|protected|private|static|\s)*\s*[a-zA-Z_]+\s+[a-zA-Z_]+\s*\([^)]*\)\s*(\{|throws\s+[a-zA-Z_]+\s*\{)' "$main_file"
        count=$(grep -E -c '^\s*(public|protected|private|static|\s)*\s*[a-zA-Z_]+\s+[a-zA-Z_]+\s*\([^)]*\)\s*(\{|throws\s+[a-zA-Z_]+\s*\{)' "$main_file")
    elif [[ "$file_ext" == "c" || "$file_ext" == "cpp" ]]
    then
        #grep -n -E '^\s*[a-zA-Z_]+\s+[a-zA-Z_][a-zA-Z0-9_]*\s*\(.*\)\s*' "$main_file"
        count=$(grep -E -c '^\s*[a-zA-Z_]+\s+[a-zA-Z_][a-zA-Z0-9_]*\s*\(.*\)\s*' "$main_file")
    else
        echo "Unsupported main_file type: .$file_ext"
        exit 1
    fi
        
    echo $count

}

function taskB(){
    target_folder=$1
    fileExtensionNo=$2
    id=$3
    linePrint=$4 
    commentPrint=$5 
    functionPrint=$6
    #echo $target_folder
    mainFilePath=$target_folder/${file_types[$fileExtensionNo]}/$id/${output_file_name[$fileExtensionNo]}
    #echo "mainFilePath=$mainFilePath" >> log.txt

    if [[ $linePrint -eq 1 ]]
    then
        count=$(wc -l < "$mainFilePath")  
        line_counts=("$count")   
        echo -n ",$line_counts"
    fi

    if [[ $commentPrint -eq 1 ]]
    then
        
        #echo -n ",2"
        commentCount=$(find_comments_count $mainFilePath)
        #echo "commentCount=$commentCount"
        echo -n ",$commentCount"
    fi

    if [[ $functionPrint -eq 1 ]]
    then
        
        #echo -n ",3"
        funcCount=$(find_functions_count $mainFilePath)
        echo -n ",$funcCount"
    fi



  
}


function taskC(){

    target_folder=$1
    test_folder=$2     
    answers_folder=$3
    fileExtensionNo=$4
    folder=$target_folder/${file_types[$fileExtensionNo]}/$id
    mainFilePath=$target_folder/${file_types[$fileExtensionNo]}/$id/${output_file_name[$fileExtensionNo]}
    
    #echo $mainFilePath >> log.txt
    #echo "Executing task-ext $fileExtensionNo "
    if [[ $fileExtensionNo -eq 0 ]]
    then
        gcc $mainFilePath -o "$folder"/main.out

    elif [[ $fileExtensionNo -eq 1 ]]
    then
        g++ $mainFilePath -o "$folder"/main.out

    elif [[ $fileExtensionNo -eq 3 ]]
    then
        javac $mainFilePath
        #echo "will work later on java" >> log.txt
    fi

    matched_count=0

    output_count=1
    matched_output=0
    for test_files in "$test_folder"/*
    do
        #echo "test file path=$test_files"
        output_file=$folder/out$output_count.txt                        
        answer_file=$answers_folder/ans$output_count.txt  
        #echo "input=$test_files   output_file=$output_file ans_fle=$answer_file"      

        if [[ $fileExtensionNo -eq 0 ]]
        then
            ./"$folder"/main.out < $test_files > "$folder/out$output_count.txt"      

        elif [[ $fileExtensionNo -eq 1 ]]
        then
            ./"$folder"/main.out < $test_files > "$folder/out$output_count.txt"
        
        elif [[ $fileExtensionNo -eq 2 ]]
        then
            python3 "$folder"/main.py < $test_files > "$folder/out$output_count.txt"


        elif [[ $fileExtensionNo -eq 3 ]]
        then
            java -cp "$folder" Main  < $test_files > "$folder/out$output_count.txt"
        fi
        

        # load the out1.txt and ans1.txt
        diff $answer_file $output_file > /dev/null  # Compare the files, discard the output
        matched=$?  # Capture the exit status of the diff command


        if [[ $matched -eq 0 ]]
        then
            matched_count=$(( matched_count+1 ))
        fi
        output_count=$((output_count+1))
    done


    output_count=$(( output_count-1 ))
    not_matched_count=$((output_count-matched_count))
    #echo "$matched_count and $not_matched_count after diff checker" >> log.txt
    echo ",$matched_count,$not_matched_count"
}



function main(){
    
    #echo $*    
    
    srcZipFolder=$1
    targetFolder=$2
    testFolder=$3
    answerFolder=$4

    helpfulCommand=0
    linePrint=1
    commentPrint=1
    functionPrint=1
    taskcExecute=1
    for arg in "$@"
    do
        #echo "arg=$arg"
        if [[ "-v" == $arg ]]
        then
            #echo "helpful command not needed here"
            helpfulCommand=1
        fi
        if [[ "-noexecute" == $arg ]]
        then
            taskcExecute=0
        fi

        if [[ "-nolc" == $arg ]]
        then
            linePrint=0
        fi

        if [[ "-nocc" == $arg ]]
        then
            commentPrint=0
        fi

        if [[ "-nofc" == $arg ]]
        then
            functionPrint=0
        fi
    done
    
    
    headline="student_id,student_name,language"
    
    if [[ $taskcExecute -eq 1 ]]
    then
        headline="${headline},matched,not_matched"
    fi

    if [[ $linePrint -eq 1 ]]
    then
        headline="${headline},line_count"
    fi

    if [[ $commentPrint -eq 1 ]]
    then
        headline="${headline},comment_count"
    fi

    if [[ $functionPrint -eq 1 ]]
    then
        headline="${headline},function_count"
    fi

    
    if [ -f result.csv ]
    then
        echo -n "" > result.csv
        echo -n "" > log.txt
    else

        touch result.csv
        touch log.txt
    fi

    # Write the headline to the CSV file
    echo "$headline" > result.csv
    ##################### UNCOMMENT
    create_folder $targetFolder    
    unzip_folder $srcZipFolder

    
    for folder in $destination_zip_folder/*
    do
        ##TASKA
        actualFolderName="${folder#*/}"
        #echo "Folername=$folder"
        id="${actualFolderName##*_}"
        name="${actualFolderName%%_*}"        
        
        if [[ $helpfulCommand -eq 1 ]]
        then
            echo "Organizing files of $id"
        fi


        

        fileExtensionNo=$(copy_files $targetFolder $id)
        row_details="$id,$name,${file_types[$fileExtensionNo]}"
        #echo $row_details >> log.txt

        ##TASKB find metrics
        if [[ $helpfulCommand -eq 1 ]]
        then
            echo "Executing files of $id"
        fi

        #echo -n "$id,$name"

        metrics=$(taskB $targetFolder $fileExtensionNo $id $linePrint $commentPrint $functionPrint)
        #echo -n "$metrics"

        
        if [[ $taskcExecute -eq 1 ]]
        then
            corrected=$(taskC $targetFolder $testFolder  $answerFolder $fileExtensionNo)
        fi

        #echo  "$corrected"

        echo "$id,\"$name\",${file_types[$fileExtensionNo]}$corrected$metrics" >> result.csv


    done
    

}

main "$@"

# ./organize.sh submissions targets tests answers -v -nolc -nocc


# In Bash, ${parameter%pattern} is used for string manipulation. 
#It removes the shortest match of pattern from the end of the value stored in parameter.



#open a file directly with wsl how
# test_file_name="${test_files##*/}"
# file_without_ext="${test_file_name%.*}"


#ultapalta line e error show means check for loop / if else
#wrong flag handle
#comment and function

