# Evidencia de Rollback — accesorios-dm-database

## Comandos para reproducir el rollback

Ejecutar desde la raíz del repositorio `project-bd/`.

### 1. Levantar la base de datos

```bash
docker compose up -d
```

### 2. Verificar que las migraciones están aplicadas

```bash
docker compose run --rm liquibase \
  status \
  --url=jdbc:postgresql://postgres:5432/accesorios_dm_db \
  --username=admin \
  --password=admin123 \
  --changelog-file=./changelog-master.yaml
```

Resultado esperado: todos los changesets marcados como aplicados.

### 3. Ejecutar el rollback del último changeset (políticas RLS)

```bash
docker compose run --rm liquibase \
  rollback-count \
  --url=jdbc:postgresql://postgres:5432/accesorios_dm_db \
  --username=admin \
  --password=admin123 \
  --changelog-file=./changelog-master.yaml \
  --count=1
```

### 4. Salida real capturada del rollback

```
Rolling Back Changeset: 03_dcl/02_policies/changelog.yaml::001_rls_policies::JSA
Liquibase command 'rollback-count' was executed successfully.
```

### 5. Re-aplicar migraciones

```bash
docker compose run --rm liquibase \
  update \
  --url=jdbc:postgresql://postgres:5432/accesorios_dm_db \
  --username=admin \
  --password=admin123 \
  --changelog-file=./changelog-master.yaml
```

Salida real capturada del re-apply:

```
Running Changeset: 03_dcl/02_policies/changelog.yaml::001_rls_policies::JSA
Run:                          1
Previously run:              19
Total change sets:           20
Liquibase command 'update' was executed successfully.
```

---

## Secuencia completa de rollback por capas

```bash
# Revertir DCL — políticas RLS (changeset 20)
docker compose run --rm liquibase rollback-count \
  --url=jdbc:postgresql://postgres:5432/accesorios_dm_db \
  --username=admin --password=admin123 \
  --changelog-file=./changelog-master.yaml --count=1

# Revertir DCL — grants (changeset 19)
docker compose run --rm liquibase rollback-count \
  --url=jdbc:postgresql://postgres:5432/accesorios_dm_db \
  --username=admin --password=admin123 \
  --changelog-file=./changelog-master.yaml --count=1

# Revertir DCL — roles de aplicación (changeset 18)
docker compose run --rm liquibase rollback-count \
  --url=jdbc:postgresql://postgres:5432/accesorios_dm_db \
  --username=admin --password=admin123 \
  --changelog-file=./changelog-master.yaml --count=1

# Revertir datos volumétricos (changeset 17)
docker compose run --rm liquibase rollback-count \
  --url=jdbc:postgresql://postgres:5432/accesorios_dm_db \
  --username=admin --password=admin123 \
  --changelog-file=./changelog-master.yaml --count=1
```

---

## Resultado esperado de una migración limpia (`liquibase update`)

```
UPDATE SUMMARY
Run:                         20
Previously run:               0
Filtered out:                 0
-------------------------------
Total change sets:           20

Liquibase: Update has been successful. Rows affected: 197
Liquibase command 'update' was executed successfully.
```

Los 20 changesets corresponden a:

| #  | Changeset ID                            | Capa  |
|----|-----------------------------------------|-------|
|  1 | 001_enable_uuid_extension               | DDL   |
|  2 | 001_create_schemas                      | DDL   |
|  3 | 001_create_security_tables              | DDL   |
|  4 | 002_create_clientes_tables              | DDL   |
|  5 | 003_create_catalogo_tables              | DDL   |
|  6 | 004_create_imagen_producto_table        | DDL   |
|  7 | 005_create_promociones_tables           | DDL   |
|  8 | 006_create_carrito_tables               | DDL   |
|  9 | 007_create_pedidos_tables               | DDL   |
| 10 | 008_create_inventario_movimiento_table  | DDL   |
| 11 | 001_report_views                        | DDL   |
| 12 | 001_update_stock_functions              | DDL   |
| 13 | 001_gestion_pedidos_procedures          | DDL   |
| 14 | 001_inventario_triggers                 | DDL   |
| 15 | 001_performance_indexes                 | DDL   |
| 16 | 001_initial_data                        | DML   |
| 17 | 002_volumetric_data                     | DML   |
| 18 | 001_create_roles                        | DCL   |
| 19 | 001_grants                              | DCL   |
| 20 | 001_rls_policies                        | DCL   |
