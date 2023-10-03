#!/bin/bash
clear
echo ""
echo "${CYAN}Inicializando aplicación...${N}"

if [ -f $PRODUCTOS ]; then
    rm -f $PRODUCTOS $PEDIDOS
fi

# Inicializamos el archivo de productos
touch $PRODUCTOS $PEDIDOS

# Ingresamos los títulos de la tabla
echo "ID:Nombre:Precio:Stock" >>$PRODUCTOS

# Ingresamos los productos (Combos)
for i in {1..10}; do
    echo "C$i:Combo $i:$((i * 1000)):$((i * 10))" >>$PRODUCTOS
done

pid=$! # Process Id of the previous running command

spin='-\|/'
i=1
while [ $i -lt 20 ]; do
    i=$((i + 1))
    printf "\r${spin:$i%4:1}"
    sleep .1
done

echo -e "${GREEN}Todo OK${N} \n"

echo "Ejecute el programa nuevamente sin la opción --init / -i"

exit 0
