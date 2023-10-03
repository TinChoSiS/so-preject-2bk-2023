#!/bin/bash
clear
echo ""
echo "Inicializando aplicación..."

if [ -f $PRODUCTOS ]; then
    rm -f $PRODUCTOS $VENTAS
fi

# Incializamos el archivo de productos
touch $PRODUCTOS $VENTAS

# Ingresamos los títulos de la tabla
echo "ID:Nombre:Precio:Stock" >>$PRODUCTOS

# Ingresamos los productos (Combos)
for i in {1..10}; do
    echo "$i:Combo $i:$((i * 1000)):$((i * 10))" >>$PRODUCTOS
done

pid=$! # Process Id of the previous running command

spin='-\|/'
i=1
while [ $i -lt 20 ]; do
    i=$((i + 1))
    printf "\r${spin:$i%4:1}"
    sleep .1
done

echo -e "${GREEN}Todo OK${NC} \n"

echo "Ejecute el programa nuevamente sin la opción --init / -i"

exit 0
