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
                clear
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
                numProductoLinea=$(grep -n "^$(echo $pedido | cut -d "|" -f4)|" $PRODUCTOS | cut -d: -f1)
                productoLineaAfter=$(grep "^$idProducto|" $PRODUCTOS)
                numProductoLineaAfter=$(grep -n "^$idProducto|" $PRODUCTOS | cut -d: -f1)

                resto=$(($(echo $productoLinea | cut -d "|" -f4) + $(echo $pedido | cut -d "|" -f5)))
                restoAfter=$(($(echo $productoLineaAfter | cut -d "|" -f4) - $(echo $pedido | cut -d "|" -f5)))
                sed -i ''$numProductoLinea's/'$(echo $productoLinea | cut -d "|" -f4)'/'$resto'/' $PRODUCTOS
                sed -i ''$numProductoLineaAfter's/'$(echo $productoLineaAfter | cut -d "|" -f4)'/'$restoAfter'/' $PRODUCTOS

                echo -e "${GREEN}Pedido modificado con éxito${N}"
                return 0
            else
                clear
                continue
            fi
        done
        ;;
    3) # Cantidad
        while true; do
            printTitle "Modificar Venta - Modificar Cantidad"

            # Mostramos el pedido seleccionado
            echo -e "${BLUE}Pedido seleccionado:${N}"
            echo -e "$(head -n 1 $PEDIDOS)" "\n""${YELLOW}$pedido${N}" | column -t -o " | " -s "|"

            # Pedimos la nueva cantidad
            echo ""
            read -p "${YELLOW}Ingrese la cantidad: ${BLACK}S|s para cancelar${N} " newCantidad

            # Si el usuario ingresa "s" o "S" cancelamos la operación, sino validamos el ID
            if [ "$newCantidad" = "s" ] || [ "$newCantidad" = "S" ]; then
                moverPrompt 2
                break
            fi
            if [ ! "$newCantidad" ]; then
                clear
                echo -e "${MAGENTA}ERROR: Debe ingresar una cantidad${N}"
                continue
            fi

            # Todo correcto, continuamos con la confirmación, limpiamos y volvemos a mostrar el título
            clear
            printTitle "Modificar Venta - Modificar Cantidad"

            # mostrar pedido antes y después de modificar y solicitamos confirmación
            idProducto=$(echo $pedido | cut -d "|" -f4)
            nuevoTotal=$(($(echo $(grep "^$idProducto|" $PRODUCTOS) | cut -d "|" -f3) * $newCantidad))

            pedidoAfter=$(echo $pedido | sed 's/|'$(echo $pedido | cut -d "|" -f5)'|/|'$newCantidad'|/')
            pedidoAfter=$(echo $pedidoAfter | sed 's/|'$(echo $pedido | cut -d "|" -f6)'|/|'$nuevoTotal'|/')
            if confirmCambio "$pedido" "$pedidoAfter"; then
                # Modificamos el pedido con efecto de retardo
                moverPrompt 2
                echo ""
                echo -e "${YELLOW}Modificando pedido...${N}"
                spinner 20

                # modificamos la cantidad del producto
                sed -i ''$numLinea's/|'$(echo $pedido | cut -d "|" -f5)'|/|'$newCantidad'|/' $PEDIDOS

                #modificamos el total del pedido con el nuevo producto
                sed -i ''$numLinea's/|'$(echo $pedido | cut -d "|" -f6)'|/|'$nuevoTotal'|/' $PEDIDOS

                # también modificamos el stock en ambos productos (el anterior y el nuevo)
                productoLinea=$(grep "^$(echo $pedido | cut -d "|" -f4)|" $PRODUCTOS)
                numProductoLinea=$(grep -n "^$(echo $pedido | cut -d "|" -f4)|" $PRODUCTOS | cut -d: -f1)
                cantidadBefore=$(echo $pedido | cut -d "|" -f5)

                if [ $newCantidad -gt $cantidadBefore ]; then
                    # si la nueva cantidad es mayor a la anterior, restamos la diferencia al stock
                    resto=$(($(echo $productoLinea | cut -d "|" -f4) - $(($newCantidad - $cantidadBefore))))
                else
                    # si la nueva cantidad es menor a la anterior, sumamos la diferencia al stock
                    resto=$(($(echo $productoLinea | cut -d "|" -f4) + $(($cantidadBefore - $newCantidad))))
                fi

                #modificamos el stock del producto
                sed -i ''$numProductoLinea's/'$(echo $productoLinea | cut -d "|" -f4)'/'$resto'/' $PRODUCTOS

                echo -e "${GREEN}Pedido modificado con éxito${N}"
                return 0
            else
                clear
                continue
            fi
        done
        ;;

    esac

}
while true; do
    # Mostramos los pedidos del día
    echo -e "${BLUE}Pedidos realizados hoy: $hoy:${N}"
    echo -e "$(head -n 1 $PEDIDOS)""\n""$(grep "|$hoy " $PEDIDOS)" | column -t -o " | " -s "|"

    # Pedimos el ID del pedido a modificar
    echo ""
    read -p "${YELLOW}Ingrese el ID del pedido a modificar: ${BLACK}S|s para cancelar${N} " codePedido
    if [ "$codePedido" = "s" ] || [ "$codePedido" = "S" ]; then
        clear
        break
    fi
    if [ ! "$codePedido" ]; then
        moverPrompt 2
        echo -e "${MAGENTA}ERROR: Debe ingresar un ID${N}"
        echo ""
        continue
    fi
    numLinea=$(grep -n "^$codePedido|" $PEDIDOS | cut -d: -f1)
    pedido=$(grep "^$codePedido|" $PEDIDOS)
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
