--Dimensiones
--Consulta DimCliente
SELECT entity_id AS cliente_id, 
CONCAT(IFNULL(firstname, ''), ' ', IFNULL(middlename, '')) AS nombre,
lastname AS apellido,
email,
CASE WHEN gender = 1 THEN 'Masculino'
    WHEN gender = 2 THEN 'Femenino'
    ELSE 'No especificado' END AS genero,
    CASE WHEN group_id = 1 THEN 'General'
    WHEN group_id = 2 THEN 'Mayorista'
    WHEN group_id = 3 THEN 'Distribuidor'
    ELSE 'Otro' END AS grupo_cliente,
CASE WHEN is_active = 1 THEN 'Activo'
    ELSE 'Inactivo' END AS estado_cliente,
created_at AS fecha_registro,
dob AS fecha_nacimiento,
NOW() AS fecha_inicio,
NULL as fecha_fin,
1 as activo
FROM customer_entity a; 

--Consulta DimProducto
SELECT 
    producto.entity_id AS producto_id,
    producto.sku,
    nombre_producto.value AS nombre_producto,
    REPLACE(REPLACE(descripcion_producto.value,'<p>', ''), '</p>', '') AS descripcion,
    nombre_subcategoria.value AS categoria,
    nombre_categoria.value AS subcategoria,
    precio_producto.price AS precio_base,
    costo.value AS costo,
    pais_origen.value AS pais_origen,
    NOW() AS fecha_inicio,
    NULL AS fecha_fin,
    1 AS activo
FROM catalog_product_entity producto
INNER JOIN catalog_product_entity_varchar nombre_producto
    ON producto.entity_id = nombre_producto.entity_id AND nombre_producto.attribute_id = 73
INNER JOIN catalog_product_entity_text descripcion_producto
    ON producto.entity_id = descripcion_producto.entity_id AND descripcion_producto.attribute_id = 76
INNER JOIN catalog_category_product categoria_producto
    ON producto.entity_id = categoria_producto.product_id
INNER JOIN catalog_category_entity categoria
    ON categoria_producto.category_id = categoria.entity_id AND categoria.children_count = 0
INNER JOIN catalog_category_entity_varchar nombre_categoria
    ON categoria.entity_id = nombre_categoria.entity_id AND nombre_categoria.attribute_id = 45
LEFT JOIN (
    SELECT 
        ccp.product_id,
        MIN(cc.parent_id) AS subcategoria_id
    FROM catalog_category_product ccp
    INNER JOIN catalog_category_entity cc ON ccp.category_id = cc.entity_id
    WHERE cc.children_count = 0
    GROUP BY ccp.product_id
) subcat ON producto.entity_id = subcat.product_id
LEFT JOIN catalog_category_entity subcategoria
    ON subcat.subcategoria_id = subcategoria.entity_id
LEFT JOIN catalog_category_entity_varchar nombre_subcategoria
    ON subcategoria.entity_id = nombre_subcategoria.entity_id AND nombre_subcategoria.attribute_id = 45
INNER JOIN catalog_product_index_price precio_producto
    ON producto.entity_id = precio_producto.entity_id
INNER JOIN catalog_product_entity_varchar pais_origen
    ON producto.entity_id = pais_origen.entity_id AND pais_origen.attribute_id = 114
LEFT JOIN catalog_product_entity_decimal costo
    ON costo.entity_id = producto.entity_id AND costo.attribute_id = 81
GROUP BY 
    producto.entity_id, 
    producto.sku,
    nombre_producto.value,
    descripcion_producto.value,
    nombre_categoria.value,
    nombre_subcategoria.value,
    precio_producto.price,
    pais_origen.value,
    costo.value;

--Consulta DimCampania
SELECT 
    campania.rule_id AS campania_id,
    campania.name AS nombre_campania,
    campania.description AS descripcion_campania,
    campania.simple_action AS tipo_campania,
    cupon.code AS cupon_descuento,
    campania.discount_amount AS monto_descuento,
    campania.from_date AS fecha_inicio_campania,
    campania.to_date AS fecha_fin_campania,
    campania.is_active AS estado,
    NOW() AS fecha_inicio,
    NULL AS fecha_fin,
    1 AS activo
