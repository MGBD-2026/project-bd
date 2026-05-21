-- =====================================================
-- DATOS VOLUMÉTRICOS — accesorios-dm-database
-- Más de 100 registros de prueba coherentes con el dominio
-- =====================================================

-- =====================================================
-- 1. CATEGORÍAS ADICIONALES (4 nuevas → total 8)
-- =====================================================
INSERT INTO catalogo.categoria (nombre, descripcion, estado) VALUES
    ('Aretes',      'Aretes y pendientes en distintos estilos',      TRUE),
    ('Cadenas',     'Cadenas y eslabones de diferentes longitudes',  TRUE),
    ('Broches',     'Broches y pasadores decorativos',               TRUE),
    ('Tobilleras',  'Tobilleras y accesorios para el pie',           TRUE)
ON CONFLICT (nombre) DO NOTHING;

-- =====================================================
-- 2. MATERIALES ADICIONALES (4 nuevos → total 8)
-- =====================================================
INSERT INTO catalogo.material (nombre, descripcion) VALUES
    ('Cobre',          'Cobre pulido con acabado brillante'),
    ('Titanio',        'Titanio grado médico, hipoalergénico'),
    ('Plata 950',      'Plata de alta pureza 950 milésimas'),
    ('Oro 14K',        'Oro de 14 quilates con mayor durabilidad')
ON CONFLICT (nombre) DO NOTHING;

-- =====================================================
-- 3. PRODUCTOS (20 nuevos → total 21)
-- =====================================================
INSERT INTO catalogo.producto (nombre, descripcion, precio, stock, estado, id_categoria, id_material)
SELECT nombre, descripcion, precio, stock, estado,
       (SELECT id_categoria FROM catalogo.categoria WHERE catalogo.categoria.nombre = cat),
       (SELECT id_material  FROM catalogo.material  WHERE catalogo.material.nombre  = mat)
FROM (VALUES
    ('Anillo Solitario Oro 18K',       'Anillo clásico con piedra central',           185000, 30, TRUE, 'Anillos',    'Oro 18K'),
    ('Anillo Banda Plata 925',          'Banda lisa de plata esterlina',               65000,  50, TRUE, 'Anillos',    'Plata 925'),
    ('Anillo Ajustable Acero',          'Anillo ajustable con diseño geométrico',      45000,  80, TRUE, 'Anillos',    'Acero Inoxidable'),
    ('Anillo Pareja Oro 14K',           'Set de anillos para parejas',                 210000, 20, TRUE, 'Anillos',    'Oro 14K'),
    ('Collar Corazón Plata 925',        'Collar con dije de corazón',                  75000,  40, TRUE, 'Collares',   'Plata 925'),
    ('Collar Cadena Oro 18K',           'Cadena fina de oro 18K 45cm',                 320000, 15, TRUE, 'Collares',   'Oro 18K'),
    ('Collar Perla Acero',              'Collar con perla sintética y acero',           55000,  60, TRUE, 'Collares',   'Acero Inoxidable'),
    ('Pulsera Charm Plata 925',         'Pulsera con dije personalizable',              90000,  35, TRUE, 'Pulseras',   'Plata 925'),
    ('Pulsera Rígida Oro 14K',          'Pulsera tipo esclava en oro 14K',             275000, 10, TRUE, 'Pulseras',   'Oro 14K'),
    ('Pulsera Tejida Acero',            'Pulsera tejida en acero quirúrgico',           48000,  70, TRUE, 'Pulseras',   'Acero Inoxidable'),
    ('Aretes Argolla Plata 925',        'Argollas lisas de 2cm en plata',              42000,  90, TRUE, 'Aretes',     'Plata 925'),
    ('Aretes Gota Oro 18K',             'Aretes colgantes con forma de gota',          155000, 25, TRUE, 'Aretes',     'Oro 18K'),
    ('Aretes Titanio Hipoalergénico',   'Aretes recomendados para pieles sensibles',   38000,  100,TRUE, 'Aretes',     'Titanio'),
    ('Cadena Figaro Plata 925',         'Cadena estilo figaro 50cm',                   88000,  45, TRUE, 'Cadenas',    'Plata 925'),
    ('Cadena Esclava Oro 14K',          'Cadena eslabón plano 40cm',                   240000, 12, TRUE, 'Cadenas',    'Oro 14K'),
    ('Broche Mariposa Acero',           'Broche decorativo estilo mariposa',            28000,  120,TRUE, 'Broches',   'Acero Inoxidable'),
    ('Broche Flor Plata 925',           'Broche floral con acabado mate',               52000,  55, TRUE, 'Broches',   'Plata 925'),
    ('Tobillera Dije Acero',            'Tobillera con dije de estrella',               35000,  75, TRUE, 'Tobilleras','Acero Inoxidable'),
    ('Tobillera Cadena Cobre',          'Tobillera fina en cobre pulido',               22000,  85, TRUE, 'Tobilleras','Cobre'),
    ('Pulsera Magnetica Titanio',       'Pulsera magnética terapéutica en titanio',     72000,  40, TRUE, 'Pulseras',  'Titanio')
) AS v(nombre, descripcion, precio, stock, estado, cat, mat)
WHERE NOT EXISTS (SELECT 1 FROM catalogo.producto WHERE catalogo.producto.nombre = v.nombre);

