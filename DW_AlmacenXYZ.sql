/*
CREACIÓN DATA WAREHOUSE - EFECTIVIDAD DE CAMPAÑAS DE MARKETING ALMACEN XYZ
VENTAS ONLINE
FUENTES: MAGENTO COMMERCE, CRMLAB
*/

-- 0. LIMPIAR ENTORNO
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'DW_MARKETING')
BEGIN
    DROP DATABASE DW_MARKETING;
END

-- 1. CREAR BASE DE DATOS PARA DATA WAREHOUSE
CREATE DATABASE DW_MARKETING;
GO

-- Usar la base creada para crear objetos
USE DW_MARKETING;
GO

-- 2. CREAR DIMENSIONES
CREATE TABLE Dim_Tiempo(
    tiempo_key INT PRIMARY KEY,
    fecha DATE,
    anio INT,
    mes INT,
    dia INT,
    trimestre INT,
    dia_semana VARCHAR(10),
    nombre_mes VARCHAR(15),
    es_fin_de_semana BIT
    );
GO

CREATE TABLE Dim_Cliente(
    cliente_key INT IDENTITY(1,1) PRIMARY KEY,
    cliente_id VARCHAR(20),
    nombre VARCHAR(75),
    apellido VARCHAR(75),
    email VARCHAR(100),
    genero VARCHAR(10),
    estado_cliente VARCHAR(20),
    fecha_registro DATE,
    fecha_nacimiento DATE,
    fecha_inicio DATE,
    fecha_fin DATE,
    activo BIT
);
GO

CREATE TABLE Dim_Producto(
    producto_key INT IDENTITY(1,1) PRIMARY KEY,
    producto_id VARCHAR(20),
    sku VARCHAR(50),
    nombre_producto VARCHAR(150),
    descripcion VARCHAR(MAX),
    categoria VARCHAR(100),
    precio_base DECIMAL(10,2),
    pais_origen VARCHAR(2),
    fecha_inicio DATE,
    fecha_fin DATE,
    activo BIT
);
GO

CREATE TABLE Dim_Campania(
    campania_key INT IDENTITY(1,1) PRIMARY KEY,
    campania_id VARCHAR(20),
    nombre_campania VARCHAR(150),
    tipo_campania INT,
    cupon_descuento VARCHAR(50),
    fecha_inicio_validez DATE,
    fecha_fin_validez DATE,
    descuento_promedio DECIMAL(10,2),
    estado_campania VARCHAR(20),
    fecha_inicio DATE,
    fecha_fin DATE,
    activo BIT
);
GO

CREATE TABLE Dim_Metodo_Pago(
    metodo_pago_key INT IDENTITY(1,1) PRIMARY KEY,
    metodo_pago_id VARCHAR(20),
    nombre_metodo_pago VARCHAR(100),
    proveedor VARCHAR(100),
    activo BIT
);
GO

CREATE TABLE Dim_Metodo_Envio(
    metodo_envio_key INT IDENTITY(1,1) PRIMARY KEY,
    metodo_envio_id VARCHAR(20),
    nombre_metodo_envio VARCHAR(100),
    costo_envio DECIMAL(10,2),
    tiempo_estimado_dias INT,
    activo BIT
);
GO

CREATE TABLE Dim_Direccion(
    direccion_key INT IDENTITY(1,1) PRIMARY KEY,
    pais VARCHAR(2),
    departamento VARCHAR(50),
    municipio VARCHAR(100),
    direccion VARCHAR(250),
    codigo_postal VARCHAR(20)
);
GO

CREATE TABLE Dim_Orden(
    order_key INT IDENTITY(1,1) PRIMARY KEY,
    order_id VARCHAR(20),
    estado_orden VARCHAR(20),
    total_orden DECIMAL(10,2),
    descuento_total DECIMAL(10,2),
    cantidad_items INT,
    fecha_creacion DATE,
    fecha_envio DATE,
    fecha_entrega DATE
);
GO

CREATE TABLE Dim_Tipo_Campania(
    tipo_campania_key INT IDENTITY(1,1) PRIMARY KEY,
    tipo_campania_id VARCHAR(20),
    descripcion_tipo VARCHAR(100),
    valor_descuento_promedio DECIMAL(10,2),
    activo BIT
);
GO

--3. CREAR TABLA DE HECHOS

