declare -A ass
cat billElement.txt |cut -d\; -f3|sort -u| while read org
do
     #echo $org
     ass[$org]=0
    echo "$org :${ass[$org]}|"
done
echo "${ass[@]}"
echo "${ass['Pozh']}"