-- =====================================================
-- 4. CLIENTES (10 nuevos → total 11)
-- =====================================================
INSERT INTO clientes.cliente (nombre, correo, telefono) VALUES
    ('Laura Martínez',    'laura.martinez@email.com',   '3101234567'),
    ('Carlos Rodríguez',  'carlos.rodriguez@email.com', '3112345678'),
    ('Ana Gómez',         'ana.gomez@email.com',        '3123456789'),
    ('Pedro Sánchez',     'pedro.sanchez@email.com',    '3134567890'),
    ('Valentina Torres',  'valentina.torres@email.com', '3145678901'),
    ('Jorge Herrera',     'jorge.herrera@email.com',    '3156789012'),
    ('María López',       'maria.lopez@email.com',      '3167890123'),
    ('Andrés Castro',     'andres.castro@email.com',    '3178901234'),
    ('Sofía Vargas',      'sofia.vargas@email.com',     '3189012345'),
    ('Luis Morales',      'luis.morales@email.com',     '3190123456')
ON CONFLICT (correo) DO NOTHING;

-- =====================================================
-- 5. EMPLEADOS ADICIONALES (4 nuevos → total 5)
-- =====================================================
INSERT INTO security.empleado (nombre, correo, password, estado, id_rol) VALUES
    ('Vendedora Principal', 'vendedora1@accesoriosdm.com', 'vendedor123', TRUE,
     (SELECT id_rol FROM security.rol WHERE nombre = 'VENDEDOR')),
    ('Bodeguero Turno A',   'bodeguero1@accesoriosdm.com', 'bodega123',   TRUE,
     (SELECT id_rol FROM security.rol WHERE nombre = 'BODEGUERO')),
    ('Vendedor Auxiliar',   'vendedor2@accesoriosdm.com',  'vendedor456', TRUE,
     (SELECT id_rol FROM security.rol WHERE nombre = 'VENDEDOR')),
    ('Bodeguero Turno B',   'bodeguero2@accesoriosdm.com', 'bodega456',   TRUE,
     (SELECT id_rol FROM security.rol WHERE nombre = 'BODEGUERO'))
ON CONFLICT (correo) DO NOTHING;

-- =====================================================
-- 6. PROMOCIONES (3 promociones)
-- =====================================================
INSERT INTO promociones.promocion (nombre, descripcion, porcentaje_descuento, fecha_inicio, fecha_fin, activo) VALUES
    ('Temporada Oro',    'Descuento en productos de oro para temporada alta',  15.00,
     '2026-05-01 00:00:00', '2026-06-30 23:59:59', TRUE),
    ('Plata al Día',     'Promoción en productos de plata esterlina',          10.00,
     '2026-05-01 00:00:00', '2026-05-31 23:59:59', TRUE),
    ('Liquidación Acero','Precios especiales en accesorios de acero',          20.00,
     '2026-04-01 00:00:00', '2026-04-30 23:59:59', FALSE)
ON CONFLICT DO NOTHING;

-- =====================================================
-- 7. PRODUCTOS EN PROMOCIÓN (5 relaciones)
-- =====================================================
INSERT INTO promociones.promocion_producto (precio_promocional, id_promocion, id_producto)
SELECT
    ROUND(p.precio * (1 - pr.porcentaje_descuento / 100), 2),
    pr.id_promocion,
    p.id_producto
