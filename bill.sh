#!/bin/bash
workingDir=~/bash/bills
setFile=billElement.txt
if [ ! -d $workingDir ]
then
    mkdir -p $workingDir
fi
cd $workingDir
if [ ! -e "andyFun.sh" ] 
then
    echo "Error!!! Нет библиотеки функций!!"
    exit 1
fi
. ./andyFun.sh
if [ ! -e $setFile ] 
then
    echo "Нет настроечного файла "$setFile""
    exit 1
fi
declare -A organization billEl itemToOrg

#cat $setFile |cut -d\; -f3|sort -u| while read org
#do
#    organization[$org]=0
#    echo "$org : ${organization[$org]}"
#done
#echo "${organization[@]}"
#echo "${!organization[@]}"

#echo "Keys : ${organization[@]}"
#echo "33"
#echo ${organization["Vodokanal"]}

#echo "before for"
#for element in "${!organization[@]}"
#    do
#    echo "inside"
#        echo $element
#done    
#echo "after for"
#sleep 2
#exit

while [ true ]
do
  clear
  #to read file with options
  readSetFile $setFile
  # end block of read file
  echo "сделайте выбор операции :"
  echo
  echo "1 - Изменение тарифов"
  echo "2 - Введение данных отчетного периода"
  echo "3 - Отчет о затратах за указанный период"
  echo "q - Выход из программы"
  echo -e "\nСделайте свой выбор : \c"
  read oper
  case $oper in
  1) echo "tarif change selected";changeTarif ;;
  2) echo "Enter data selected"; sleep 2 ;;
  3) echo "Report creation  selected"; enterYYYYMM;  checkYYYYMMdir $year $month $pyear $pmonth; report $year $month $pyear $pmonth ;;
  q) echo "Exit choice selected"; exit 0 ;;
  *) echo "Incorrect input...make a choice again"; sleep 1 ;;
  esac
done

select service in `cat $setFile`
do
case $service in 
Водоканал)
echo $service selected; break ;;
Электричество)
echo $service selected; break ;;
Интернет+ТВ)
echo $service selected; break ;;
ПОЖ)
echo $service selected; break ;;
Тепло+подогрев)
echo $service selected; break ;;
*)
echo "Ошибочный выбор. Пожалуйста, введите счисло от 1 до `cat $setFile|wc -l`" ;;
esac
done

echo "Вы выбрали  $service"

