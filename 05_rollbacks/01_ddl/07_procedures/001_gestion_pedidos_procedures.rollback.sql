-- ROLLBACK: Eliminar procedures de gestión de pedidos
DROP PROCEDURE IF EXISTS ventas.sp_actualizar_estado_pedido(INTEGER, INTEGER, TEXT);
DROP PROCEDURE IF EXISTS ventas.sp_vaciar_carrito(INTEGER);
