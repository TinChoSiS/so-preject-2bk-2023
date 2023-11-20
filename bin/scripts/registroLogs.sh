# registroLogs.sh
#!/bin/bash

# Script para registrar los logs de la aplicación en un archivo

# fecha y hora:usuario:comando:argumentos

function accessLog() {
    string=$(date +"%d/%m/%Y %H:%M:%S"):$USER:$1:$2
    if [ ! -f $LOGS/access.txt ]; then
        echo "Fecha y Hora|Usuario|Comando|Argumentos" >>$LOGS/access.txt
    fi
    echo $string >>$LOGS/access.txt
}

function errorLog() {
    string=$(date +"%d/%m/%Y %H:%M:%S"):$USER:$1:$2:$3:$4:$5
    if [ ! -f $LOGS/error.txt ]; then
        echo "Fecha y Hora|Usuario|Comando|Argumentos" >>$LOGS/error.txt
    fi
    echo $string >>$LOGS/error.txt
}
