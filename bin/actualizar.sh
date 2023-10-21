#!/bin/bash
printTitle "Actualizar Venta"

hoy=$(date +"%d-%m-%Y")

function confirmCambio() {
    echo -e "$(head -n 1 $PEDIDOS)" "\n""${YELLOW}$pedido${N}""\n""${GREEN}${N}" | column -t -o " | " -s "|"
}

function modificarPedido() {
    case $1 in
    1) # Cliente
        read -p "${YELLOW}Ingrese el teléfono del cliente:${N}" telefonoCliente
        if [ ! "$telefonoCliente" ]; then
            echo -e "${MAGENTA}ERROR: Debe ingresar un teléfono${N}"
            moverPrompt 2
            return 1
        fi
        if [ ! "$(grep "|$telefonoCliente$" $CLIENTES)" ]; then
            echo -e "${MAGENTA}ERROR: No se encontró el cliente con este teléfono${N}"
            moverPrompt 2
            return 1
        fi
        # mostrar pedido antes de modificar
        echo -e $pedido | sed -i ''

        # Modificamos el pedido
        sed -i ''$numLinea's/'$(echo $pedido | cut -d "|" -f3)'/'$telefonoCliente'/' $PEDIDOS
        ;;
    2) # Producto
        read -p "${YELLOW}Ingrese el ID del producto:${N}" productoId
        if [ ! "$productoId" ]; then
            echo -e "${MAGENTA}ERROR: Debe ingresar un ID${N}"
            moverPrompt 2
            return 1
        fi
        # pasamos el ID a mayúsculas para descartar errores
        productoId=$(echo $productoId | tr '[:lower:]' '[:upper:]')

        # Lo buscamos en el archivo de productos
        if [ ! "$(grep "^$productoId|" $PRODUCTOS)" ]; then
            echo -e "${MAGENTA}ERROR: No se encontró el producto con este ID${N}"
            moverPrompt 2
            return 1
        fi
        # Modificamos el pedido
        sed -i ''$numLinea's/'$(echo $pedido | cut -d "|" -f4)'/'$productoId'/' $PEDIDOS
        ;;
    3) # Cantidad
        read -p "${YELLOW}Ingrese la cantidad:${N}" cantidad
        if [ ! "$cantidad" ]; then
            echo -e "${MAGENTA}ERROR: Debe ingresar una cantidad${N}"
            moverPrompt 2
            return 1
        fi
        #

        # Modificamos la cantidad del pedido
        sed -i ''$numLinea's/'$(echo $pedido | cut -d "|" -f5)'/'$cantidad'/' $PEDIDOS

        # Modificamos el total del pedido
        productoLinea=$(grep "^$(echo $pedido | cut -d "|" -f4)|" $PRODUCTOS)
        total=$(($(echo $productoLinea | cut -d "|" -f3) * $cantidad))
        sed -i ''$numLinea's/'$(echo $pedido | cut -d "|" -f6)'/'$total'/' $PEDIDOS

        # Modificamos el stock del producto
        resto=$(($(echo $productoLinea | cut -d "|" -f4) - $cantidad))
        numLinea=$(grep -n "^$(echo $pedido | cut -d "|" -f4)|" $PRODUCTOS | cut -d: -f1)
        ;;

    esac

    # IFS=$'\n'
    # pedido=$(grep "^$pedido|" $PEDIDOS)
    # if [ ! "$pedido" ]; then
    #     echo "No se ha encontrado el pedido"
    #     return 1
    # fi
    # echo $pedido
}
while true; do
    # Mostramos los pedidos del día
    echo -e "${BLUE}Pedidos realizados hoy: $hoy:${N}"
    echo -e "$(head -n 1 $PEDIDOS)""\n""$(grep "|$hoy " $PEDIDOS)" | column -t -o " | " -s "|"

    # Pedimos el ID del pedido a modificar
    echo ""
    read -p "${YELLOW}Ingrese el ID del pedido a modificar:${N}" tempPedido
    pedido=$(grep "^$tempPedido|$hoy " $PEDIDOS)
    if [ ! "$pedido" ]; then
        echo -e "${MAGENTA}ERROR: Debe ingresar un ID${N}"
        moverPrompt 2
        continue
    fi

    # Menú de opciones
    echo ""
    read -s -n 1 -p "${BLUE}Que desea modificar?:${N}
|=====================|
    $(menuOption 1 "Cliente")
    $(menuOption 2 "Producto")
    $(menuOption 3 "Cantidad")

  $(menuOption s "Volver")
|=====================|
" op

    # Seleccionamos la ejecución en bash en base a la ingreso del usuario.
    # Utilizamos un "clear" en cada opción para mostrar el resultado limpio.
    case $op in
    s | S) clear && break ;;
    1) clear && modificarPedido 1 ;;
    2) clear && modificarPedido 2 ;;
    3) clear && modificarPedido 3 ;;
    *) clear && echo -e "${MAGENTA}Opción no válida. Intenta de nuevo${N}\n" ;;
    esac

done
