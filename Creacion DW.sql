-- Dimensión Cliente (Magento + CRMLab)
CREATE TABLE DimCliente (
    ClienteID INT PRIMARY KEY,
    Email VARCHAR(150),
    Nombre VARCHAR(150),
    Apellido VARCHAR(150),
    Genero VARCHAR(20),
    FechaNacimiento DATE,
    Telefono VARCHAR(50),
    Direccion VARCHAR(255),
    Ciudad VARCHAR(100),
    Region VARCHAR(100),
    Pais VARCHAR(100),
    FuenteCliente VARCHAR(50), -- Magento o CRMLab
    GrupoCliente VARCHAR(50),  -- De customer_group Magento
    FechaRegistro DATE
);

-- Dimensión Producto (Magento)
CREATE TABLE DimProducto (
    ProductoID INT PRIMARY KEY,
    SKU VARCHAR(64),
    Nombre VARCHAR(255),
    Descripcion TEXT,
    Categoria VARCHAR(150),
    SubCategoria VARCHAR(150),
    Marca VARCHAR(100),
    PrecioBase DECIMAL(10,2),
    Costo DECIMAL(10,2),
    Estado VARCHAR(50) -- Activo/Inactivo
);

-- Dimensión Campaña (CRMLab + Magento salesrule_coupon)
CREATE TABLE DimCampaña (
    CampañaID INT PRIMARY KEY,
    Nombre VARCHAR(150),
    Tipo VARCHAR(50),
    Canal VARCHAR(50),  -- Email, Social, Llamada, etc.
    FechaInicio DATE,
    FechaFin DATE,
    Presupuesto DECIMAL(12,2),
    CodigoCupon VARCHAR(50),
    Estado VARCHAR(50)
);

-- Dimensión Tiempo (común a todos los hechos)
CREATE TABLE DimTiempo (
    TiempoID INT PRIMARY KEY,
    Fecha DATE,
    Dia INT,
    Mes INT,
    Anio INT,
    Trimestre INT,
    Semana INT,
    NombreMes VARCHAR(20),
    DiaSemana VARCHAR(20)
);

-- Dimensión Método de Pago (Magento)
CREATE TABLE DimMetodoPago (
    MetodoPagoID INT PRIMARY KEY,
    Nombre VARCHAR(100),
    Tipo VARCHAR(50)
);

-- Dimensión Método de Envío (Magento)
CREATE TABLE DimMetodoEnvio (
    MetodoEnvioID INT PRIMARY KEY,
    Nombre VARCHAR(100),
    Transportista VARCHAR(100),
    TiempoEstimadoEntrega INT
);

-- Dimensión Agente Comercial (CRMLab)
CREATE TABLE DimAgente (
    AgenteID INT PRIMARY KEY,
    Nombre VARCHAR(150),
    Email VARCHAR(150),
    Departamento VARCHAR(100),
    Rol VARCHAR(100)
);

-- Hecho Ventas (Magento)
CREATE TABLE FactVentas (
    VentaID BIGINT PRIMARY KEY,
    ClienteID INT,
    ProductoID INT,
    CampañaID INT NULL,
    TiempoID INT,
    MetodoPagoID INT,
    MetodoEnvioID INT,
    CantidadVendida INT,
    PrecioUnitario DECIMAL(10,2),
    Descuento DECIMAL(10,2),
    Impuesto DECIMAL(10,2),
    MontoTotal DECIMAL(12,2),
    Costo DECIMAL(10,2),
    Utilidad DECIMAL(12,2),
    EstadoPedido VARCHAR(50),
    FOREIGN KEY (ClienteID) REFERENCES DimCliente(ClienteID),
    FOREIGN KEY (ProductoID) REFERENCES DimProducto(ProductoID),
    FOREIGN KEY (CampañaID) REFERENCES DimCampaña(CampañaID),
    FOREIGN KEY (TiempoID) REFERENCES DimTiempo(TiempoID),
    FOREIGN KEY (MetodoPagoID) REFERENCES DimMetodoPago(MetodoPagoID),
    FOREIGN KEY (MetodoEnvioID) REFERENCES DimMetodoEnvio(MetodoEnvioID)
);

-- Hecho Campañas y Leads (CRMLab)
CREATE TABLE FactCampañasLeads (
    LeadID BIGINT PRIMARY KEY,
    ClienteID INT,
    CampañaID INT,
    TiempoID INT,
    ProductoID INT NULL,
    EstadoLead VARCHAR(50), -- Nuevo, Calificado, Perdido
    EstadoOportunidad VARCHAR(50), -- Abierta, Ganada, Perdida
    ValorOportunidad DECIMAL(12,2),
    FOREIGN KEY (ClienteID) REFERENCES DimCliente(ClienteID),
    FOREIGN KEY (CampañaID) REFERENCES DimCampaña(CampañaID),
    FOREIGN KEY (TiempoID) REFERENCES DimTiempo(TiempoID),
    FOREIGN KEY (ProductoID) REFERENCES DimProducto(ProductoID)
);

-- Hecho Interacciones Comerciales (CRMLab)
CREATE TABLE FactInteracciones (
    InteraccionID BIGINT PRIMARY KEY,
    ClienteID INT,
    CampañaID INT NULL,
    AgenteID INT,
    TiempoID INT,
    TipoInteraccion VARCHAR(50), -- Llamada, Reunión
    DuracionMinutos INT,
    Resultado VARCHAR(100), -- Exitoso, Sin respuesta, Seguimiento
    FOREIGN KEY (ClienteID) REFERENCES DimCliente(ClienteID),
    FOREIGN KEY (CampañaID) REFERENCES DimCampaña(CampañaID),
    FOREIGN KEY (AgenteID) REFERENCES DimAgente(AgenteID),
    FOREIGN KEY (TiempoID) REFERENCES DimTiempo(TiempoID)
);