CREATE TABLE Fact_Ventas(
    venta_key INT IDENTITY(1,1) PRIMARY KEY,
    cliente_key INT,
    producto_key INT,
    campania_key INT,
    fecha_compra INT,
    fecha_envio INT,
    fecha_entrega INT,
    order_key INT,
    direccion_key INT,
    metodo_pago_key INT,
    metodo_envio_key INT,
    cantidad_vendida INT,
    precio_unitario DECIMAL(10,2),
    subtotal DECIMAL(10,2),
    descuento DECIMAL(10,2),
    total DECIMAL(10,2),
    CONSTRAINT FK_Ventas_Cliente FOREIGN KEY (cliente_key) REFERENCES Dim_Cliente(cliente_key),
    CONSTRAINT FK_Ventas_Producto FOREIGN KEY (producto_key) REFERENCES Dim_Producto(producto_key),
    CONSTRAINT FK_Ventas_Campania FOREIGN KEY (campania_key) REFERENCES Dim_Campania(campania_key),
    CONSTRAINT FK_Ventas_Tiempo FOREIGN KEY (fecha_compra) REFERENCES Dim_Tiempo(tiempo_key),
    CONSTRAINT FK_Ventas_Tiempo_Envio FOREIGN KEY (fecha_envio) REFERENCES Dim_Tiempo(tiempo_key),
    CONSTRAINT FK_Ventas_Tiempo_Entrega FOREIGN KEY (fecha_entrega) REFERENCES Dim_Tiempo(tiempo_key),
    CONSTRAINT FK_Ventas_Orden FOREIGN KEY (order_key) REFERENCES Dim_Orden(order_key),
    CONSTRAINT FK_Ventas_Direccion FOREIGN KEY (direccion_key) REFERENCES Dim_Direccion(direccion_key),
    CONSTRAINT FK_Ventas_Metodo_Pago FOREIGN KEY (metodo_pago_key) REFERENCES Dim_Metodo_Pago(metodo_pago_key),
    CONSTRAINT FK_Ventas_Metodo_Envio FOREIGN KEY (metodo_envio_key) REFERENCES Dim_Metodo_Envio(metodo_envio_key)
);

GO

CREATE TABLE Fact_Campania(
    campania_fact_key INT IDENTITY(1,1) PRIMARY KEY,
    campania_key INT,
    tiempo_key INT,
    correos_enviados INT,
    correos_abiertos INT,
    clics_enlaces INT,
    cupones_usados INT,
    ventas_generadas INT,
    ingresos_generados DECIMAL(10,2),
    monto_descuentos DECIMAL(10,2),
    CONSTRAINT FK_Campania_Campania FOREIGN KEY (campania_key) REFERENCES Dim_Campania(campania_key),
    CONSTRAINT FK_Campania_Tiempo FOREIGN KEY (tiempo_key) REFERENCES Dim_Tiempo(tiempo_key)
);
GO

CREATE TABLE Fact_Interaccion_Cliente(
    interaccion_key INT IDENTITY(1,1) PRIMARY KEY,
    cliente_key INT,
    campania_key INT,
    tiempo_key INT,
    productos_vistos INT,
    wishlist_agregados INT,
    llamadas_soportadas INT,
    clics_enlaces INT,
    estado_suscripcion_newsletter BIT,
    CONSTRAINT FK_Interaccion_Cliente_Cliente FOREIGN KEY (cliente_key) REFERENCES Dim_Cliente(cliente_key),
    CONSTRAINT FK_Interaccion_Cliente_Campania FOREIGN KEY (campania_key) REFERENCES Dim_Campania(campania_key),
    CONSTRAINT FK_Interaccion_Cliente_Tiempo FOREIGN KEY (tiempo_key) REFERENCES Dim_Tiempo(tiempo_key)
);
GO

CREATE TABLE Fact_CuponUso (
    cupon_uso_key INT IDENTITY(1,1) PRIMARY KEY,
    order_key INT NOT NULL,
    campania_key INT,
    cliente_key INT,
    producto_key INT,
    fecha_key INT,
	order_item_id INT NOT NULL,
    coupon_code VARCHAR(100),
    cantidad INT,
    precio_original DECIMAL(10,2),
    descuento_aplicado DECIMAL(10,2),
    precio_final AS (precio_original - descuento_aplicado) PERSISTED,
    subtotal_linea DECIMAL(10,2),
    total_linea DECIMAL(10,2),
    es_primera_compra BIT,
    es_recurrente AS (CASE WHEN es_primera_compra = 1 THEN 0 ELSE 1 END) PERSISTED,
    estado_orden VARCHAR(50),
	FOREIGN KEY (order_key) REFERENCES Dim_Orden(order_key),
    FOREIGN KEY (campania_key) REFERENCES Dim_Campania(campania_key),
    FOREIGN KEY (cliente_key) REFERENCES Dim_Cliente(cliente_key),
    FOREIGN KEY (producto_key) REFERENCES Dim_Producto(producto_key),
    FOREIGN KEY (fecha_key) REFERENCES Dim_Tiempo(tiempo_key)
);
GO

