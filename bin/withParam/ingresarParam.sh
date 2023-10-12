#/bin/bash

. $WORKPATH/bin/scripts/registarPedidos.sh

telefono_validos_regex="^[0-9]+$"

# Si iniciamos el script con el parámetro -a se solicitan los datos como parámetros

if [ "$2" = "-h" ] || [ "$2" = "--help" ]; then
    printTitle "Instrucciones para ingresar nuevo pedido"
    echo -e "${CYAN}Uso: $0 -c add <telefono_cliente> <codigo_producto> <cantidad>${N}"
    exit 0
fi
# Validamos que se hayan ingresado los parámetros necesarios
if [ $# -ne 4 ]; then
    echo -e "${MAGENTA}ERROR: Faltan parámetros${N}"
    echo -e "${MAGENTA}Uso: $0 -a <telefono_cliente> <codigo_producto> <cantidad>${N}"
    exit 1
fi

# Validamos que el telefono del cliente no esté vacío
if [ ! "$2" ]; then
    echo -e "${MAGENTA}ERROR: El telefono del cliente no puede estar vacío${N}"
    exit 1
fi

# Validamos que el numero del cliente no contenga caracteres inválidos
# limpiarEspaciosExtra es una función definida en helpers/limpiarEspaciosExtra.sh
cliente=$(limpiarEspaciosExtra "$2")
if [[ ! $cliente =~ $telefono_validos_regex ]]; then
    echo -e "${MAGENTA}ERROR: El telefono del cliente es inválido${N}"
    exit 1
fi

# Validamos que el código del producto no esté vacío
if [ ! "$3" ]; then
    echo -e "${MAGENTA}ERROR: El código del producto no puede estar vacío${N}"
    exit 1
fi

# Buscamos el producto en el archivo de productos y validamos que exista
productoLinea=$(grep "^$3|" "$PRODUCTOS")

# Validamos que el producto exista
if [ ! "$productoLinea" ]; then
    echo -e "${MAGENTA}ERROR: El Código del producto no existe${N}"
    exit 1
else
    numLinea=$(grep -n "^$3|" "$PRODUCTOS" | cut -d: -f1)

    # Almacenamos el stock del producto
    stock=$(echo $productoLinea | cut -d "|" -f4)

    # Validamos que el producto tenga stock
    if [ $stock -eq 0 ]; then
        echo -e "${YELLOW}--> El producto no tiene stock${N}"
        exit 1
    fi
fi

# Validamos que la cantidad no esté vacía
if [ ! "$4" ]; then
    echo -e "${MAGENTA}ERROR: La cantidad no puede estar vacía${N}"
    exit 1
elif [ $4 -lt 1 ]; then
    # Validamos que la cantidad ingresada no sea menor o igual que 0.
    echo -e "${MAGENTA}ERROR: La cantidad debe ser mayor a 0${N}"
    exit 1
elif [ $4 -gt $(echo $productoLinea | cut -d "|" -f4) ]; then
    # Validamos que la cantidad no sea mayor al stock
    echo -e "${MAGENTA}ERROR: La cantidad debe ser menor o igual al stock${N}"
    exit 1
fi

# Registramos el pedido en el archivo de pedidos.
total=$(($(grep "^$3|" "$PRODUCTOS" | cut -d "|" -f3) * $4))
registroPedido $2 $3 $4 $total
exit $?
