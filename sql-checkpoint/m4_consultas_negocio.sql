USE Ventas_Tech_DB;
Select * from ventas

SELECT 
   MONTH (fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH (fecha_venta)
ORDER BY mes;

SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_generado
FROM ventas
GROUP BY id_producto
ORDER BY total_generado DESC;

SELECT 
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC;

SELECT 
    mes,
    total_facturado,
    CASE 
        WHEN total_facturado > (
            SELECT AVG(total_mensual) 
            FROM (SELECT SUM(cantidad * precio_unitario) AS total_mensual FROM ventas GROUP BY MONTH(fecha_venta)) AS PromedioGeneral
        ) THEN 'Por encima'
        WHEN total_facturado < (
            SELECT AVG(total_mensual) 
            FROM (SELECT SUM(cantidad * precio_unitario) AS total_mensual FROM ventas GROUP BY MONTH(fecha_venta)) AS PromedioGeneral
        ) THEN 'Por debajo'
        ELSE 'En el promedio'
    END AS rendimiento_mensual
FROM (
    SELECT 
        MONTH(fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY MONTH(fecha_venta)
) AS TotalesMensuales
ORDER BY mes;


----
El producto 1 concentra más del 50% de la facturación mensual, las ventas dependen mucho de este item. 
Los clientes 1 y 5 concentran la mayor parte de las ventas, con la misma cantidad de pedidos que el resto de los clientes recurrentes, estos dos clientes concentran mas del 70% de la facturación.
Las cantidades vendidas por producto no se traducen estrictamente a mayor ganancia, el producto 2 es el que más se vendió en cantidad, pero es el que menor valor deja generado. 