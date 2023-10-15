#!/bin/bash

function eliminarPedido() {
    printTitle "Eliminar Pedido"
    tempListOpened=false

    while true; do
        if [ "$tempListOpened" = false ]; then
            echo -e "${BLACK}Deje en blanco para ver los últimos 10 pedidos${N}"
        else
            echo -e "${BLACK}Vuelva a dejar en blanco para ver la lista completa de pedidos${N}"
        fi
        read -p "Ingrese el numero de pedido a eliminar ${BLACK}S|s para cancelar${N}: " numPedido

        if [ "$numPedido" = "s" ] || [ "$numPedido" = "S" ]; then
            clear
            break
        fi
        if [ ! "$numPedido" ]; then
            if [ "$tempListOpened" = false ]; then
                moverPrompt 2
                echo -e "${YELLOW}Últimos 10 pedidos:${N}"
                echo -e "$(head -n 1 $PEDIDOS)" "\n""$(tail -n 10 $PEDIDOS)" | column -t -o " | " -s "|"
                numRows=$(tail -n 10 $PEDIDOS | wc -l)
                tempListOpened=true
            else
                moverPrompt 2
                echo -e "${YELLOW}Lista completa de pedidos:${N}"
                column -t -o " | " -s "|" $PEDIDOS
                numRows=$(($(wc -l <$PEDIDOS) - 1))
            fi
            echo ""
            continue
        else
            moverPrompt 2
            tempListOpened=false
        fi
        lineaPedido=$(grep "^$numPedido|" $PEDIDOS)
        if [ $? -eq 0 ]; then
            # confirmar eliminación
            echo -e "${YELLOW}Pedido encontrado:${N}"
            echo -e "${BLUE}Nro. Pedido:${YELLOW}${N} $(echo $lineaPedido | cut -d"|" -f1)${N}"
            echo -e "${BLUE}Fecha:${YELLOW}${N}       $(echo $lineaPedido | cut -d"|" -f2)${N}"
            echo -e "${BLUE}Cliente:${YELLOW}${N}     $(echo $lineaPedido | cut -d"|" -f3)${N}"
            echo -e "${BLUE}Producto:${YELLOW}${N}    $(grep "^$(echo $lineaPedido | cut -d"|" -f4)|" $PRODUCTOS | cut -d"|" -f2)${BLACK} ($(echo $lineaPedido | cut -d"|" -f4))${N}"
            echo -e "${BLUE}Precio Uni.:${YELLOW}${N} \$$(grep "^$(echo $lineaPedido | cut -d"|" -f4)|" $PRODUCTOS | cut -d"|" -f3)${N}"
            echo -e "${BLUE}Cantidad:${YELLOW}${N}    $(echo $lineaPedido | cut -d"|" -f5)${N}"
            echo -e "${BLUE}Total:${YELLOW}${N}       \$$(echo $lineaPedido | cut -d"|" -f6)${N}"
            echo -e "${BLUE}Vendedor:${YELLOW}${N}    $(echo $lineaPedido | cut -d"|" -f7)${N}"
            echo ""
            read -n 1 -s -p "${YELLOW}-> Confirmar eliminación ${BLACK}(s/n): ${N}" confirm
            echo -e "\n"
            if [ "$confirm" = "n" ]; then
                moverPrompt 2
                continue
            elif [ "$confirm" = "s" ]; then
                sed -i "/^$numPedido|/d" $PEDIDOS
                echo -e "${YELLOW}Eliminando pedido...${N}"
                spinner 20
                echo -e "${GREEN}Pedido eliminado${N}"
                sleep 2
                clear
                break
            fi
        else
            echo -e "${MAGENTA}ERROR: El pedido no existe${N}"
        fi
    done
}
eliminarPedido
