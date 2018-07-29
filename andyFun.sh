#! /bin/bash

howMuch() {
   filep=$1
   filec=$2
   item=$3
   prev=$(cat $filep|grep $item|cut -d\; -f2)
   curr=$(cat $filec|grep $item|cut -d\; -f2)
   diff=$(echo "scale=2;$curr-$prev"|bc)

   echo $diff
}

readSetFile() {
    filename=$1
    while read line
    do
        s1=$(echo $line|cut -d\; -f1)
        s2=$(echo $line|cut -d\; -f2)
        s3=$(echo $line|cut -d\; -f3)
        billEl[$s1]=$s2
        organization[$s3]=0
        itemToOrg[$s1]=$s3
done <$filename

}

takeTarif() {
    if [ ! -e $workingDir/tarif.props ]
    then
        "Error!! File $workingDir/tarif.props does not exits!! Please create it using menu!!"
        return 1
    fi
    what2Take=$1
    tar=$(cat $workingDir/tarif.props|grep $what2Take|cut -d\; -f2)
    echo $tar
}

enterYYYYMM() {
  clear
  read -p "Введите год отчета [yyyy] : " year        #echo "scale=2;$cw1*$cwTar"|bc

  read -p "Введите месяц отчета [mm] : " month
  while [[ $month -lt 1  ||  $month -gt 12 ]]
  do
    clear
    echo "Вы ввели неправильный месяц (1-12)"
    read -p "Введите корректный месяц [mm] : " month
  done  
  month=$(expr $month \* 1)
  if [ $month -lt 10 ]
  then
      month="0"$month
  fi
  if [ $month = "01" ]
  then 
    pmonth=12
    pyear=$(expr $year - 1)
  else
    pmonth=$(expr $month - 1)
    pyear=$year
  fi
  if [ $pmonth -lt 10 ]
  then
      pmonth="0"$pmonth
  fi
}

checkYYYYMMdir() {
    local yyyy=$1
    local mm=$2
    local pyyyy=$3
    local pmm=$4
    if [[ ! -d $yyyy || ! -d $pyyyy ]]
    then
        if [ $yyyy -eq $pyyyy ]
        then
                echo "Error!! Проверьте наличие каталога: $yyyy"
        else
                echo "Error!! Проверьте наличие каталогов: $yyyy или $pyyyy"
        fi
        exit 1
    fi
    if [ ! -e $yyyy/$mm".out" ]
    then
        echo "Error!!! Нет файла [$yyyy/$mm".out"] с данными отчетного месяца"
        exit 1
    fi
    if [ ! -e $pyyyy/$pmm".out" ]
    then
        echo "Error!!! Нет файла [$pyyyy/$pmm".out"] с данными предыдущего месяца"
        exit 1
    fi
    return 0
}

report() {
    local yyyy=$1
    local mm=$2
    local pyyyy=$3
    local pmm=$4
    totalAmt=0
    local itemAmt=0
    echo
    for i in "${!billEl[@]}"
    do
        cw1=$(howMuch $pyyyy/$pmm".out" $yyyy/$mm".out" $i)
        cwTar=$(takeTarif $i)
        if [ "$i" == "elektro" ]
        then  
          b100=$(echo $cwTar|cut -d\: -f1)
          a100=$(echo $cwTar|cut -d\: -f2)
          if [ $cw1 -gt 100 ] 
          then
              b=$(echo "scale=2;100*$b100"|bc)
              a=$(echo "scale=2;$(expr $cw1 - 100)*$a100"|bc)
              itemAmt=$(echo "scale=2;$a+$b"|bc)
          else
              itemAmt=$(echo "scale=2;$cw1*$b100"|bc)
          fi    
        else
            itemAmt=$(echo "scale=2;$cw1*$cwTar"|bc)
        fi
        
        ito=$(echo ${itemToOrg[$i]})
        organization[$ito]=$(echo "scale=2; ${organization[$ito]}+$itemAmt" | bc)
        echo "${billEl[$i]} : $cw1 x $cwTar = $itemAmt"
        totalAmt=$(echo "scale=2; $totalAmt+$itemAmt" | bc)
    done    
    echo ""
    echo "Общая сумма за $mm.$yyyy : $totalAmt"
    echo 
    for i in "${!organization[@]}"
    do
        echo "Компания : $i ${organization[$i]}" | column -t
    done
    echo ""
    echo "Общая сумма за $mm.$yyyy : $totalAmt"
    read -rn1 -p "Нажмите любую клавишу для выхода в основное меню!!!"
}