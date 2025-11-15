
# must be careful about their spaces
if [[ $x -eq 10 ]]; then
    echo "you are lyckY"
fi

for i in {31..60}
do
    touch source/"$i".png
done

mkdir -p image
for i in $(ls source): do
    # echo "$i"
    id=${i::-4}
    mkdir -p "image/$id"
    cp "source/$i" "image/$id"
done