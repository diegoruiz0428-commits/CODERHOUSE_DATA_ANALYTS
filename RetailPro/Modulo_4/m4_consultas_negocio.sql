


---CONSULTA 1 

SELECT  EXTRACT(MONTH FROM fecha_venta) AS mes , 
       SUM(cantidad*precio_unitario) AS total_facturado, 
       COUNT(*)  AS cantidad_pedido,
       AVG(cantidad*precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY  EXTRACT(MONTH  FROM fecha_venta);

---CONSULTA 2 

SELECT  id_producto,
        SUM(cantidad) AS unidades_vendidas,
       SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC
LIMIT 5; 

---CONSULTA 3

SELECT  id_cliente, 
         COUNT(*) AS cantidad_pedidos,
		 SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1; 

---CONSULTA 4

SELECT mes,
       total_facturado,
       CASE
        WHEN total_facturado > (
        SELECT AVG(total_facturado)
         FROM (
         SELECT EXTRACT(MONTH FROM fecha_venta) AS mes,
          SUM(cantidad * precio_unitario) AS total_facturado
          FROM ventas
           GROUP BY EXTRACT(MONTH FROM fecha_venta) 
               ) AS promedio_mes ) 
           THEN 'Por encima'
           ELSE 'Por debajo'
       END AS comparacion_promedio
FROM (
    SELECT EXTRACT(MONTH FROM fecha_venta) AS mes,
           SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY EXTRACT(MONTH FROM fecha_venta)
) AS ventas_mensuales
ORDER BY mes;

-- Hallazgo 1:
-- Según la consulta 1, durante el mes 3 se realizaron 10 pedidos,
-- con una facturación total de 6.444 y un ticket promedio de 644,40.

-- Hallazgo 2:
-- Según la consulta 2, el producto 2 fue el que registró la mayor cantidad
-- de unidades vendidas, con 13 unidades, pero tuvo una facturación relativamente
-- baja de 364 debido a su bajo precio unitario.

-- Hallazgo 3:
-- Según la consulta 4, el mes 3 aparece como "Por debajo" debido a que es el
-- único mes registrado. 
