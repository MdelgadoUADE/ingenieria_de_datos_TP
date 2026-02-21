/*
usar para probar errores de ejecucion:
(cerrar diagramas)
use master
drop database main_runescape;
*/

CREATE DATABASE main_runescape
GO

USE main_runescape
GO

--Tablas

CREATE TABLE item(
    ID_item INT PRIMARY KEY NOT NULL,
    grado INT NOT NULL DEFAULT 1,
    tipo VARCHAR(20) NOT NULL,
    valor INT DEFAULT 0,
    propiedades VARCHAR(50),

    CONSTRAINT CHK_grado CHECK (grado > 0 AND grado <= 70)
);
GO

CREATE TABLE gremio(
	ID_Gremio INT PRIMARY KEY,
	Nombre_Gremio VARCHAR(50),
	Fondo INT,
	ID_Lider INT,

    CONSTRAINT CHK_ID_Gremio CHECK (ID_Gremio BETWEEN 100 AND 999),
    CONSTRAINT CHK_fondo CHECK (Fondo > 0),
);
GO

CREATE TABLE entidad(
    ID_entidad INT PRIMARY KEY NOT NULL,
    tipo VARCHAR(3),
    nombre_entidad VARCHAR(20),
    oro_disponible INT,

    CONSTRAINT CHK_tipo CHECK (tipo IN ('jug', 'npc')),

    CONSTRAINT CHK_oro_disponible CHECK (oro_disponible > 0)
);
GO

CREATE TABLE jugador(
    ID_jugador INT PRIMARY KEY NOT NULL,
    ID_gremio INT,

    CONSTRAINT FK_ID_jugador FOREIGN KEY (ID_jugador)
    REFERENCES entidad(ID_entidad),

    CONSTRAINT FK_ID_gremio FOREIGN KEY (ID_gremio) 
    REFERENCES GREMIO(ID_gremio),

    CONSTRAINT CHK_ID_jugador CHECK (ID_jugador BETWEEN 10000000 AND 99999999)
);
GO

ALTER TABLE Gremio
ADD 
CONSTRAINT FK_Jugador_Gremio FOREIGN KEY (ID_Lider)
REFERENCES jugador(ID_jugador)
GO

CREATE TABLE vendedor_npc(
    ID_vendedor INT PRIMARY KEY NOT NULL,

    CONSTRAINT FK_vendedor_npc FOREIGN KEY (ID_vendedor)
    REFERENCES entidad(ID_entidad),

    CONSTRAINT CH_NPC_5dig
    CHECK (ID_Vendedor BETWEEN 10000 AND 99999)
);
GO

CREATE TABLE item_en_inventario(
    ID_jugador INT PRIMARY KEY NOT NULL,
    ID_Item INT NOT NULL,

    CONSTRAINT FK_IDjug_Inv
    FOREIGN KEY (ID_jugador) REFERENCES jugador(ID_jugador),
    CONSTRAINT FK_IDitem_Inv
    FOREIGN KEY (ID_Item) REFERENCES Item(ID_Item)
);
GO

CREATE TABLE Administrador(   
    ID_jugador INT,
    Nombre_Admin VARCHAR(50)

    CONSTRAINT FK_Jugador_Admin FOREIGN KEY (ID_jugador)
    REFERENCES jugador(ID_jugador)

    CONSTRAINT PK_admin PRIMARY KEY (ID_jugador,Nombre_Admin)
);
GO

CREATE TABLE mazmorra(
    ID_mazmorra INT PRIMARY KEY,
    nivel INT,
    ID_Gremio INT,
    ID_Item INT,

    CONSTRAINT FK_Gremio_Mazmorra FOREIGN KEY (ID_Gremio)
    REFERENCES gremio(ID_Gremio),

    CONSTRAINT FK_Item_Mazmorra FOREIGN KEY (ID_Item)
    REFERENCES item(ID_item),

    CONSTRAINT CHK_nivel CHECK (nivel > 0 AND nivel <= 61)
);
GO

CREATE TABLE propietario(
    ID_Item_propiedad INT NOT NULL,
    ID_Jugador INT,
    ID_vendedor INT,
    ID_mazmorra INT,

    CONSTRAINT FK_Item_Prop FOREIGN KEY (ID_Item_propiedad)
    REFERENCES item(ID_item),

    CONSTRAINT FK_Jugador_Prop FOREIGN KEY (ID_Jugador)
    REFERENCES jugador(ID_jugador),

    CONSTRAINT FK_Vendedor_Prop FOREIGN KEY (ID_vendedor)
    REFERENCES vendedor_npc(ID_vendedor),

    CONSTRAINT FK_Mazmorra_Prop FOREIGN KEY (ID_mazmorra)
    REFERENCES mazmorra(ID_mazmorra),

    CONSTRAINT PK_Propietario PRIMARY KEY (ID_Item_propiedad,ID_Jugador,ID_vendedor)
);
GO

