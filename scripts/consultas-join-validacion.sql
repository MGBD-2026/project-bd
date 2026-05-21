-- =====================================================
-- CONSULTAS DE VALIDACIÓN — JOIN de 6+ tablas
-- Sistema: accesorios-dm-database
-- Autor: JSA
-- =====================================================
-- Cómo ejecutar:
--   docker exec -it accesorios-dm-postgres-dev \
--     psql -U admin -d accesorios_dm_db -f /liquibase/changelog/scripts/consultas-join-validacion.sql
-- =====================================================


-- =====================================================
-- CONSULTA 1 (7 tablas)
-- Pregunta: ¿Cuáles son los productos vendidos por cliente,
--           con su categoría, material y estado del pedido?
-- Tablas: pedido, cliente, estado_pedido, detalle_pedido,
--         producto, categoria, material
-- =====================================================
SELECT
    c.nombre                        AS cliente,
    p.id_pedido,
    TO_CHAR(p.fecha_pedido, 'YYYY-MM-DD') AS fecha,
    ep.nombre                       AS estado_pedido,
    prod.nombre                     AS producto,
    cat.nombre                      AS categoria,
    mat.nombre                      AS material,
    dp.cantidad,
    dp.precio_unitario,
    dp.subtotal
FROM ventas.pedido              p
INNER JOIN clientes.cliente         c   ON p.id_cliente        = c.id_cliente
INNER JOIN logistica.estado_pedido  ep  ON p.id_estado_actual  = ep.id_estado
INNER JOIN ventas.detalle_pedido    dp  ON p.id_pedido         = dp.id_pedido
INNER JOIN catalogo.producto        prod ON dp.id_producto     = prod.id_producto
INNER JOIN catalogo.categoria       cat  ON prod.id_categoria  = cat.id_categoria
INNER JOIN catalogo.material        mat  ON prod.id_material   = mat.id_material
ORDER BY p.fecha_pedido DESC, c.nombre;


-- =====================================================
-- CONSULTA 2 (8 tablas)
-- Pregunta: ¿Qué productos entregados tuvieron más de un
--           cambio de estado, y cuál fue su trayectoria?
-- Tablas: pedido, cliente, detalle_pedido, producto,
--         categoria, historial_estado_pedido, estado_pedido, material
-- =====================================================
SELECT
    c.nombre                                AS cliente,
    p.id_pedido,
    prod.nombre                             AS producto,
    cat.nombre                              AS categoria,
    mat.nombre                              AS material,
    ep_hist.nombre                          AS estado_registrado,
    TO_CHAR(h.fecha_cambio, 'YYYY-MM-DD HH24:MI') AS fecha_cambio,
    h.observacion
FROM ventas.pedido                      p
INNER JOIN clientes.cliente             c        ON p.id_cliente       = c.id_cliente
INNER JOIN ventas.detalle_pedido        dp       ON p.id_pedido        = dp.id_pedido
INNER JOIN catalogo.producto            prod     ON dp.id_producto     = prod.id_producto
INNER JOIN catalogo.categoria           cat      ON prod.id_categoria  = cat.id_categoria
INNER JOIN catalogo.material            mat      ON prod.id_material   = mat.id_material
INNER JOIN logistica.historial_estado_pedido h   ON p.id_pedido        = h.id_pedido
INNER JOIN logistica.estado_pedido      ep_hist  ON h.id_estado        = ep_hist.id_estado
WHERE p.id_pedido IN (
    SELECT id_pedido
    FROM logistica.historial_estado_pedido
    GROUP BY id_pedido
    HAVING COUNT(*) > 1
)
ORDER BY p.id_pedido, h.fecha_cambio;


-- =====================================================
-- CONSULTA 3 (7 tablas) — Resumen de ventas por categoría
-- Pregunta: ¿Cuánto se ha vendido por categoría y material
--           considerando solo pedidos pagados o entregados?
-- Tablas: pedido, estado_pedido, detalle_pedido, producto,
--         categoria, material, cliente
-- =====================================================
SELECT
    cat.nombre                          AS categoria,
    mat.nombre                          AS material,
    COUNT(DISTINCT p.id_pedido)         AS total_pedidos,
    COUNT(DISTINCT c.id_cliente)        AS clientes_unicos,
    SUM(dp.cantidad)                    AS unidades_vendidas,
    SUM(dp.subtotal)                    AS ingresos_totales,
    ROUND(AVG(dp.precio_unitario), 2)   AS precio_promedio
FROM ventas.pedido              p
INNER JOIN logistica.estado_pedido  ep   ON p.id_estado_actual = ep.id_estado
INNER JOIN ventas.detalle_pedido    dp   ON p.id_pedido        = dp.id_pedido
INNER JOIN catalogo.producto        prod ON dp.id_producto     = prod.id_producto
INNER JOIN catalogo.categoria       cat  ON prod.id_categoria  = cat.id_categoria
INNER JOIN catalogo.material        mat  ON prod.id_material   = mat.id_material
INNER JOIN clientes.cliente         c    ON p.id_cliente       = c.id_cliente
WHERE ep.nombre IN ('PAGADO', 'ENTREGADO')
GROUP BY cat.nombre, mat.nombre
ORDER BY ingresos_totales DESC;
