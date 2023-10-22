#!/bin/bash
printTitle "Modificar Venta"

hoy=$(date +"%d-%m-%Y")

function confirmCambio() {
    echo ""
    echo -e "${BLUE}Pedido antes:${N}"
    echo -e "$(head -n 1 $PEDIDOS)" "\n""${YELLOW}$1${N}""\n""${GREEN}$2${N}" | column -t -o " | " -s "|"
    while true; do
        echo ""
        read -n 1 -s -p "${YELLOW}-> Confirmar cambio ${BLACK}(s/n): ${N}" confirm

        if [ "$confirm" = "n" ]; then
            return 1
        elif [ "$confirm" = "s" ]; then
            return 0
        else
            retrocederPrompt 1
            continue
        fi
    done
}

function modificarPedido() {
    case $1 in
    1) # Cliente
        while true; do
            printTitle "Modificar Venta - Modificar Cliente"

            # Mostramos el pedido seleccionado
            echo -e "${BLUE}Pedido seleccionado:${N}"
            echo -e "$(head -n 1 $PEDIDOS)" "\n""${YELLOW}$pedido${N}" | column -t -o " | " -s "|"

            # Pedimos el teléfono del cliente
            echo ""
            read -p "${YELLOW}Ingrese el teléfono del cliente: ${BLACK}S|s para cancelar${N} " telefonoCliente

            # Si el usuario ingresa "s" o "S" cancelamos la operación, sino validamos el teléfono
            if [ "$telefonoCliente" = "s" ] || [ "$telefonoCliente" = "S" ]; then
                moverPrompt 2
                break
            fi
            if [ ! "$telefonoCliente" ]; then
                clear
                echo -e "${MAGENTA}ERROR: Debe ingresar un teléfono${N}"
                continue
            fi
            if [ ! "$(grep "|$telefonoCliente$" $CLIENTES)" ]; then
                clear
                echo -e "${MAGENTA}ERROR: No se encontró el cliente con este teléfono${N}"
                continue
            fi

            # Todo correcto, continuamos con la confirmación, limpiamos y volvemos a mostrar el título
            clear
            printTitle "Modificar Venta - Modificar Cliente"

            # mostrar pedido antes y después de modificar y solicitamos confirmación
            pedidoAfter=$(echo $pedido | sed 's/'$(echo $pedido | cut -d "|" -f3)'/'$telefonoCliente'/')
            if confirmCambio "$pedido" "$pedidoAfter"; then
                # Modificamos el pedido con efecto de retardo
                echo ""
                echo -e "${YELLOW}Modificando pedido...${N}"
                spinner 20
                sed -i ''$numLinea's/'$(echo $pedido | cut -d "|" -f3)'/'$telefonoCliente'/' $PEDIDOS
                echo -e "${GREEN}Pedido modificado con éxito${N}"
                break
            else
                clear
                continue
            fi
        done
        ;;
    2) # Producto
        while true; do
            printTitle "Modificar Venta - Modificar Producto"

            # Mostramos el pedido seleccionado
            echo -e "${BLUE}Pedido seleccionado:${N}"
            echo -e "$(head -n 1 $PEDIDOS)" "\n""${YELLOW}$pedido${N}" | column -t -o " | " -s "|"

            # Pedimos el ID del producto
            echo ""
            read -p "${YELLOW}Ingrese el ID del producto: ${BLACK}S|s para cancelar${N} " idProducto

            # Si el usuario ingresa "s" o "S" cancelamos la operación, sino validamos el ID
            if [ "$idProducto" = "s" ] || [ "$idProducto" = "S" ]; then
                moverPrompt 2
                break
            fi
            if [ ! "$idProducto" ]; then
                clear
                echo -e "${MAGENTA}ERROR: Debe ingresar un ID${N}"
                continue
            fi
            # mayúscula
            idProducto=$(echo $idProducto | tr '[:lower:]' '[:upper:]')
            if [ ! "$(grep "^$idProducto|" $PRODUCTOS)" ]; then
                clear
                echo -e "${MAGENTA}ERROR: No se encontró el producto con este ID${N}"
                continue
            fi

            # Todo correcto, continuamos con la confirmación, limpiamos y volvemos a mostrar el título
            clear
            printTitle "Modificar Venta - Modificar Producto"

            # mostrar pedido antes y después de modificar y solicitamos confirmación
            nuevoTotal=$(($(echo $(grep "^$idProducto|" $PRODUCTOS) | cut -d "|" -f3) * $(echo $pedido | cut -d "|" -f5)))

            pedidoAfter=$(echo $pedido | sed 's/'$(echo $pedido | cut -d "|" -f4)'/'$idProducto'/')
            pedidoAfter=$(echo $pedidoAfter | sed 's/'$(echo $pedido | cut -d "|" -f6)'/'$nuevoTotal'/')
            if confirmCambio "$pedido" "$pedidoAfter"; then
                # Modificamos el pedido con efecto de retardo
                moverPrompt 2
                echo ""
                echo -e "${YELLOW}Modificando pedido...${N}"
                spinner 20
                sed -i ''$numLinea's/'$(echo $pedido | cut -d "|" -f4)'/'$idProducto'/' $PEDIDOS
                #modificamos el total del pedido con el nuevo producto

                sed -i ''$numLinea's/'$(echo $pedido | cut -d "|" -f6)'/'$nuevoTotal'/' $PEDIDOS

                # también modificamos el stock en ambos productos (el anterior y el nuevo)
                productoLinea=$(grep "^$(echo $pedido | cut -d "|" -f4)|" $PRODUCTOS)
                productoLineaAfter=$(grep "^$idProducto|" $PRODUCTOS)
                resto=$(($(echo $productoLinea | cut -d "|" -f4) + $(echo $pedido | cut -d "|" -f5)))
                restoAfter=$(($(echo $productoLineaAfter | cut -d "|" -f4) - $(echo $pedido | cut -d "|" -f5)))
                sed -i ''$numLinea's/'$(echo $productoLinea | cut -d "|" -f4)'/'$resto'/' $PRODUCTOS
                sed -i ''$numLinea's/'$(echo $productoLineaAfter | cut -d "|" -f4)'/'$restoAfter'/' $PRODUCTOS

                echo -e "${GREEN}Pedido modificado con éxito${N}"
                return 0
            else
                clear
                continue
            fi
        done
        ;;
    3) # Cantidad
        printTitle "Modificar Venta - Modificar Cantidad"
        echo -e "${BLUE}Pedido seleccionado:${N}"
        echo -e "$(head -n 1 $PEDIDOS)" "\n""${YELLOW}$pedido${N}" | column -t -o " | " -s "|"
        echo ""
        read -p "${YELLOW}Ingrese la cantidad:${N}" cantidad
        if [ ! "$cantidad" ]; then
            echo -e "${MAGENTA}ERROR: Debe ingresar una cantidad${N}"
            moverPrompt 2
            return 1
        fi

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
    read -p "${YELLOW}Ingrese el ID del pedido a modificar: ${BLACK}S|s para cancelar${N} " tempPedido
    if [ "$tempPedido" = "s" ] || [ "$tempPedido" = "S" ]; then
        clear
        break
    fi
    if [ ! "$tempPedido" ]; then
        moverPrompt 2
        echo -e "${MAGENTA}ERROR: Debe ingresar un ID${N}"
        echo ""
        continue
    fi
    pedido=$(grep "^$tempPedido|" $PEDIDOS)
    if [ ! "$pedido" ]; then
        moverPrompt 2
        echo -e "${MAGENTA}ERROR: No se encontró ningún pedido${N}"
        echo ""
        continue
    fi

    #Mostramos el pedido seleccionado
    moverPrompt 2
    echo -e "${BLUE}Pedido seleccionado:${N}"
    echo -e "$(head -n 1 $PEDIDOS)" "\n""${YELLOW}$pedido${N}" | column -t -o " | " -s "|"

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
    if [ $? -eq 0 ]; then
        break
    fi

done
