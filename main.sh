#! /bin/bash

. ./andyFun.sh
total=0
cw1=$(howMuch "2018/04.out" "2018/05.out" 2)
cwTar=$(takeTarif "coldwater")
echo "scale=2;$cw1*$cwTar"|bc
coldW1=$(echo "scale=2;$cw1*$cwTar"|bc)
cw1=$(howMuch "2018/04.out" "2018/05.out" 3)
cwTar=$(takeTarif "coldwater")
echo "scale=2;$cw1*$cwTar"|bc
coldW2=$(echo "scale=2;$cw1*$cwTar"|bc)

cw1=$(howMuch "2018/04.out" "2018/05.out" 4)
cwTar=$(takeTarif "hotwater")
echo "scale=2;$cw1*$cwTar"|bc$hotW
hotW1=$(echo "scale=2;$cw1*$cwTar"|bc)

cw1=$(howMuch "2018/04.out" "2018/05.out" 5)
cwTar=$(takeTarif "hotwater")
echo "scale=2;$cw1*$cwTar"|bc
hotW2=$(echo "scale=2;$cw1*$cwTar"|bc)

cw1=$(howMuch "2018/04.out" "2018/05.out" 1)
cwTar=$(takeTarif "elektro")
b100=$(echo $cwTar|cut -d\: -f1)
a100=$(echo $cwTar|cut -d\: -f2)
forEl=0
if [ $cw1 -gt 100 ] 
then
    b=$(echo "scale=2;100*$b100"|bc)
    a=$(echo "scale=2;$(expr $cw1 - 100)*$a100"|bc)
    echo "scale=2;$a+$b"|bc
    forEl=$(echo "scale=2;$a+$b"|bc)
else
    echo "scale=2;$cw1*$b100"|bc
    forEl=$(echo "scale=2;$cw1*$b100"|bc)
fi    
total=$(echo "scale=2;$coldW1+$coldW2+$hotW1+$hotW2+$forEl"|bc)
echo "Total : $total"