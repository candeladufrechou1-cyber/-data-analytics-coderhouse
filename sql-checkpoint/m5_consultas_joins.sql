USE Ventas_Tech_DB

-- Consulta 1 — Vista base del proyecto (INNER JOIN)
SELECT 
    v.fecha_venta,
    c.id_cliente,
    c.nombre AS nombre_cliente,
    c.ciudad AS region,
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    v.cantidad,
    v.precio_unitario,
    (v.cantidad * v.precio_unitario) AS total_venta
FROM ventas v
INNER JOIN clientes c ON v.id_cliente = c.id_cliente
INNER JOIN productos p ON v.id_producto = p.id_producto
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria;


-- Consulta 2 — Clientes sin ventas (LEFT JOIN) 

SELECT 
    c.nombre AS nombre_cliente,
    c.email,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;


-- Consulta 3 — Productos sin ventas (LEFT JOIN) 
SELECT 
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    p.precio
FROM productos p
LEFT JOIN categorias cat ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas v ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL;

-- Consulta 4 — Consolidado por canal (UNION ALL)
-- Se crea el canal Online para los productos 1,2 y 3 (en este escenario son productos que solamente se pueden comprar por la web) y el canal Presencial para los productos 4,5 y6

SELECT 
    canal,
    SUM(total_venta) AS total_facturado
FROM (
  
    SELECT 
        fecha_venta,
        (cantidad * precio_unitario) AS total_venta,
        'Online' AS canal
    FROM ventas
    WHERE id_producto IN (1, 2, 3)
    
    UNION ALL
    
    SELECT 
        fecha_venta,
        (cantidad * precio_unitario) AS total_venta,
        'Presencial' AS canal
    FROM ventas
    WHERE id_producto IN (4, 5, 6)
) AS ventas_consolidadas
GROUP BY canal;