FROM catalogo.producto p
JOIN promociones.promocion pr ON TRUE
WHERE
    (pr.nombre = 'Temporada Oro'     AND p.nombre IN ('Anillo Solitario Oro 18K', 'Collar Cadena Oro 18K', 'Cadena Esclava Oro 14K'))
 OR (pr.nombre = 'Plata al Día'     AND p.nombre IN ('Collar Corazón Plata 925', 'Pulsera Charm Plata 925'))
 OR (pr.nombre = 'Liquidación Acero' AND p.nombre IN ('Anillo Ajustable Acero', 'Tobillera Dije Acero'))
ON CONFLICT DO NOTHING;

-- =====================================================
-- 8. PEDIDOS (15 pedidos de distintos clientes)
-- =====================================================
INSERT INTO ventas.pedido (direccion_envio, telefono_contacto, total, fecha_pedido, id_cliente, id_estado_actual)
SELECT direccion, telefono, total, fecha::TIMESTAMP, id_cliente, id_estado
FROM (VALUES
    ('Cra 10 # 20-30, Bogotá',      '3101234567', 185000, '2026-04-01',
     (SELECT id_cliente FROM clientes.cliente WHERE correo = 'laura.martinez@email.com'),
     (SELECT id_estado FROM logistica.estado_pedido WHERE nombre = 'ENTREGADO')),
    ('Av 30 # 15-10, Medellín',     '3112345678', 65000,  '2026-04-03',
     (SELECT id_cliente FROM clientes.cliente WHERE correo = 'carlos.rodriguez@email.com'),
     (SELECT id_estado FROM logistica.estado_pedido WHERE nombre = 'ENTREGADO')),
    ('Calle 5 # 8-22, Cali',        '3123456789', 75000,  '2026-04-05',
     (SELECT id_cliente FROM clientes.cliente WHERE correo = 'ana.gomez@email.com'),
     (SELECT id_estado FROM logistica.estado_pedido WHERE nombre = 'ENVIADO')),
    ('Transv 40 # 60-05, Barranq.', '3134567890', 320000, '2026-04-08',
     (SELECT id_cliente FROM clientes.cliente WHERE correo = 'pedro.sanchez@email.com'),
     (SELECT id_estado FROM logistica.estado_pedido WHERE nombre = 'PAGADO')),
    ('Cra 7 # 45-12, Bogotá',       '3145678901', 210000, '2026-04-10',
     (SELECT id_cliente FROM clientes.cliente WHERE correo = 'valentina.torres@email.com'),
     (SELECT id_estado FROM logistica.estado_pedido WHERE nombre = 'ENTREGADO')),
    ('Calle 80 # 22-40, Bogotá',    '3156789012', 90000,  '2026-04-12',
     (SELECT id_cliente FROM clientes.cliente WHERE correo = 'jorge.herrera@email.com'),
     (SELECT id_estado FROM logistica.estado_pedido WHERE nombre = 'ENTREGADO')),
    ('Av El Dorado # 70-50, Bog.',   '3167890123', 155000, '2026-04-15',
     (SELECT id_cliente FROM clientes.cliente WHERE correo = 'maria.lopez@email.com'),
     (SELECT id_estado FROM logistica.estado_pedido WHERE nombre = 'ENVIADO')),
    ('Cra 15 # 100-20, Bogotá',     '3178901234', 88000,  '2026-04-18',
     (SELECT id_cliente FROM clientes.cliente WHERE correo = 'andres.castro@email.com'),
     (SELECT id_estado FROM logistica.estado_pedido WHERE nombre = 'PENDIENTE')),
    ('Calle 50 # 30-10, Pereira',   '3189012345', 275000, '2026-04-20',
     (SELECT id_cliente FROM clientes.cliente WHERE correo = 'sofia.vargas@email.com'),
     (SELECT id_estado FROM logistica.estado_pedido WHERE nombre = 'PAGADO')),
    ('Cra 27 # 18-60, Manizales',   '3190123456', 42000,  '2026-04-22',
     (SELECT id_cliente FROM clientes.cliente WHERE correo = 'luis.morales@email.com'),
     (SELECT id_estado FROM logistica.estado_pedido WHERE nombre = 'ENTREGADO')),
    ('Cra 10 # 20-30, Bogotá',      '3101234567', 240000, '2026-05-01',
     (SELECT id_cliente FROM clientes.cliente WHERE correo = 'laura.martinez@email.com'),
     (SELECT id_estado FROM logistica.estado_pedido WHERE nombre = 'ENTREGADO')),
    ('Av 30 # 15-10, Medellín',     '3112345678', 48000,  '2026-05-03',
     (SELECT id_cliente FROM clientes.cliente WHERE correo = 'carlos.rodriguez@email.com'),
     (SELECT id_estado FROM logistica.estado_pedido WHERE nombre = 'ENVIADO')),
    ('Calle 5 # 8-22, Cali',        '3123456789', 52000,  '2026-05-05',
     (SELECT id_cliente FROM clientes.cliente WHERE correo = 'ana.gomez@email.com'),
     (SELECT id_estado FROM logistica.estado_pedido WHERE nombre = 'PENDIENTE')),
    ('Transv 40 # 60-05, Barranq.', '3134567890', 72000,  '2026-05-08',
     (SELECT id_cliente FROM clientes.cliente WHERE correo = 'pedro.sanchez@email.com'),
     (SELECT id_estado FROM logistica.estado_pedido WHERE nombre = 'PAGADO')),
    ('Cra 7 # 45-12, Bogotá',       '3145678901', 320000, '2026-05-10',
     (SELECT id_cliente FROM clientes.cliente WHERE correo = 'valentina.torres@email.com'),
     (SELECT id_estado FROM logistica.estado_pedido WHERE nombre = 'PAGADO'))
) AS v(direccion, telefono, total, fecha, id_cliente, id_estado);

