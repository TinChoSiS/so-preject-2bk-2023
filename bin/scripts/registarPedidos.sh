# registarPedidos.sh
#!/bin/bash

# Registramos las ventas en un archivo persistente

# ID|Fecha:Tel. Cliente|ID Combo|Cantidad|Total $|Vendedor

function registroPedido() {
    if [ ! "$1" ] || [ ! "$2" ] || [ ! "$3" ] || [ ! "$4" ]; then
        echo -e "${MAGENTA}ERROR: Faltan argumentos${N}"
        echo -e "${YELLOW}Uso:${N} registroPedido <telefonoCliente> <idProducto> <cantidad> <total> [vendedor]"
        return 1
    fi
    idPedido=$(($(tail -n 1 $PEDIDOS | cut -d "|" -f1) + 1))
    telefonoCliente="$1"
    productoId="$2"
    cantidad="$3"
    total="$4"
    if [ ! "$5" ]; then
        vendedor=$USER
    else
        vendedor="$5"
    fi
    if [ ! "$6" ]; then
        fecha=$(date +"%d-%m-%Y %H:%M:%S")
    else
        #quitar puntos y reemplazar por " " para evitar 2 parametros
        fecha=$(echo "$6" | sed 's/\./ /g')
    fi

    productoLinea=$(grep "^$productoId|" "$PRODUCTOS")
    # Pedido confirmado, se resta la cantidad ingresada al stock del producto.
    resto=$(($(echo $productoLinea | cut -d "|" -f4) - $cantidad))
    # Obtenemos el número de línea del producto en el archivo de productos.
    numLinea=$(grep -n "^$productoId|" $PRODUCTOS | cut -d: -f1)

    # Reemplazamos el stock del producto en el archivo de productos.
    sed -i ''$numLinea's/'$(echo $productoLinea | cut -d "|" -f4)'*$/'$resto'/' $PRODUCTOS

    # Registramos el pedido en el archivo de pedidos.
    echo "$idPedido|$fecha|$telefonoCliente|$productoId|$cantidad|$total|$vendedor" >>$PEDIDOS
    return 0
}
