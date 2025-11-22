-- DROP SCHEMA dbo;

CREATE SCHEMA dbo;
-- DW_MARKETING.dbo.Dim_Cliente definition

-- Drop table

-- DROP TABLE DW_MARKETING.dbo.Dim_Cliente;

CREATE TABLE DW_MARKETING.dbo.Dim_Cliente (
	cliente_key int IDENTITY(1,1) NOT NULL,
	cliente_id varchar(20) COLLATE Modern_Spanish_CI_AS NULL,
	nombre varchar(75) COLLATE Modern_Spanish_CI_AS NULL,
	apellido varchar(75) COLLATE Modern_Spanish_CI_AS NULL,
	email varchar(100) COLLATE Modern_Spanish_CI_AS NULL,
	genero varchar(10) COLLATE Modern_Spanish_CI_AS NULL,
	grupo_cliente varchar(50) COLLATE Modern_Spanish_CI_AS NULL,
	estado_cliente varchar(20) COLLATE Modern_Spanish_CI_AS NULL,
	fecha_registro datetime2 NULL,
	fecha_nacimiento datetime2 NULL,
	fecha_inicio datetime2 NULL,
	fecha_fin datetime2 NULL,
	activo bit NULL,
	CONSTRAINT PK__Dim_Clie__6DAED8C54CB00A5B PRIMARY KEY (cliente_key)
);


-- DW_MARKETING.dbo.Dim_Direccion definition

-- Drop table

-- DROP TABLE DW_MARKETING.dbo.Dim_Direccion;

CREATE TABLE DW_MARKETING.dbo.Dim_Direccion (
	direccion_key int IDENTITY(1,1) NOT NULL,
	direccion_id varchar(50) COLLATE Modern_Spanish_CI_AS NULL,
	pais varchar(150) COLLATE Modern_Spanish_CI_AS NULL,
	departamento varchar(50) COLLATE Modern_Spanish_CI_AS NULL,
	municipio varchar(100) COLLATE Modern_Spanish_CI_AS NULL,
	direccion varchar(250) COLLATE Modern_Spanish_CI_AS NULL,
	codigo_postal varchar(20) COLLATE Modern_Spanish_CI_AS NULL,
	CONSTRAINT PK__Dim_Dire__8F625EC3FDC08AA2 PRIMARY KEY (direccion_key)
);


-- DW_MARKETING.dbo.Dim_Metodo_Envio definition

-- Drop table

-- DROP TABLE DW_MARKETING.dbo.Dim_Metodo_Envio;

CREATE TABLE DW_MARKETING.dbo.Dim_Metodo_Envio (
	metodo_envio_key int IDENTITY(1,1) NOT NULL,
	metodo_envio_id varchar(40) COLLATE Modern_Spanish_CI_AS NULL,
	nombre_metodo_envio varchar(100) COLLATE Modern_Spanish_CI_AS NULL,
	costo_envio decimal(10,2) NULL,
	tiempo_estimado_dias varchar(20) COLLATE Modern_Spanish_CI_AS NULL,
	activo bit NULL,
	fecha_inicio date NULL,
	fecha_fin date NULL,
	es_actual bit NULL,
	CONSTRAINT PK__Dim_Meto__D96A65437D8D319E PRIMARY KEY (metodo_envio_key)
);


-- DW_MARKETING.dbo.Dim_Metodo_Pago definition

-- Drop table

-- DROP TABLE DW_MARKETING.dbo.Dim_Metodo_Pago;

CREATE TABLE DW_MARKETING.dbo.Dim_Metodo_Pago (
	metodo_pago_key int IDENTITY(1,1) NOT NULL,
	metodo_pago_id varchar(40) COLLATE Modern_Spanish_CI_AS NULL,
	nombre_metodo_pago varchar(100) COLLATE Modern_Spanish_CI_AS NULL,
	proveedor varchar(100) COLLATE Modern_Spanish_CI_AS NULL,
	activo bit NULL,
	CONSTRAINT PK__Dim_Meto__41D707559C3A5895 PRIMARY KEY (metodo_pago_key)
);


-- DW_MARKETING.dbo.Dim_Orden definition

-- Drop table

-- DROP TABLE DW_MARKETING.dbo.Dim_Orden;

