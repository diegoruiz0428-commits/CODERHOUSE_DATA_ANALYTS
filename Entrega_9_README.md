# RetailPro | Proyecto de análisis de datos

Proyecto académico de análisis comercial de una tienda de tecnología. El objetivo es organizar los datos, consultar las ventas y convertir los resultados en información útil para el equipo comercial.

## Alcance y fuentes

- **Práctica SQL:** base de ejemplo en PostgreSQL con **4 tablas** (`categorias`, `clientes`, `productos`, `ventas`), **5 clientes**, **6 productos**, **4 categorías** y **10 registros de ventas** de marzo de 2024.
- **ETL y Power BI:** trabajo de limpieza, modelado, medidas DAX y visualización desarrollado en módulos posteriores con un **dataset de práctica diferente**. Sus totales no deben compararse directamente con los de la muestra SQL.
- Los datos se usan con fines de aprendizaje; no se presentan como operaciones reales de una empresa.

## Herramientas

| Herramienta | Uso |
|---|---|
| PostgreSQL | Motor de base de datos relacional |
| pgAdmin | Ejecución y comprobación de consultas SQL |
| Power Query / Power BI Desktop | Limpieza, relaciones, DAX y visualizaciones |
| Git y GitHub | Control de versiones y documentación |
| ChatGPT | Asistencia para revisar SQL y redactar documentación; resultados sujetos a validación |

## Estructura de datos SQL

- `categorias`: catálogo de categorías; clave primaria `id_categoria`.
- `clientes`: datos de clientes; clave primaria `id_cliente`.
- `productos`: productos con clave foránea `id_categoria`.
- `ventas`: transacciones con claves foráneas `id_cliente` e `id_producto`.

Relaciones: `categorias (1) → (N) productos`, `clientes (1) → (N) ventas` y `productos (1) → (N) ventas`.

## Cómo ejecutar el SQL en PostgreSQL

1. Crea una base de datos de práctica en PostgreSQL y abre **pgAdmin → Query Tool**.
2. Abre el archivo `RetailPro_PostgreSQL.sql` de este repositorio.
3. **Advertencia:** el script contiene `DROP TABLE IF EXISTS`; ejecútalo únicamente en una base de práctica, porque elimina las tablas indicadas si ya existen.
4. Ejecuta el script completo. Crea las tablas, inserta los registros y ejecuta las consultas de ejemplo.
5. Verifica los resultados con `SELECT * FROM ventas;` y las consultas de resumen mensual y ranking de productos.

## Indicadores de la muestra SQL

| Indicador | Definición |
|---|---|
| Facturación total | `SUM(cantidad * precio_unitario)` |
| Cantidad de transacciones | `COUNT(*)` sobre `ventas` (cada fila tiene un `id_venta` único) |
| Ticket promedio por transacción | `AVG(cantidad * precio_unitario)` |
| Unidades vendidas | `SUM(cantidad)` |
| Ranking de productos | Facturación agregada por `id_producto`, ordenada de mayor a menor |

Con los registros de ejemplo incluidos en el script, la facturación de marzo de 2024 es **6.444,00 unidades monetarias**, distribuida en **10 transacciones**, con un ticket promedio de **644,40**. El script no especifica una moneda.

## Limitaciones y validación

- La muestra SQL contiene un solo mes: no permite concluir si las ventas están creciendo o cayendo.
- **Facturación no es utilidad:** el ranking por ingresos no demuestra qué producto tiene mayor margen.
- La IA se utilizó para generar propuestas de redacción y revisar consultas; los valores publicados deben comprobarse contra los registros fuente.
- Para evaluar rendimiento SQL, no basta con reescribir la consulta: se requiere contrastar planes de ejecución y tiempos con `EXPLAIN (ANALYZE, BUFFERS)` en un volumen representativo.

## Archivos principales

- `RetailPro_PostgreSQL.sql`: creación de tablas, datos de ejemplo y consultas de los módulos de SQL.
- Archivos `.pbix` y documentos de entregas: se incorporan al repositorio cuando corresponda.

## Autoría

Proyecto académico individual. La asistencia de IA se utilizó como apoyo; la revisión y la responsabilidad sobre los resultados corresponden al autor.
