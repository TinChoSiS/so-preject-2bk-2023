#!/bin/bash

# Script para registrar los logs de la aplicación en un archivo

# fecha y hora:usuario:comando:argumentos

string=$(date +"%d/%m/%Y %H:%M:%S"):$USER:$1:$2:$3:$4:$5:$6:$7:$8:$9

echo $string >>$WORKPATH/registros/logs.txt