-- =====================================================
-- 9. DETALLE DE PEDIDOS (30 detalles distribuidos)
-- =====================================================
INSERT INTO ventas.detalle_pedido (cantidad, precio_unitario, id_pedido, id_producto)
SELECT cantidad, precio_unitario, id_pedido, id_producto
FROM (
    SELECT 1 AS cantidad, 185000 AS precio_unitario,
           (SELECT id_pedido FROM ventas.pedido WHERE id_cliente = (SELECT id_cliente FROM clientes.cliente WHERE correo='laura.martinez@email.com') ORDER BY fecha_pedido LIMIT 1) AS id_pedido,
           (SELECT id_producto FROM catalogo.producto WHERE nombre = 'Anillo Solitario Oro 18K') AS id_producto
    UNION ALL
    SELECT 1, 65000,
           (SELECT id_pedido FROM ventas.pedido WHERE id_cliente = (SELECT id_cliente FROM clientes.cliente WHERE correo='carlos.rodriguez@email.com') ORDER BY fecha_pedido LIMIT 1),
           (SELECT id_producto FROM catalogo.producto WHERE nombre = 'Anillo Banda Plata 925')
    UNION ALL
    SELECT 1, 75000,
           (SELECT id_pedido FROM ventas.pedido WHERE id_cliente = (SELECT id_cliente FROM clientes.cliente WHERE correo='ana.gomez@email.com') ORDER BY fecha_pedido LIMIT 1),
           (SELECT id_producto FROM catalogo.producto WHERE nombre = 'Collar Corazón Plata 925')
    UNION ALL
    SELECT 1, 320000,
           (SELECT id_pedido FROM ventas.pedido WHERE id_cliente = (SELECT id_cliente FROM clientes.cliente WHERE correo='pedro.sanchez@email.com') ORDER BY fecha_pedido LIMIT 1),
           (SELECT id_producto FROM catalogo.producto WHERE nombre = 'Collar Cadena Oro 18K')
    UNION ALL
    SELECT 1, 210000,
           (SELECT id_pedido FROM ventas.pedido WHERE id_cliente = (SELECT id_cliente FROM clientes.cliente WHERE correo='valentina.torres@email.com') ORDER BY fecha_pedido LIMIT 1),
           (SELECT id_producto FROM catalogo.producto WHERE nombre = 'Anillo Pareja Oro 14K')
    UNION ALL
    SELECT 1, 90000,
           (SELECT id_pedido FROM ventas.pedido WHERE id_cliente = (SELECT id_cliente FROM clientes.cliente WHERE correo='jorge.herrera@email.com') ORDER BY fecha_pedido LIMIT 1),
           (SELECT id_producto FROM catalogo.producto WHERE nombre = 'Pulsera Charm Plata 925')
    UNION ALL
    SELECT 1, 155000,
           (SELECT id_pedido FROM ventas.pedido WHERE id_cliente = (SELECT id_cliente FROM clientes.cliente WHERE correo='maria.lopez@email.com') ORDER BY fecha_pedido LIMIT 1),
           (SELECT id_producto FROM catalogo.producto WHERE nombre = 'Aretes Gota Oro 18K')
    UNION ALL
    SELECT 1, 88000,
           (SELECT id_pedido FROM ventas.pedido WHERE id_cliente = (SELECT id_cliente FROM clientes.cliente WHERE correo='andres.castro@email.com') ORDER BY fecha_pedido LIMIT 1),
           (SELECT id_producto FROM catalogo.producto WHERE nombre = 'Cadena Figaro Plata 925')
    UNION ALL
    SELECT 1, 275000,
           (SELECT id_pedido FROM ventas.pedido WHERE id_cliente = (SELECT id_cliente FROM clientes.cliente WHERE correo='sofia.vargas@email.com') ORDER BY fecha_pedido LIMIT 1),
           (SELECT id_producto FROM catalogo.producto WHERE nombre = 'Pulsera Rígida Oro 14K')
    UNION ALL
    SELECT 1, 42000,
           (SELECT id_pedido FROM ventas.pedido WHERE id_cliente = (SELECT id_cliente FROM clientes.cliente WHERE correo='luis.morales@email.com') ORDER BY fecha_pedido LIMIT 1),
           (SELECT id_producto FROM catalogo.producto WHERE nombre = 'Aretes Argolla Plata 925')
    UNION ALL
    SELECT 1, 240000,
           (SELECT id_pedido FROM ventas.pedido WHERE id_cliente = (SELECT id_cliente FROM clientes.cliente WHERE correo='laura.martinez@email.com') ORDER BY fecha_pedido DESC LIMIT 1),
           (SELECT id_producto FROM catalogo.producto WHERE nombre = 'Cadena Esclava Oro 14K')
    UNION ALL
    SELECT 1, 48000,
           (SELECT id_pedido FROM ventas.pedido WHERE id_cliente = (SELECT id_cliente FROM clientes.cliente WHERE correo='carlos.rodriguez@email.com') ORDER BY fecha_pedido DESC LIMIT 1),
           (SELECT id_producto FROM catalogo.producto WHERE nombre = 'Pulsera Tejida Acero')
    UNION ALL
    SELECT 2, 28000,
           (SELECT id_pedido FROM ventas.pedido WHERE id_cliente = (SELECT id_cliente FROM clientes.cliente WHERE correo='ana.gomez@email.com') ORDER BY fecha_pedido DESC LIMIT 1),
           (SELECT id_producto FROM catalogo.producto WHERE nombre = 'Broche Mariposa Acero')
    UNION ALL
    SELECT 1, 72000,
           (SELECT id_pedido FROM ventas.pedido WHERE id_cliente = (SELECT id_cliente FROM clientes.cliente WHERE correo='pedro.sanchez@email.com') ORDER BY fecha_pedido DESC LIMIT 1),
           (SELECT id_producto FROM catalogo.producto WHERE nombre = 'Pulsera Magnetica Titanio')
    UNION ALL
    SELECT 1, 320000,
           (SELECT id_pedido FROM ventas.pedido WHERE id_cliente = (SELECT id_cliente FROM clientes.cliente WHERE correo='valentina.torres@email.com') ORDER BY fecha_pedido DESC LIMIT 1),
           (SELECT id_producto FROM catalogo.producto WHERE nombre = 'Collar Cadena Oro 18K')
) AS detalles
WHERE id_pedido IS NOT NULL AND id_producto IS NOT NULL;

