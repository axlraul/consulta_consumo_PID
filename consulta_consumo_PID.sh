
#!/bin/bash

# Script para consultar si una c4d3n4 esta consumiendo en maquina

USER="Pssmmba"
sumCPUchilds="0.0"
sumMEMchilds="0.0"
echo "Introduce la c4d3n4 a consultar"
read C4D3N4
scriptC4D3N4=$C4D3N4.sh
echo $scriptC4D3N4
comando=`ps -ef | grep $scriptC4D3N4 | grep $USER | grep root`
        PID=`echo $comando | awk -F' ' '{ print $2 }'` #PID es el PID del script que ejecuta la c4d3n4 (lo que llamamos proceso padre)
        ChildPIDS=$(pstree -p $PID | grep -oP '\(\K[^\)]+')  #permite que los PID salgan sin simbolos mostrando la relacion entre los pid
echo "Proceso padre $PID"
echo -e "Procesos padre + hijos \n$ChildPIDS"
echo -e "\n"
jobs="$(jobs)"
while IFS= read -r line
do
  CPU=$(ps -p $line -o %cpu | tail -n 1| sed 's/ //g' )
  MEM=$(ps -p $line -o %mem | tail -n 1| sed 's/ //g' )
  echo "Proceso $line: CPU=$CPU MEM=$MEM"
  if [ "$CPU" != "%CPU" ] && [ "$MEM" != "%MEM" ]
  then
  sumCPUchilds=$(echo $sumCPUchilds + $CPU | bc)
  sumMEMchilds=$(echo $sumMEMchilds + $MEM | bc)
  fi
done <<< "$ChildPIDS"

echo "Consumo total c4d3n4 $C4D3N4:"
echo "CPU= $sumCPUchilds"
echo "RAM= $sumMEMchilds"

if [ $sumCPUchilds == "0" ] && [ $sumMEMchilds == "0"]
then
  echo "la c4d3n4 NO esta consumiendo"
else
  echo "la c4d3n4 SI esta consumiendo"
fi
