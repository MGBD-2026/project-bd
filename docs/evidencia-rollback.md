# Evidencia de Rollback — accesorios-dm-database

## Comandos para reproducir el rollback

Ejecutar desde la raíz del repositorio `project-bd/`.

### 1. Levantar la base de datos

```bash
docker compose up -d
```

### 2. Verificar que las migraciones están aplicadas

```bash
docker compose run --rm liquibase status
```

Resultado esperado: todos los changesets marcados como aplicados.

### 3. Ejecutar el rollback del último changeset (datos volumétricos)

```bash
docker compose run --rm liquibase rollback-count --count=1
```

### 4. Verificar que el rollback se aplicó

```bash
docker exec -it accesorios-dm-postgres-dev \
  psql -U admin -d accesorios_dm_db \
  -c "SELECT COUNT(*) FROM clientes.cliente;"
```

Resultado esperado: 1 (solo el cliente demo, sin los 10 volumétricos).

### 5. Re-aplicar migraciones

```bash
docker compose run --rm liquibase update
```

---

## Secuencia completa de rollback por capas

```bash
# Revertir datos volumétricos
docker compose run --rm liquibase rollback-count --count=1

# Revertir datos iniciales
docker compose run --rm liquibase rollback-count --count=1

# Revertir DCL (roles, grants, políticas RLS)
docker compose run --rm liquibase rollback-count --count=3

# Revertir DDL (procedures, triggers, funciones, vistas, tablas, schemas, extensión)
docker compose run --rm liquibase rollback-count --count=12
```

---

## Resultado esperado de una migración limpia (`liquibase update`)

```
UPDATE SUMMARY
Run:            17
Previously run:  0
Filtered out:    0
-------------------------------
Total change sets: 17
```

Los 17 changesets corresponden a:

| # | Changeset ID                          | Capa  |
|---|---------------------------------------|-------|
| 1 | 001_enable_uuid_extension             | DDL   |
| 2 | 001_create_schemas                    | DDL   |
| 3 | 001_create_security_tables            | DDL   |
| 4 | 002_create_clientes_tables            | DDL   |
| 5 | 003_create_catalogo_tables            | DDL   |
| 6 | 004_create_imagen_producto_table      | DDL   |
| 7 | 005_create_promociones_tables         | DDL   |
| 8 | 006_create_carrito_tables             | DDL   |
| 9 | 007_create_pedidos_tables             | DDL   |
|10 | 008_create_inventario_movimiento_table| DDL   |
|11 | 001_report_views                      | DDL   |
|12 | 001_update_stock_functions            | DDL   |
|13 | 001_gestion_pedidos_procedures        | DDL   |
|14 | 001_inventario_triggers               | DDL   |
|15 | 001_performance_indexes               | DDL   |
|16 | 001_initial_data                      | DML   |
|17 | 002_volumetric_data                   | DML   |