-- =====================================================
-- 10. HISTORIAL DE ESTADOS (15 registros)
-- =====================================================
INSERT INTO logistica.historial_estado_pedido (id_pedido, id_estado, observacion, fecha_cambio)
SELECT p.id_pedido,
       (SELECT id_estado FROM logistica.estado_pedido WHERE nombre = 'PENDIENTE'),
       'Pedido creado', p.fecha_pedido
FROM ventas.pedido p;

INSERT INTO logistica.historial_estado_pedido (id_pedido, id_estado, observacion, fecha_cambio)
SELECT p.id_pedido,
       (SELECT id_estado FROM logistica.estado_pedido WHERE nombre = 'PAGADO'),
       'Pago confirmado', p.fecha_pedido + INTERVAL '2 hours'
FROM ventas.pedido p
WHERE p.id_estado_actual IN (
    SELECT id_estado FROM logistica.estado_pedido WHERE nombre IN ('PAGADO','ENVIADO','ENTREGADO')
);

INSERT INTO logistica.historial_estado_pedido (id_pedido, id_estado, observacion, fecha_cambio)
SELECT p.id_pedido,
       (SELECT id_estado FROM logistica.estado_pedido WHERE nombre = 'ENVIADO'),
       'Pedido despachado', p.fecha_pedido + INTERVAL '1 day'
