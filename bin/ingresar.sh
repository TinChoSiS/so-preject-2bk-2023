#!/bin/bash
printTitle "Ingresar Nuevo Pedido"

cliente=""
usuario=$(whoami)
cantidad=0

productoLinea=""
productoId=""
numLinea=0

read -p "Ingrese el nombre del cliente: " cliente
while true; do
    read -p "Ingrese el Código del producto: " id
    tempProducto=$(grep -w ^$id $PRODUCTOS)
    if [ ! "$tempProducto" ]; then
        echo -e "${MAGENTA}ERROR: El ID del producto no existe${N}"
        continue
    fi
    read -p "Confirme el producto: ${CYAN}$(echo $tempProducto | cut -d: -f2)${N} (s/n): " confirm
    if [ "$confirm" != "s" ]; then
        continue
    fi
    productoLinea=$tempProducto
    productoId=$id
    numLinea=$(grep -n ^$id $PRODUCTOS | cut -d: -f1)
    break
done

while true; do
    read -p "Ingrese la cantidad: " tempCantidad
    if [ $tempCantidad -lt 1 ]; then
        echo -e "${MAGENTA}ERROR: La cantidad debe ser mayor a 0${N}"
        continue
    fi
    if [ $tempCantidad -gt $(echo $productoLinea | cut -d: -f4) ]; then
        echo -e "${MAGENTA}ERROR: La cantidad debe ser menor o igual al stock${N}"
        continue
    fi
    cantidad=$tempCantidad
    break
done

function confirmarPedido {
    printTitle "Confirmar Pedido"
    echo "Cliente: $cliente"
    echo "Producto: $(echo $productoLinea | cut -d: -f2)"
    echo "Cantidad: $cantidad"
    echo "Usuario: $usuario"
    read -p "¿Desea confirmar el pedido? (s/n): " confirm
    if [ "$confirm" != "s" ]; then
        return 1
    fi
    return 0
}
# confirmarPedido
tempResto=$(($(echo $productoLinea | cut -d: -f4) - $cantidad))
sed -i -e "/^$productoId/s/$(echo $productoLinea | cut -d: -f4)^/$tempResto/" $PRODUCTOS
# sed -i ''$numLinea'd' $PRODUCTOS

# echo $productoLinea >>$PRODUCTOS
echo $productoLinea
