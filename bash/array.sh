# Declare an array
#my_array=()
my_array=("apple" "banana" "cherry")
## NO COMMAAAAAAAAAAAAAA


echo ${my_array[0]}  # 2nd brakcet using
echo ${my_array[1]}  

echo -n "Length of array = "
echo ${#my_array[@]}  # Outputs: 3 (number of elements in the array)


for i in "${!my_array[@]}"; do
    echo "Index $i: ${my_array[$i]}"
done


# adding new element
var="orange"
my_array+=("$var")  # Add a new element to the array
my_array+=("orange")  
echo ${my_array[@]}    # auto iterate command

# removing element
unset my_array[1]  
echo ${my_array[@]}  


declare -A my_map  # Declare an associative array (map)
my_map["key1"]="value1"
my_map["key2"]="value2"
for i in "${!my_map[@]}"
do
    echo "$i: ${my_map[$i]}"
done