FROM salesrule campania
INNER JOIN salesrule_coupon cupon
    ON campania.rule_id = cupon.rule_id;

--DimMetodoPago
SELECT 
    DISTINCT method AS metodo_pago_id,
    CASE WHEN method = 'checkmo' THEN 'Efectivo contra entrega'
        WHEN method = 'cashondelivery' THEN 'Cheque contra entrega'
        WHEN method = 'creditcard' THEN 'Tarjeta de crédito'
        WHEN method = 'paypal_express' THEN 'PayPal'
        WHEN method = 'banktransfer' THEN 'Transferencia bancaria'
        ELSE 'Otro' END AS nombre_metodo_pago,
    CASE WHEN method = 'checkmo' THEN 'Sin Proveedor'
        WHEN method = 'cashondelivery' THEN 'Sin Proveedor'
        WHEN method = 'creditcard' THEN 'Proveedor Tarjeta de Crédito'
        WHEN method = 'paypal_express' THEN 'PayPal'
        WHEN method = 'banktransfer' THEN 'Banco Central de Reserva (Tranfer365)'
        ELSE 'Otro' END AS proveedor,
    1 AS activo
FROM sales_order_payment;

--DimMetodoEnvio
SELECT 
    DISTINCT shipping_method AS metodo_envio_id,
    CASE WHEN shipping_method LIKE 'flatrate%' THEN 'Tarifa Plana'
        WHEN shipping_method LIKE 'freeshipping%' THEN 'Envío Gratis'
        WHEN shipping_method LIKE 'tablerate%' THEN 'Tarifa por Tabla'
        ELSE 'Otro' END AS nombre_metodo_envio,
    AVG(shipping_amount) AS costo_promedio_envio,
    CASE WHEN shipping_method LIKE 'flatrate%' THEN '3-5 días hábiles'
        WHEN shipping_method LIKE 'freeshipping%' THEN '5-7 días hábiles'
        WHEN shipping_method LIKE 'tablerate%' THEN '4-6 días hábiles'
        ELSE 'Otro' END AS tiempo_estimado_entrega,
    1 AS activo
FROM sales_order GROUP BY shipping_method;

--DimDireccion
SELECT
    entity_id AS direccion_id,
    country_id AS pais,
    region AS departamento,
    city AS municipio,
    street AS direccion,
    postcode AS codigo_postal
FROM customer_address_entity;

--DimOrden
SELECT
    a.entity_id AS order_id,
    CASE WHEN
    a.status = 'pending' THEN 'Creada'
    WHEN a.status = 'processing' THEN 'Enviada'
    WHEN a.status = 'complete' THEN 'Entregada'
    WHEN a.status = 'canceled' THEN 'Cancelada'
    ELSE 'Otro' END AS estado_orden,
    a.grand_total-a.discount_amount AS subtotal,
    a.discount_amount*-1 AS descuento_total,
    a.grand_total AS total_orden,
    a.total_qty_ordered AS cantidad_items,
    b.created_at AS fecha_creacion,
    c.created_at AS fecha_envio,
    d.created_at AS fecha_entrega
FROM sales_order a 
LEFT JOIN sales_order_status_change_history b
    ON a.entity_id = b.order_id AND b.status = 'pending'
LEFT JOIN sales_order_status_change_history c
    ON a.entity_id = c.order_id AND c.status = 'processing'
LEFT JOIN sales_order_status_change_history d
    ON a.entity_id = d.order_id AND d.status = 'complete';



--DimTipoCampania
SELECT
    DISTINCT simple_action AS tipo_campania_id,
    CASE WHEN simple_action = 'by_percent' THEN 'Descuento por porcentaje'
        WHEN simple_action = 'by_fixed' THEN 'Descuento fijo'
        WHEN simple_action = 'cart_fixed' THEN 'Descuento fijo por carrito'
        WHEN simple_action = 'buy_x_get_y' THEN 'Compra X y lleva Y'
        ELSE 'Otro' END AS descripcion_tipo_campania,
    AVG(discount_amount) AS valor_descuento_promedio,
    SUM(times_used) AS total_veces_utilizado