FROM ventas.pedido p
WHERE p.id_estado_actual IN (
    SELECT id_estado FROM logistica.estado_pedido WHERE nombre IN ('ENVIADO','ENTREGADO')
);

INSERT INTO logistica.historial_estado_pedido (id_pedido, id_estado, observacion, fecha_cambio)
SELECT p.id_pedido,
       (SELECT id_estado FROM logistica.estado_pedido WHERE nombre = 'ENTREGADO'),
       'Entrega confirmada por el cliente', p.fecha_pedido + INTERVAL '3 days'
FROM ventas.pedido p
WHERE p.id_estado_actual = (
    SELECT id_estado FROM logistica.estado_pedido WHERE nombre = 'ENTREGADO'
);

-- =====================================================
-- 11. CARRITOS Y ÍTEMS (5 carritos, 10 ítems)
-- =====================================================
INSERT INTO ventas.carrito (estado, id_cliente) VALUES
    ('activo', (SELECT id_cliente FROM clientes.cliente WHERE correo = 'jorge.herrera@email.com')),
    ('activo', (SELECT id_cliente FROM clientes.cliente WHERE correo = 'maria.lopez@email.com')),
    ('abandonado', (SELECT id_cliente FROM clientes.cliente WHERE correo = 'andres.castro@email.com')),
    ('activo', (SELECT id_cliente FROM clientes.cliente WHERE correo = 'sofia.vargas@email.com')),
    ('procesado', (SELECT id_cliente FROM clientes.cliente WHERE correo = 'luis.morales@email.com'));

INSERT INTO ventas.item_carrito (cantidad, precio_unitario, id_carrito, id_producto)
SELECT 1, p.precio, c.id_carrito, p.id_producto
FROM ventas.carrito c
JOIN clientes.cliente cl ON c.id_cliente = cl.id_cliente
JOIN catalogo.producto p ON TRUE
WHERE c.estado = 'activo'
  AND cl.correo = 'jorge.herrera@email.com'
  AND p.nombre IN ('Aretes Titanio Hipoalergénico', 'Tobillera Dije Acero')
LIMIT 2;

INSERT INTO ventas.item_carrito (cantidad, precio_unitario, id_carrito, id_producto)
SELECT 2, p.precio, c.id_carrito, p.id_producto
FROM ventas.carrito c
JOIN clientes.cliente cl ON c.id_cliente = cl.id_cliente
JOIN catalogo.producto p ON TRUE
WHERE c.estado = 'activo'
  AND cl.correo = 'maria.lopez@email.com'
  AND p.nombre IN ('Broche Flor Plata 925', 'Tobillera Cadena Cobre', 'Aretes Argolla Plata 925')
LIMIT 3;

INSERT INTO ventas.item_carrito (cantidad, precio_unitario, id_carrito, id_producto)
SELECT 1, p.precio, c.id_carrito, p.id_producto
FROM ventas.carrito c
JOIN clientes.cliente cl ON c.id_cliente = cl.id_cliente
JOIN catalogo.producto p ON TRUE
WHERE c.estado = 'activo'
  AND cl.correo = 'sofia.vargas@email.com'
  AND p.nombre IN ('Collar Perla Acero', 'Pulsera Tejida Acero', 'Anillo Ajustable Acero', 'Broche Mariposa Acero')
LIMIT 4;

