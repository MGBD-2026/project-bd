-- ROLLBACK: Eliminar datos volumétricos en orden inverso a las FK

DELETE FROM inventario.inventario_movimiento
WHERE referencia IN (
    'Compra inicial lote 001','Compra inicial lote 002','Compra inicial lote 003',
    'Compra inicial lote 004','Compra inicial lote 005','Compra inicial lote 006',
    'Reposición lote 003','Reposición lote 005',
    'Venta pedido abril semana 1','Venta pedido abril semana 2',
    'Venta pedido mayo semana 1','Venta pedido mayo semana 2',
    'Ajuste por inventario físico','Ajuste por merma'
);

DELETE FROM ventas.item_carrito
WHERE id_carrito IN (
    SELECT c.id_carrito FROM ventas.carrito c
    JOIN clientes.cliente cl ON c.id_cliente = cl.id_cliente
    WHERE cl.correo IN (
        'jorge.herrera@email.com','maria.lopez@email.com',
        'andres.castro@email.com','sofia.vargas@email.com','luis.morales@email.com'
    )
);

DELETE FROM ventas.carrito
WHERE id_cliente IN (
    SELECT id_cliente FROM clientes.cliente WHERE correo IN (
        'jorge.herrera@email.com','maria.lopez@email.com',
        'andres.castro@email.com','sofia.vargas@email.com','luis.morales@email.com'
    )
);

DELETE FROM logistica.historial_estado_pedido
WHERE id_pedido IN (
    SELECT p.id_pedido FROM ventas.pedido p
    JOIN clientes.cliente c ON p.id_cliente = c.id_cliente
    WHERE c.correo IN (
        'laura.martinez@email.com','carlos.rodriguez@email.com','ana.gomez@email.com',
        'pedro.sanchez@email.com','valentina.torres@email.com','jorge.herrera@email.com',
        'maria.lopez@email.com','andres.castro@email.com','sofia.vargas@email.com',
        'luis.morales@email.com'
    )
);

DELETE FROM ventas.detalle_pedido
WHERE id_pedido IN (
    SELECT p.id_pedido FROM ventas.pedido p
    JOIN clientes.cliente c ON p.id_cliente = c.id_cliente
    WHERE c.correo IN (
        'laura.martinez@email.com','carlos.rodriguez@email.com','ana.gomez@email.com',
        'pedro.sanchez@email.com','valentina.torres@email.com','jorge.herrera@email.com',
        'maria.lopez@email.com','andres.castro@email.com','sofia.vargas@email.com',
        'luis.morales@email.com'
    )
);

DELETE FROM ventas.pedido
WHERE id_cliente IN (
    SELECT id_cliente FROM clientes.cliente WHERE correo IN (
        'laura.martinez@email.com','carlos.rodriguez@email.com','ana.gomez@email.com',
        'pedro.sanchez@email.com','valentina.torres@email.com','jorge.herrera@email.com',
        'maria.lopez@email.com','andres.castro@email.com','sofia.vargas@email.com',
        'luis.morales@email.com'
    )
);

DELETE FROM promociones.promocion_producto
WHERE id_promocion IN (
    SELECT id_promocion FROM promociones.promocion
    WHERE nombre IN ('Temporada Oro','Plata al Día','Liquidación Acero')
);

DELETE FROM promociones.promocion
WHERE nombre IN ('Temporada Oro','Plata al Día','Liquidación Acero');

DELETE FROM security.empleado
WHERE correo IN (
    'vendedora1@accesoriosdm.com','bodeguero1@accesoriosdm.com',
    'vendedor2@accesoriosdm.com','bodeguero2@accesoriosdm.com'
);

DELETE FROM clientes.cliente
WHERE correo IN (
    'laura.martinez@email.com','carlos.rodriguez@email.com','ana.gomez@email.com',
    'pedro.sanchez@email.com','valentina.torres@email.com','jorge.herrera@email.com',
    'maria.lopez@email.com','andres.castro@email.com','sofia.vargas@email.com',
    'luis.morales@email.com'
);

DELETE FROM catalogo.producto
WHERE nombre IN (
    'Anillo Solitario Oro 18K','Anillo Banda Plata 925','Anillo Ajustable Acero',
    'Anillo Pareja Oro 14K','Collar Corazón Plata 925','Collar Cadena Oro 18K',
    'Collar Perla Acero','Pulsera Charm Plata 925','Pulsera Rígida Oro 14K',
    'Pulsera Tejida Acero','Aretes Argolla Plata 925','Aretes Gota Oro 18K',
    'Aretes Titanio Hipoalergénico','Cadena Figaro Plata 925','Cadena Esclava Oro 14K',
    'Broche Mariposa Acero','Broche Flor Plata 925','Tobillera Dije Acero',
    'Tobillera Cadena Cobre','Pulsera Magnetica Titanio'
);

DELETE FROM catalogo.categoria WHERE nombre IN ('Aretes','Cadenas','Broches','Tobilleras');
DELETE FROM catalogo.material  WHERE nombre IN ('Cobre','Titanio','Plata 950','Oro 14K');