CREATE TABLE drop_table(
    ID_mazmorra INT PRIMARY KEY NOT NULL,
    categoria VARCHAR(20) NOT NULL,
    drop_rate INT DEFAULT 1,

    CONSTRAINT FK_Mazmorra_DT FOREIGN KEY (ID_mazmorra)
    REFERENCES mazmorra(ID_mazmorra),

    CONSTRAINT CHK_drop_rate CHECK (drop_rate > 0 AND drop_rate <= 100)
);
GO

create table Seguimiento_Venta(
    id_venta INT IDENTITY(1,1) NOT NULL,
    timestamp_venta DATETIME NOT NULL DEFAULT SYSDATETIME(),
    tipo_venta VARCHAR(20) NOT NULL,
    estado VARCHAR(15) NOT NULL DEFAULT 'COMPLETADA',

    CONSTRAINT CK_SeguimientoVenta_Tipo
        CHECK (tipo_venta IN ('PRIVADA','NPC')),

    CONSTRAINT CK_SeguimientoVenta_Estado
        CHECK (estado IN ('PENDIENTE','COMPLETADA','CANCELADA')),

    CONSTRAINT PK_Seguimiento_Venta
        PRIMARY KEY (id_venta),
);
GO

create table Detalle_Venta (
    id_venta INT NOT NULL,
    id_item INT NOT NULL,
    oro_item INT NULL,

    CONSTRAINT PK_Detalle_Venta
        PRIMARY KEY (id_venta, id_item),

    CONSTRAINT FK_DetalleVenta_Venta
        FOREIGN KEY (id_venta)
        REFERENCES Seguimiento_Venta(id_venta)
        ON DELETE CASCADE,

    CONSTRAINT FK_DetalleVenta_Item
        FOREIGN KEY (id_item)
        REFERENCES Item(id_item)
);
GO

CREATE TABLE Seguimiento_Venta_Privado (
    id_venta INT NOT NULL,
    id_jugador_emisor INT NOT NULL,
    id_jugador_receptor INT NOT NULL,
    oro_total INT NULL,

    CONSTRAINT PK_Seguimiento_Venta_Privado
        PRIMARY KEY (id_venta),

    CONSTRAINT FK_Privado_Venta
        FOREIGN KEY (id_venta)
        REFERENCES Seguimiento_Venta(id_venta)
        ON DELETE CASCADE,

    CONSTRAINT FK_Privado_Emisor
        FOREIGN KEY (id_jugador_emisor)
        REFERENCES Jugador(id_jugador),

    CONSTRAINT FK_Privado_Receptor
        FOREIGN KEY (id_jugador_receptor)
        REFERENCES Jugador(id_jugador),

    CONSTRAINT CK_Privado_JugadoresDistintos
        CHECK (id_jugador_emisor <> id_jugador_receptor)
);
GO

CREATE TABLE Seguimiento_Venta_NPC (
    id_venta INT NOT NULL,
    id_jugador INT NOT NULL,
    id_vendedor_npc INT NOT NULL,
    es_compra BIT NOT NULL,
    id_gremio_pagador INT NULL,
    oro_total INT NOT NULL,

    CONSTRAINT PK_Seguimiento_Venta_NPC
        PRIMARY KEY (id_venta),

    CONSTRAINT FK_NPC_Venta
        FOREIGN KEY (id_venta)
        REFERENCES Seguimiento_Venta(id_venta)
        ON DELETE CASCADE,

    CONSTRAINT FK_NPC_Jugador
        FOREIGN KEY (id_jugador)
        REFERENCES Jugador(id_jugador),

    CONSTRAINT FK_NPC_Vendedor
        FOREIGN KEY (id_vendedor_npc)
        REFERENCES Vendedor_NPC(id_vendedor),

    CONSTRAINT FK_NPC_Gremio
        FOREIGN KEY (id_gremio_pagador)
        REFERENCES Gremio(id_gremio)
);
GO

--Procedimientos
--  Tabla ITEM

CREATE PROCEDURE Insertar_Item
@ID_item INT,
@grado INT,
@tipo VARCHAR(20),
@valor INT,
@propiedades VARCHAR(50)
AS
BEGIN
    INSERT INTO item (ID_item, grado, tipo, valor, propiedades)
    VALUES (@ID_item, @grado, @tipo, @valor, @propiedades)
END

GO

--  Tabla Gremio

CREATE PROCEDURE Insertar_gremio

@ID_Gremio INT,
@Nombre_Gremio VARCHAR(50),
@Fondo DECIMAL(10,2),
@ID_Lider INT

AS
BEGIN
    INSERT INTO Gremio (ID_Gremio, Nombre_Gremio, Fondo, ID_Lider)
    VALUES (@ID_Gremio, @Nombre_Gremio, @Fondo, @ID_Lider)
END

GO

CREATE PROCEDURE Modificar_Gremio

