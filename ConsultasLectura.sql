--Lectura DimCliente
SELECT 
    a.entity_id AS ClienteID,
    a.email AS Email,
    a.firstname AS Nombre,
    a.lastname AS Apellido,
    CASE
    WHEN a.gender = 1 THEN "Masculino"
    WHEN a.gender = 2 THEN "Femenino"
    ELSE "No Especifica"
    END
    AS Genero,
    a.dob AS FechaNacimiento,
    b.telephone AS Telefono,
    b.street AS Direccion,
    b.city AS Ciudad,
    b.region AS Region,
    b.country_id AS Pais,
    'Magento' AS FuenteCliente,
    CASE 
    WHEN c.customer_group_id = 0  THEN "No Logeado"
    WHEN c.customer_group_id = 1  THEN "General"
    WHEN c.customer_group_id = 2  THEN "Wholesale"
    WHEN c.customer_group_id = 3  THEN "Retailer"
    ELSE  "Otro"
    END AS GrupoCliente,
    a.created_at AS FechaRegistro
FROM customer_entity a
INNER JOIN customer_address_entity b 
    ON a.entity_id = b.parent_id
INNER JOIN customer_group c 
    ON a.group_id = c.customer_group_id;
