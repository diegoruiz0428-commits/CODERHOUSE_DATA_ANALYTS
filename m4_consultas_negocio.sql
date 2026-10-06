

--- Motor Utilizado:PostgreSQL


---SECCION 1. DROP 

DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS categorias; 

---SECCION 2. TABLA CATEGORIAS 

CREATE TABLE categorias (
id_categoria INT PRIMARY KEY, 
nombre_categoria VARCHAR (50) NOT NULL, 
descripcion VARCHAR(200)  NOT NULL 
);

INSERT INTO categorias (id_categoria,nombre_categoria,descripcion) 
VALUES(1, 'Computación','Laptops, PCs y monitores'),
  (2, 'Accesorios','Periféricos y complementos'),
  (3, 'Audio','Auriculares y parlantes'),
  (4, 'Almacenamiento','Discos y memorias');

  SELECT * FROM categorias;
  
---SECCION 3. TABLA CLIENTES 

CREATE TABLE clientes (
id_cliente INT PRIMARY KEY , 
nombre VARCHAR (100) NOT NULL, 
email VARCHAR (100) UNIQUE NOT NULL, 
ciudad VARCHAR(50) NOT NULL, 
fecha_registro DATE NOT NULL 
);

INSERT INTO clientes (id_cliente,nombre,email,ciudad,fecha_registro)
VALUES  (1, 'María López','maria@mail.com','Buenos Aires', '2024-01-05'),
  (2, 'Carlos Ruiz','carlos@mail.com','Córdoba','2024-01-10'),
  (3, 'Ana Gómez','ana@mail.com','Rosario',  '2024-02-01'),
  (4, 'Pedro Sanz','pedro@mail.com','Mendoza','2024-02-15'),
  (5, 'Laura Torres','laura@mail.com','Tucumán','2024-03-01');

  SELECT * FROM clientes;

  
---SECCION 4. TABLA PRODUCTOS 

CREATE TABLE productos(
id_producto INT PRIMARY KEY,
nombre_producto VARCHAR (100) NOT NULL, 
id_categoria INT REFERENCES categorias(id_categoria), 
precio DECIMAL (10,2) NOT NULL, 
stock INT DEFAULT 0 ,
activo BOOLEAN DEFAULT TRUE
);

INSERT INTO productos (id_producto,nombre_producto,id_categoria,precio,stock,activo)
VALUES  (1, 'Laptop Pro 15',1,1200.00,15,TRUE),
  (2, 'Mouse Inalámbrico',2,28.00,80,TRUE),
  (3, 'Monitor 4K 27',1,450.00,12,TRUE),
  (4, 'Auriculares BT Pro',3,120.00,35,TRUE),
  (5, 'SSD Externo 1TB',4,130.00,18,TRUE),
  (6, 'Teclado Mecánico',2,95.00,40,TRUE);

  SELECT * FROM productos
  
--- SECCION 5.TABLA VENTAS

CREATE TABLE ventas(
id_venta INT PRIMARY KEY , 
id_cliente INT REFERENCES clientes (id_cliente), 
id_producto INT REFERENCES productos(id_producto), 
cantidad INT NOT NULL, 
precio_unitario DECIMAL (10,2) NOT NULL, 
fecha_venta  DATE NOT NULL 
);


INSERT INTO ventas(id_venta,id_cliente,id_producto,cantidad,precio_unitario,fecha_venta)
VALUES( 1, 1, 1, 2, 1200.00, '2024-03-05'),
  ( 2, 2, 2, 5, 28.00, '2024-03-06'),
  ( 3, 3, 3, 1, 450.00, '2024-03-07'),
  ( 4, 1, 4, 2,120.00, '2024-03-08'),
  ( 5, 4, 5, 3,130.00, '2024-03-10'),
  ( 6, 2, 6, 4, 95.00, '2024-03-11'),
  ( 7, 5, 1, 1,1200.00, '2024-03-12'),
  ( 8, 3, 2, 8,28.00, '2024-03-13'),
  ( 9, 4, 4, 1,120.00, '2024-03-14'),
  (10, 5, 3, 2,450.00, '2024-03-15');
	
	
SELECT * FROM ventas;

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