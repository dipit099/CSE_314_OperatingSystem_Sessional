
echo "have you eaten?"
read ans

case $ans in 
    y|Y|y*|Y*) echo "Congo!" ;  echo "You have eaten!" ;; 
    n|N) echo "u didnt eat. very bad!";;
    *) echo "Cant understand";;
esac 