FROM salesrule GROUP BY simple_action;

--FactVentas
SELECT
    b.customer_id AS cliente_id,
    a.product_id AS producto_id,
    CASE WHEN
        c.rule_id IS NULL THEN 0
        ELSE c.rule_id END AS campania_id,
    b.created_at AS fecha_registro,
    a.order_id AS orden_id,
    e.customer_address_id AS direccion_id,
    d.method AS metodo_pago_id,
    b.shipping_method AS metodo_envio_id,
    a.qty_ordered AS cantidad_vendida,
    a.price AS precio_unitario,
    a.row_total AS subtotal_producto,
    a.discount_amount AS descuento_producto,
    a.row_total - a.discount_amount AS total_producto
FROM sales_order_item a
INNER JOIN sales_order b
    ON a.order_id = b.entity_id
LEFT JOIN salesrule c
    ON a.applied_rule_ids = c.rule_id
INNER JOIN sales_order_payment d
    ON b.entity_id = d.parent_id
INNER JOIN sales_order_address e
    ON b.shipping_address_id = e.entity_id;



--Tablas de Hechos
--FactCampania
WITH ventas_campania AS (
    SELECT
        so.entity_id AS order_id,
        so.customer_id,
        so.coupon_code,
        so.created_at,
        soi.row_total - soi.discount_amount AS total_linea,
        soi.discount_amount AS descuento_linea
    FROM sales_order so
    LEFT JOIN sales_order_item soi
        ON so.entity_id = soi.order_id
    WHERE so.coupon_code IS NOT NULL
),
primera_compra AS (
    SELECT
        customer_id,
        MIN(created_at) AS primera_compra_fecha
    FROM sales_order
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
),
ventas_con_primera_flag AS (
    SELECT
        v.*,
        CASE 
            WHEN v.created_at = p.primera_compra_fecha THEN 1
            ELSE 0
        END AS es_primera_compra
    FROM ventas_campania v
    LEFT JOIN primera_compra p
        ON v.customer_id = p.customer_id
)

SELECT
    r.rule_id AS campania_id,
    r.from_date AS fecha_inicio_campania,
    r.to_date AS fecha_fin_campania,
    c.code,
    COUNT(DISTINCT v.order_id) AS cupones_usados,
    COUNT(DISTINCT v.order_id) AS ventas_generadas,
    COALESCE(SUM(v.total_linea), 0) AS ingresos_generados,
    COALESCE(SUM(v.descuento_linea), 0) AS monto_descuentos,
    CASE WHEN COUNT(DISTINCT v.order_id) = 0 
        THEN 0
        ELSE COALESCE(SUM(v.total_linea), 0) 
            / COUNT(DISTINCT v.order_id)
    END AS aov,
    COUNT(DISTINCT CASE WHEN v.es_primera_compra = 1 THEN v.customer_id END) 
        AS nuevos_clientes_generados
FROM salesrule r
LEFT JOIN salesrule_coupon c
    ON r.rule_id = c.rule_id
LEFT JOIN ventas_con_primera_flag v
    ON c.code = v.coupon_code
GROUP BY
    r.rule_id,
    r.from_date,
    r.to_date
ORDER BY r.rule_id;

--FactInteraccionCliente
SELECT
    a.entity_id AS cliente_id,
    b.updated_at AS fecha_wishlist_actualizacion,
    COUNT(c.wishlist_item_id) AS cantidad_items_wishlist
FROM customer_entity a
LEFT JOIN wishlist b
    ON a.entity_id = b.customer_id
LEFT JOIN wishlist_item c
    ON b.wishlist_id = c.wishlist_id
GROUP BY a.entity_id, b.wishlist_id, b.updated_at;
