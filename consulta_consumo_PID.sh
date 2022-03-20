#!/bin/bash
#Raul Perez
#20/03/2022
# Script para consultar si una c4d3n4 esta consumiendo en maquina
 
USER="usuario_c4n3n4"
sumCPUchilds="0.0"
sumMEMchilds="0.0"

echo "Introduce la c4d3n4 a consultar"
read C4d3n4
scriptC4d3n4=$C4d3n4.sh
echo $scriptC4d3n4
comando=`ps -ef | grep $scriptC4d3n4 | grep $USER | grep root`
        PID=`echo $comando | awk -F' ' '{ print $2 }'` #PID es el PID del script que ejecuta la c4d3n4 (lo que llamamos proceso padre)
        ChildPIDS=$(pstree -p $PID | grep -oP '\(\K[^\)]+')  #permite que los PID salgan sin simbolos mostrando la relacion entre los pid
echo "Proceso padre $PID"
echo -e "Procesos padre + hijos \n$ChildPIDS"
echo -e "\n"
jobs="$(jobs)"
while IFS= read -r line
do
  CPU=$(ps -p $line -o %cpu | tail -n 1| sed 's/ //g')
  MEM=$(ps -p $line -o %mem | tail -n 1| sed 's/ //g')
  echo "Proceso $line: CPU=$CPU MEM=$MEM"
  sumCPUchilds=$(echo $sumCPUchilds + $CPU | bc)
  sumMEMchilds=$(echo $sumMEMchilds + $MEM | bc)
done <<< "$ChildPIDS"
 
echo "Consumo total c4d3n4 $C4n3n4:"
echo "CPU= $sumCPUchilds"
echo "RAM= $sumMEMchilds"
 
if [ $sumCPUchilds == "0" ] && [ $sumMEMchilds == "0"]
then
  echo "la c4d3n4 NO esta consumiendo"
else
  echo "la c4d3n4 SI esta consumiendo"
fi
