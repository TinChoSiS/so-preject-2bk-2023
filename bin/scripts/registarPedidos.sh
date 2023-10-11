#!/bin/bash

# Registramos las ventas en un archivo persistente

# ID:Fecha:Tel. Cliente:ID Combo:Cantidad:Total $:Vendedor

function registroPedido() {
    if [ ! "$1" ] || [ ! "$2" ] || [ ! "$3" ] || [ ! "$4" ]; then
        echo -e "${MAGENTA}ERROR: Faltan argumentos${N}"
        echo -e "${YELLOW}Uso:${N} registroPedido <telefonoCliente> <cantidad> <total> [vendedor]"
        return 1
    fi
    fecha=$(date +"%d/%m/%Y %H:%M:%S")
    idPedido=$(grep -c ^ $PEDIDOS)
    telefonoCliente="$1"
    cantidad="$2"
    productoId="$3"
    total="$4"
    if [ ! "$5" ]; then
        vendedor=$USER
    else
        vendedor="$5"
    fi

    # Efecto de carga
    echo -e "\n${GREEN}--> Registrando pedido...${N}"
    spinner 20

    echo "$idPedido:$fecha:$telefonoCliente:$productoId:$cantidad:$total:$vendedor" >>$PEDIDOS
    return 0
}