CREATE TABLE DW_MARKETING.dbo.Dim_Orden (
	order_key int IDENTITY(1,1) NOT NULL,
	order_id varchar(20) COLLATE Modern_Spanish_CI_AS NULL,
	estado_orden varchar(20) COLLATE Modern_Spanish_CI_AS NULL,
	subtotal_orden decimal(10,2) NULL,
	descuento_total decimal(10,2) NULL,
	total_orden decimal(10,2) NULL,
	cantidad_items int NULL,
	fecha_creacion date NULL,
	fecha_envio date NULL,
	fecha_entrega date NULL,
	CONSTRAINT PK__Dim_Orde__843186A0F464B303 PRIMARY KEY (order_key)
);


-- DW_MARKETING.dbo.Dim_Producto definition

-- Drop table

-- DROP TABLE DW_MARKETING.dbo.Dim_Producto;

CREATE TABLE DW_MARKETING.dbo.Dim_Producto (
	producto_key int IDENTITY(1,1) NOT NULL,
	producto_id varchar(20) COLLATE Modern_Spanish_CI_AS NULL,
	sku varchar(50) COLLATE Modern_Spanish_CI_AS NULL,
	nombre_producto varchar(150) COLLATE Modern_Spanish_CI_AS NULL,
	descripcion text COLLATE Modern_Spanish_CI_AS NULL,
	categoria varchar(100) COLLATE Modern_Spanish_CI_AS NULL,
	subcategoria varchar(100) COLLATE Modern_Spanish_CI_AS NULL,
	precio_base decimal(10,2) NULL,
	costo decimal(10,2) NULL,
	pais_origen varchar(50) COLLATE Modern_Spanish_CI_AS NULL,
	fecha_inicio date NULL,
	fecha_fin date NULL,
	activo bit NULL,
	CONSTRAINT PK__Dim_Prod__700C534BC63A2552 PRIMARY KEY (producto_key)
);


-- DW_MARKETING.dbo.Dim_Tiempo definition

-- Drop table

-- DROP TABLE DW_MARKETING.dbo.Dim_Tiempo;

CREATE TABLE DW_MARKETING.dbo.Dim_Tiempo (
	tiempo_key int NOT NULL,
	fecha date NULL,
	dia_semana int NULL,
	dia_mes int NULL,
	dia_total int NULL,
	nombre_dia varchar(9) COLLATE Modern_Spanish_CI_AS NULL,
	dia_abbrev varchar(3) COLLATE Modern_Spanish_CI_AS NULL,
	es_fin_de_semana varchar(10) COLLATE Modern_Spanish_CI_AS NULL,
	numero_semana_anio int NULL,
	numero_semana_total int NULL,
	fecha_inicio_semana date NULL,
	fecha_inicio_semana_key int NULL,
	mes int NULL,
	mes_total int NULL,
	nombre_mes varchar(10) COLLATE Modern_Spanish_CI_AS NULL,
	mes_abbrev varchar(4) COLLATE Modern_Spanish_CI_AS NULL,
	trimestre int NULL,
	anio int NULL,
	mes_anio int NULL,
	mes_fiscal int NULL,
	trimestre_fiscal int NULL,
	anio_fiscal int NULL,
	es_fin_mes varchar(11) COLLATE Modern_Spanish_CI_AS NULL,
	fecha_anio_anterior date NULL,
	CONSTRAINT PK__Dim_Tiem__BDEC4FE89B90B668 PRIMARY KEY (tiempo_key)
);


-- DW_MARKETING.dbo.Dim_Tipo_Campania definition

-- Drop table

-- DROP TABLE DW_MARKETING.dbo.Dim_Tipo_Campania;

CREATE TABLE DW_MARKETING.dbo.Dim_Tipo_Campania (
	tipo_campania_key int IDENTITY(1,1) NOT NULL,
	tipo_campania_id varchar(20) COLLATE Modern_Spanish_CI_AS NULL,
	descripcion_tipo varchar(100) COLLATE Modern_Spanish_CI_AS NULL,
	valor_descuento_promedio decimal(10,2) NULL,
	veces_utilizado int NULL,
	CONSTRAINT PK__Dim_Tipo__C18C7DBB157D7A3B PRIMARY KEY (tipo_campania_key)
);


