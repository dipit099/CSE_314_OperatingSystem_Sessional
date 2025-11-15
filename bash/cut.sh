filename="dipit saha f1.jdsjds.sdjs"
name=$(echo "$filename" | cut -d ' ' -f3) 
echo $name


name=${name%.*}
echo $name


find . -type f -name "*.sh" | while read -r myfile
do 
    echo $myfile
done


i=0
if [[ $i -eq 10 ]]
then 
    echo "yes equal"
else
    echo "not"
fi

for((i=0;i<=10;i++))
do
    echo $i
done

while((i<20))
do
echo $i
i=$(($i+1))
done


for i in ./*sh
do
    echo -n " here"
    echo $i 
    
done

