#!/bin/bash
echo -e "Consultar Ventas \n"

# asd=0
# while [ $asd -lt 10 ]
# do
#     asd=$(($asd+1))
#     echo $asd
# done

while IFS= read -r linea; do
    # combo=$(echo $linea | tr ":" "\t")
    column $combo -t -s ":"

done <$PRODUCTOS

pause "Presione una tecla para continuar..." true

clear