--Llenar registros Nulos en Dimensiones
--DimTipoCampania
DBCC CHECKIDENT('Dim_Tipo_Campania', RESEED, 0);
SET IDENTITY_INSERT Dim_Tipo_Campania ON;
INSERT INTO Dim_Tipo_Campania (tipo_campania_key, tipo_campania_id,descripcion_tipo,valor_descuento_promedio,veces_utilizado) VALUES(0,'Sin Campaña','No Aplica',0,0);
SET IDENTITY_INSERT Dim_Tipo_Campania OFF;

--DimCampania
DBCC CHECKIDENT('Dim_Campania', RESEED, 0);
SET IDENTITY_INSERT Dim_Campania ON;
INSERT INTO Dim_Campania (campania_key, campania_id, nombre_campania, descripcion_campania, tipo_campania, cupon_descuento, monto_descuento, fecha_inicio_campania, fecha_fin_campania, estado_campania, canal_campania, fecha_inicio, fecha_fin, activo) VALUES (0,'Sin Campaña','No Aplica','No Aplica',0,NULL,0,NULL,NULL,'Inactiva','Ninguno',NULL,NULL,0);
SET IDENTITY_INSERT Dim_Campania OFF;

--DimCliente
DBCC CHECKIDENT('Dim_Cliente', RESEED, 0);
SET IDENTITY_INSERT Dim_Cliente ON;
INSERT INTO Dim_Cliente (cliente_key, cliente_id, nombre, apellido, email, genero, grupo_cliente, estado_cliente, fecha_registro, fecha_nacimiento, fecha_inicio, fecha_fin, activo) VALUES (0,'Sin Cliente','No Aplica','No Aplica','No Aplica','No Aplica','No Aplica','Inactivo',NULL,NULL,NULL,NULL,0);
SET IDENTITY_INSERT Dim_Cliente OFF;

--DimDireccion
DBCC CHECKIDENT('Dim_Direccion', RESEED, 0);
SET IDENTITY_INSERT Dim_Direccion ON;
INSERT INTO Dim_Direccion (direccion_key, direccion_id, pais, departamento, municipio, direccion, codigo_postal, fecha_inicio, fecha_fin, activo) VALUES (0,'Sin Dirección',NULL,'No Aplica','No Aplica','No Aplica','No Aplica',NULL,NULL,0);
SET IDENTITY_INSERT Dim_Direccion OFF;

--DimMetodoEnvio
DBCC CHECKIDENT('Dim_Metodo_Envio', RESEED, 0);
SET IDENTITY_INSERT Dim_Metodo_Envio ON;
INSERT INTO Dim_Metodo_Envio (metodo_envio_key, metodo_envio_id, nombre_metodo_envio, costo_envio, tiempo_estimado_dias, activo) VALUES (0,'Sin Método de Envío','No Aplica',0,0,0);
SET IDENTITY_INSERT Dim_Metodo_Envio OFF;

--DimMetodoPago
DBCC CHECKIDENT('Dim_Metodo_Pago', RESEED, 0);
SET IDENTITY_INSERT Dim_Metodo_Pago ON;
INSERT INTO Dim_Metodo_Pago (metodo_pago_key, metodo_pago_id, nombre_metodo_pago, proveedor, activo) VALUES (0,'Sin Método de Pago','No Aplica','No Aplica',0);
SET IDENTITY_INSERT Dim_Metodo_Pago OFF;

--DimOrden
DBCC CHECKIDENT('Dim_Orden', RESEED, 0);
SET IDENTITY_INSERT Dim_Orden ON;
INSERT INTO Dim_Orden (order_key, order_id, estado_orden, subtotal_orden, descuento_total, total_orden, cantidad_items, fecha_creacion, fecha_envio, fecha_entrega) VALUES (0,'0','Inactiva',0,0,0,0,NULL,NULL,NULL);
SET IDENTITY_INSERT Dim_Orden OFF;

--DimProducto
DBCC CHECKIDENT('Dim_Producto', RESEED, 0);
SET IDENTITY_INSERT Dim_Producto ON;
INSERT INTO Dim_Producto (producto_key, producto_id, sku, nombre_producto, descripcion, categoria, subcategoria, precio_base, pais_origen, fecha_inicio, fecha_fin, activo) VALUES (0,'Sin Producto','No Aplica','No Aplica','No Aplica','No Aplica','No Aplica',0,'No Aplica',NULL,NULL,0);
SET IDENTITY_INSERT Dim_Producto OFF;