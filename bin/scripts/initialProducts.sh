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
echo "ID:Descripción:Precio:Stock" >>$PRODUCTOS
echo "ID:Fecha:Tel. Cliente:ID Combo:Cantidad:Total $:Vendedor" >>$PEDIDOS
echo "ID:Nombre:Telefono" >>$CLIENTES

# Ingresamos los productos (Combos)
for i in {1..10}; do
    precio=$(($RANDOM % 500 + 100))
    stock=$(($RANDOM % 100 + 10))
    echo "C$i:Combo $i:$precio:$stock" >>$PRODUCTOS
done

for i in {1..10}; do

    echo "C$i:Cliente $i:$((i * 123321))" >>$CLIENTES
done

spinner 20

echo -e "${GREEN}Todo OK${N} \n"

echo "Ejecute el programa nuevamente"

exit 0
