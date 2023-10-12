#!/bin/bash
clear
echo ""
echo "${CYAN}Inicializando aplicación...${N}"

if [ -f $PRODUCTOS ]; then
    rm -f $PRODUCTOS $PEDIDOS $CLIENTES
fi

# Inicializamos el archivo de productos
touch $PRODUCTOS $PEDIDOS $CLIENTES

# Ingresamos los títulos de la tabla
echo "ID|Descripción|Precio|Stock" >>$PRODUCTOS
echo "ID|Fecha|Tel. Cliente|ID Combo|Cantidad|Total $|Vendedor" >>$PEDIDOS
echo "ID|Nombre|Telefono" >>$CLIENTES

# Ingresamos los productos (Combos) Random
for i in {1..10}; do
    precio=$(($RANDOM % 500 + 100))
    stock=$(($RANDOM % 100 + 10))
    echo "C$i|Combo $i|$precio|$stock" >>$PRODUCTOS
done

# Ingresamos los clientes Random
tempClientes=("Roberto" "Carlos" "Juan" "Pedro" "Maria" "Jose" "Luis" "Ana" "Marta" "Lucia" "Raul" "Jorge" "Ricardo" "Fernando" "Miguel" "Pablo" "Santiago" "Diego" "Daniel" "Manuel")
for i in {1..20}; do
    nombreCliente=${tempClientes[$(($RANDOM % 20))]}
    echo "$i|$nombreCliente|$((i * 123321))" >>$CLIENTES
done

spinner 20

echo -e "${GREEN}Todo OK${N} \n"

echo "Ejecute el programa nuevamente"

exit 0