-- DW_MARKETING.dbo.sysdiagrams definition

-- Drop table

-- DROP TABLE DW_MARKETING.dbo.sysdiagrams;

CREATE TABLE DW_MARKETING.dbo.sysdiagrams (
	name sysname COLLATE Modern_Spanish_CI_AS NOT NULL,
	principal_id int NOT NULL,
	diagram_id int IDENTITY(1,1) NOT NULL,
	version int NULL,
	definition varbinary(MAX) NULL,
	CONSTRAINT PK__sysdiagr__C2B05B61BAA9F551 PRIMARY KEY (diagram_id),
	CONSTRAINT UK_principal_name UNIQUE (principal_id,name)
);


-- DW_MARKETING.dbo.Dim_Campania definition

-- Drop table

-- DROP TABLE DW_MARKETING.dbo.Dim_Campania;

CREATE TABLE DW_MARKETING.dbo.Dim_Campania (
	campania_key int IDENTITY(1,1) NOT NULL,
	campania_id varchar(20) COLLATE Modern_Spanish_CI_AS NULL,
	nombre_campania varchar(150) COLLATE Modern_Spanish_CI_AS NULL,
	descripcion_campania varchar(150) COLLATE Modern_Spanish_CI_AS NULL,
	tipo_campania int NULL,
	cupon_descuento varchar(50) COLLATE Modern_Spanish_CI_AS NULL,
	monto_descuento decimal(10,2) NULL,
	fecha_inicio_campania date NULL,
	fecha_fin_campania date NULL,
	estado_campania varchar(20) COLLATE Modern_Spanish_CI_AS NULL,
	canal_campania varchar(10) COLLATE Modern_Spanish_CI_AS NULL,
	fecha_inicio date NULL,
	fecha_fin date NULL,
	activo bit NULL,
	presupuesto decimal(18,2) NULL,
	CONSTRAINT PK__Dim_Camp__07D8C7D6EE38F775 PRIMARY KEY (campania_key),
	CONSTRAINT FK_Dim_Campania_Dim_TipoCampania FOREIGN KEY (tipo_campania) REFERENCES DW_MARKETING.dbo.Dim_Tipo_Campania(tipo_campania_key)
);


-- DW_MARKETING.dbo.Fact_Campania definition

-- Drop table

-- DROP TABLE DW_MARKETING.dbo.Fact_Campania;

CREATE TABLE DW_MARKETING.dbo.Fact_Campania (
	campania_fact_key int IDENTITY(1,1) NOT NULL,
	campania_key int NULL,
	fecha_inicio_key int NULL,
	fecha_fin_key int NULL,
	correos_enviados int NULL,
	correos_abiertos int NULL,
	clics_enlaces int NULL,
	cupones_usados int NULL,
	ventas_generadas int NULL,
	ingresos_generados decimal(10,2) NULL,
	monto_descuentos decimal(10,2) NULL,
	nuevos_clientes_generados int NULL,
	roi decimal(10,4) NULL,
	roas decimal(10,4) NULL,
	aov decimal(10,2) NULL,
	uso_cupones decimal(10,4) NULL,
	costo_por_nuevo_cliente decimal(10,4) NULL,
	CONSTRAINT PK__Fact_Cam__0A7DCE7BC505B9E2 PRIMARY KEY (campania_fact_key),
	CONSTRAINT FK_Campania_Campania FOREIGN KEY (campania_key) REFERENCES DW_MARKETING.dbo.Dim_Campania(campania_key),
	CONSTRAINT FK_Campania_Tiempo FOREIGN KEY (fecha_inicio_key) REFERENCES DW_MARKETING.dbo.Dim_Tiempo(tiempo_key)
);


-- DW_MARKETING.dbo.Fact_CuponUso definition

-- Drop table

-- DROP TABLE DW_MARKETING.dbo.Fact_CuponUso;

