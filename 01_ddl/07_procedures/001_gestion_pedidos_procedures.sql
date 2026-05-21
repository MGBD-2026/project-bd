-- =====================================================
-- PROCEDURES PARA GESTIÓN DE PEDIDOS
-- Schema: ventas
-- =====================================================

-- =====================================================
-- PROCEDURE: sp_actualizar_estado_pedido
-- Descripción: Actualiza el estado de un pedido y registra
--              el cambio en el historial de estados.
-- Parámetros:
--   p_id_pedido   - ID del pedido a actualizar
--   p_id_estado   - ID del nuevo estado
--   p_observacion - Observación opcional del cambio
-- =====================================================
CREATE OR REPLACE PROCEDURE ventas.sp_actualizar_estado_pedido(
    p_id_pedido   INTEGER,
    p_id_estado   INTEGER,
    p_observacion TEXT DEFAULT NULL
)
LANGUAGE plpgsql
AS '
DECLARE
    v_existe INTEGER;
BEGIN
    SELECT COUNT(1) INTO v_existe
    FROM ventas.pedido
    WHERE id_pedido = p_id_pedido;

    IF v_existe = 0 THEN
        RAISE EXCEPTION ''Pedido % no existe'', p_id_pedido;
    END IF;

    UPDATE ventas.pedido
    SET id_estado_actual = p_id_estado
    WHERE id_pedido = p_id_pedido;

    INSERT INTO logistica.historial_estado_pedido (id_pedido, id_estado, observacion)
    VALUES (p_id_pedido, p_id_estado, p_observacion);
END;
';

-- =====================================================
-- PROCEDURE: sp_vaciar_carrito
-- Descripción: Elimina todos los ítems de un carrito activo
--              y lo marca como abandonado.
-- Parámetros:
--   p_id_carrito - ID del carrito a vaciar
-- =====================================================
CREATE OR REPLACE PROCEDURE ventas.sp_vaciar_carrito(
    p_id_carrito INTEGER
)
LANGUAGE plpgsql
AS '
DECLARE
    v_estado VARCHAR(20);
BEGIN
    SELECT estado INTO v_estado
    FROM ventas.carrito
    WHERE id_carrito = p_id_carrito;

    IF v_estado IS NULL THEN
        RAISE EXCEPTION ''Carrito % no existe'', p_id_carrito;
    END IF;

    IF v_estado <> ''activo'' THEN
        RAISE EXCEPTION ''Carrito % no está activo (estado: %)'', p_id_carrito, v_estado;
    END IF;

    DELETE FROM ventas.item_carrito
    WHERE id_carrito = p_id_carrito;

    UPDATE ventas.carrito
    SET estado = ''abandonado''
    WHERE id_carrito = p_id_carrito;
END;
';