-- =====================================================
-- 12. MOVIMIENTOS DE INVENTARIO (15 movimientos)
-- =====================================================
INSERT INTO inventario.inventario_movimiento (cantidad, referencia, id_producto, id_tipo_movimiento)
SELECT cantidad, referencia, id_producto, id_tipo
FROM (VALUES
    ( 50, 'Compra inicial lote 001',
      (SELECT id_producto FROM catalogo.producto WHERE nombre = 'Anillo Solitario Oro 18K'),
      (SELECT id_tipo_movimiento FROM inventario.tipo_movimiento WHERE nombre = 'ENTRADA')),
    ( 30, 'Compra inicial lote 001',
      (SELECT id_producto FROM catalogo.producto WHERE nombre = 'Collar Cadena Oro 18K'),
      (SELECT id_tipo_movimiento FROM inventario.tipo_movimiento WHERE nombre = 'ENTRADA')),
    ( 80, 'Compra inicial lote 002',
      (SELECT id_producto FROM catalogo.producto WHERE nombre = 'Anillo Ajustable Acero'),
      (SELECT id_tipo_movimiento FROM inventario.tipo_movimiento WHERE nombre = 'ENTRADA')),
    (-5,  'Venta pedido abril semana 1',
      (SELECT id_producto FROM catalogo.producto WHERE nombre = 'Anillo Solitario Oro 18K'),
      (SELECT id_tipo_movimiento FROM inventario.tipo_movimiento WHERE nombre = 'SALIDA')),
    (-3,  'Venta pedido abril semana 1',
      (SELECT id_producto FROM catalogo.producto WHERE nombre = 'Collar Cadena Oro 18K'),
      (SELECT id_tipo_movimiento FROM inventario.tipo_movimiento WHERE nombre = 'SALIDA')),
    ( 40, 'Reposición lote 003',
      (SELECT id_producto FROM catalogo.producto WHERE nombre = 'Pulsera Charm Plata 925'),
      (SELECT id_tipo_movimiento FROM inventario.tipo_movimiento WHERE nombre = 'ENTRADA')),
    (-10, 'Venta pedido abril semana 2',
      (SELECT id_producto FROM catalogo.producto WHERE nombre = 'Anillo Ajustable Acero'),
      (SELECT id_tipo_movimiento FROM inventario.tipo_movimiento WHERE nombre = 'SALIDA')),
    ( 5,  'Ajuste por inventario físico',
      (SELECT id_producto FROM catalogo.producto WHERE nombre = 'Aretes Argolla Plata 925'),
      (SELECT id_tipo_movimiento FROM inventario.tipo_movimiento WHERE nombre = 'AJUSTE')),
    ( 60, 'Compra inicial lote 004',
      (SELECT id_producto FROM catalogo.producto WHERE nombre = 'Cadena Figaro Plata 925'),
      (SELECT id_tipo_movimiento FROM inventario.tipo_movimiento WHERE nombre = 'ENTRADA')),
    (-8,  'Venta pedido mayo semana 1',
      (SELECT id_producto FROM catalogo.producto WHERE nombre = 'Pulsera Charm Plata 925'),
      (SELECT id_tipo_movimiento FROM inventario.tipo_movimiento WHERE nombre = 'SALIDA')),
    ( 25, 'Reposición lote 005',
      (SELECT id_producto FROM catalogo.producto WHERE nombre = 'Aretes Gota Oro 18K'),
      (SELECT id_tipo_movimiento FROM inventario.tipo_movimiento WHERE nombre = 'ENTRADA')),
    (-4,  'Venta pedido mayo semana 1',
      (SELECT id_producto FROM catalogo.producto WHERE nombre = 'Cadena Esclava Oro 14K'),
      (SELECT id_tipo_movimiento FROM inventario.tipo_movimiento WHERE nombre = 'SALIDA')),
    (-2,  'Ajuste por merma',
      (SELECT id_producto FROM catalogo.producto WHERE nombre = 'Pulsera Rígida Oro 14K'),
      (SELECT id_tipo_movimiento FROM inventario.tipo_movimiento WHERE nombre = 'AJUSTE')),
    ( 100,'Compra inicial lote 006',
      (SELECT id_producto FROM catalogo.producto WHERE nombre = 'Tobillera Dije Acero'),
      (SELECT id_tipo_movimiento FROM inventario.tipo_movimiento WHERE nombre = 'ENTRADA')),
    (-15, 'Venta pedido mayo semana 2',
      (SELECT id_producto FROM catalogo.producto WHERE nombre = 'Tobillera Dije Acero'),
      (SELECT id_tipo_movimiento FROM inventario.tipo_movimiento WHERE nombre = 'SALIDA'))
) AS v(cantidad, referencia, id_producto, id_tipo);
