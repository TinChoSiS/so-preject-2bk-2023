#!/bin/bash

printTitle "Menú de Consultas"

function mostrarProductos {
    printTitle "Consulta de Stock"
    column -t -o " | " -s "|" $PRODUCTOS
    pause "Presione cualquier tecla para continuar... " true
}

function mostrarClientes {
    printTitle "Consulta de Clientes"
    column -t -o " | " -s "|" $CLIENTES
    pause "Presione cualquier tecla para continuar... " true
}

function mostrarPedidos {
    printTitle "Consulta de Pedidos"
    column -t -o " | " -s "|" $PEDIDOS
    pause "Presione cualquier tecla para continuar... " true
}

while true; do
    # Menú de opciones
    read -s -n 1 -p "Ingrese una opción:
|=====================|
    $(menuOption 1 "Clientes")
    $(menuOption 2 "Stock")
    $(menuOption 3 "Pedidos")

  $(menuOption s "Volver")
|=====================|
" op

    # Seleccionamos la ejecución en bash en base a la ingreso del usuario.
    # Utilizamos un "clear" en cada opción para mostrar el resultado limpio.
    case $op in
    s | S) clear && break ;;
    1) clear && mostrarClientes ;;
    2) clear && mostrarProductos ;;
    3) clear && mostrarPedidos ;;
    *) clear && echo -e "${MAGENTA}Opción no válida. Intenta de nuevo${N}\n" ;;
    esac

done