@ID_Gremio INT,
@Nombre_Gremio VARCHAR(50),
@Fondo DECIMAL(10,2),
@ID_Lider INT

AS
BEGIN
    UPDATE Gremio
    SET Nombre_Gremio = @Nombre_Gremio,
        Fondo = @Fondo,
        ID_Lider = @ID_Lider
    WHERE ID_Gremio = @ID_Gremio
END

GO

CREATE PROCEDURE Borrar_Gremio

@ID_Gremio INT

AS
BEGIN
    DELETE FROM Gremio
    WHERE ID_Gremio = @ID_Gremio
END

GO

--Tabla Admin

CREATE PROCEDURE Insertar_Admin

@ID_entidad INT,
@Nombre_Admin VARCHAR(50)

AS
BEGIN
    INSERT INTO Administrador (ID_jugador, Nombre_Admin)
    VALUES (@ID_entidad, @Nombre_Admin)
END

GO

CREATE PROCEDURE Modificar_Admin

@ID_entidad INT,
@Nombre_Admin VARCHAR(50)

AS
BEGIN
    UPDATE Administrador
    SET Nombre_Admin = @Nombre_Admin
    WHERE ID_jugador = @ID_entidad
END

GO

CREATE PROCEDURE EliminarAdmin

@ID_entidad INT

AS
BEGIN
    DELETE FROM Administrador
    WHERE ID_jugador = @ID_entidad
END

GO

--Tabla item_en_inventario

CREATE PROCEDURE SP_Insert_Inv
@ID_entidad int,
@ID_item int
AS BEGIN
INSERT INTO item_en_inventario(ID_jugador, ID_Item) VALUES
(@ID_entidad, @ID_item)
END;

GO

CREATE PROCEDURE SP_Update_Inv
@ID_entidad int,
@ID_item int 
AS BEGIN
UPDATE item_en_inventario
SET ID_Item = @ID_Item
WHERE ID_jugador = @ID_entidad
END;

GO

CREATE PROCEDURE SP_Delete_Inv
@ID_entidad int
AS BEGIN
DELETE FROM item_en_inventario
WHERE ID_jugador = @ID_entidad
END;

GO

--Tabla NPC

CREATE PROCEDURE SP_Insert_NPC
@ID_vendedor int
AS BEGIN
INSERT INTO Vendedor_NPC(ID_Vendedor) VALUES
(@ID_vendedor)
END;

GO

CREATE PROCEDURE SP_Update_NPC
@ID_vendedor int
AS BEGIN
UPDATE Vendedor_NPC
SET ID_Vendedor = @ID_Vendedor
END;

GO

CREATE PROCEDURE SP_Delete_NPC
@ID_vendedor int
AS BEGIN
DELETE FROM Vendedor_NPC
WHERE ID_Vendedor = @ID_Vendedor
END;

GO

CREATE VIEW VW_Items_Vendidos_NPC AS
SELECT 
    n.id_vendedor_npc,
    dv.id_item,
    COUNT(*) AS cantidad_vendida
FROM Seguimiento_Venta_NPC n
JOIN Seguimiento_Venta v ON v.id_venta = n.id_venta
JOIN Detalle_Venta dv ON dv.id_venta = v.id_venta
WHERE n.es_compra = 1   -- jugador compra ? npc vende
GROUP BY n.id_vendedor_npc, dv.id_item;
GO

CREATE VIEW VW_Valor_Inventario_Jugador AS
SELECT 
    j.id_jugador,
    SUM(i.valor) AS valor_total_inventario
FROM jugador j
LEFT JOIN item_en_inventario inv ON j.id_jugador = inv.id_jugador
LEFT JOIN item i ON i.id_item = inv.id_item
GROUP BY j.id_jugador;
GO

CREATE VIEW VW_Jugadores_Mas_Ricos AS
SELECT 
    j.id_jugador,
    e.oro_disponible,
    ISNULL(v.valor_total_inventario,0) AS valor_inventario,
    e.oro_disponible + ISNULL(v.valor_total_inventario,0) AS riqueza_total
FROM jugador j
JOIN entidad e ON j.id_jugador = e.id_entidad
LEFT JOIN VW_Valor_Inventario_Jugador v ON v.id_jugador = j.id_jugador;
GO


CREATE VIEW VW_Riqueza_Gremio AS
SELECT 
    g.id_gremio,
    g.nombre_gremio,
    g.fondo +
    ISNULL(SUM(e.oro_disponible + ISNULL(v.valor_total_inventario,0)),0)
    AS riqueza_total_gremio
FROM gremio g
LEFT JOIN jugador j ON j.id_gremio = g.id_gremio
LEFT JOIN entidad e ON j.id_jugador = e.id_entidad
LEFT JOIN VW_Valor_Inventario_Jugador v ON v.id_jugador = j.id_jugador
GROUP BY g.id_gremio, g.nombre_gremio, g.fondo;
GO