CREATE TABLE DW_MARKETING.dbo.Fact_CuponUso (
	cupon_uso_key int IDENTITY(1,1) NOT NULL,
	order_key int NOT NULL,
	campania_key int NULL,
	cliente_key int NULL,
	producto_key int NULL,
	fecha_key int NULL,
	order_item_id int NOT NULL,
	coupon_code varchar(100) COLLATE Modern_Spanish_CI_AS NULL,
	cantidad int NULL,
	precio_original decimal(10,2) NULL,
	descuento_aplicado decimal(10,2) NULL,
	precio_final AS ([precio_original]-[descuento_aplicado]) PERSISTED,
	subtotal_linea decimal(10,2) NULL,
	total_linea decimal(10,2) NULL,
	es_primera_compra bit NULL,
	es_recurrente AS (case when [es_primera_compra]=(1) then (0) else (1) end) PERSISTED NOT NULL,
	estado_orden varchar(50) COLLATE Modern_Spanish_CI_AS NULL,
	CONSTRAINT PK__Fact_Cup__C2C5BAAD69A4ABEC PRIMARY KEY (cupon_uso_key),
	CONSTRAINT FK__Fact_Cupo__campa__0880433F FOREIGN KEY (campania_key) REFERENCES DW_MARKETING.dbo.Dim_Campania(campania_key),
	CONSTRAINT FK__Fact_Cupo__clien__09746778 FOREIGN KEY (cliente_key) REFERENCES DW_MARKETING.dbo.Dim_Cliente(cliente_key),
	CONSTRAINT FK__Fact_Cupo__fecha__0B5CAFEA FOREIGN KEY (fecha_key) REFERENCES DW_MARKETING.dbo.Dim_Tiempo(tiempo_key),
	CONSTRAINT FK__Fact_Cupo__order__078C1F06 FOREIGN KEY (order_key) REFERENCES DW_MARKETING.dbo.Dim_Orden(order_key),
	CONSTRAINT FK__Fact_Cupo__produ__0A688BB1 FOREIGN KEY (producto_key) REFERENCES DW_MARKETING.dbo.Dim_Producto(producto_key)
);


-- DW_MARKETING.dbo.Fact_Ventas definition

-- Drop table

-- DROP TABLE DW_MARKETING.dbo.Fact_Ventas;

CREATE TABLE DW_MARKETING.dbo.Fact_Ventas (
	venta_key int IDENTITY(1,1) NOT NULL,
	cliente_key int NULL,
	producto_key int NULL,
	campania_key int NULL,
	fecha_registro int NULL,
	order_key int NULL,
	direccion_key int NULL,
	metodo_pago_key int NULL,
	metodo_envio_key int NULL,
	cantidad_vendida int NULL,
	precio_unitario decimal(10,2) NULL,
	subtotal decimal(10,2) NULL,
	descuento decimal(10,2) NULL,
	total decimal(10,2) NULL,
	CONSTRAINT PK__Fact_Ven__4A878FE3A420E1F6 PRIMARY KEY (venta_key),
	CONSTRAINT FK_Ventas_Campania FOREIGN KEY (campania_key) REFERENCES DW_MARKETING.dbo.Dim_Campania(campania_key),
	CONSTRAINT FK_Ventas_Cliente FOREIGN KEY (cliente_key) REFERENCES DW_MARKETING.dbo.Dim_Cliente(cliente_key),
	CONSTRAINT FK_Ventas_Direccion FOREIGN KEY (direccion_key) REFERENCES DW_MARKETING.dbo.Dim_Direccion(direccion_key),
	CONSTRAINT FK_Ventas_Metodo_Envio FOREIGN KEY (metodo_envio_key) REFERENCES DW_MARKETING.dbo.Dim_Metodo_Envio(metodo_envio_key),
	CONSTRAINT FK_Ventas_Metodo_Pago FOREIGN KEY (metodo_pago_key) REFERENCES DW_MARKETING.dbo.Dim_Metodo_Pago(metodo_pago_key),
	CONSTRAINT FK_Ventas_Orden FOREIGN KEY (order_key) REFERENCES DW_MARKETING.dbo.Dim_Orden(order_key),
	CONSTRAINT FK_Ventas_Producto FOREIGN KEY (producto_key) REFERENCES DW_MARKETING.dbo.Dim_Producto(producto_key),
	CONSTRAINT FK_Ventas_Tiempo FOREIGN KEY (fecha_registro) REFERENCES DW_MARKETING.dbo.Dim_Tiempo(tiempo_key)
);


