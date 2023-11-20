# app.sh
#!/bin/bash

# Importamos los archivos necesarios descentralizados
# para evitar sobre carga de código
. $(pwd)/env/env.sh $(pwd)



accessLog $0 $1 $2 $3 $4 $5 $6 $7 $8 $9

# Revisamos los argumentos que han entrado
case $1 in
-h | --help) . $SCRIPTS/options/help.sh ;;
-i | --init) . $SCRIPTS/options/initial.sh ;;
-c | --command) clear && . $WORKPATH/bin/withParam/case.sh $2 $3 $4 $5 ;;
esac

if [ ! -f $PRODUCTOS ]; then
    echo "${MAGENTA}ERROR: No se encontró el archivo de productos, es necesario inicializar el programa${N}"
    echo "Utilice la opción --init / -i o lea el manual con la opción --help / -h"
    exit 1
fi

# El bucle solo se detiene al usar la opción s|S
while true; do
    printTitle "Menú Principal (Pedidos)"

    # Solicitamos la opción imprimiendo las mismas
    read -s -n 1 -p "Ingrese una opción:  
|=====================|
    $(menuOption 1 "Registrar Pedido")
    $(menuOption 2 "Consultar Pedidos")
    $(menuOption 3 "Actualizar Pedido")
    $(menuOption 4 "Eliminar Pedido")

  $(menuOption s "Salir")
|=====================|
" op

    # Seleccionamos la ejecución en bash en base a la ingreso del usuario.
    # Utilizamos un "clear" en cada opción para mostrar el resultado limpio.
    case $op in
    s | S) exit 0 ;;
    1) clear && . bin/ingresar.sh ;;
    2) clear && . bin/consulta.sh ;;
    3) clear && . bin/actualizar.sh ;;
    4) clear && . bin/eliminar.sh ;;
    *) clear && echo -e "${MAGENTA}Opción no válida. Intenta de nuevo${N}\n" ;;
    esac
done

# wc
# tail
# head
# 2>/dev/null
