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
    ID_item VARCHAR(12) PRIMARY KEY NOT NULL,
    grado INT NOT NULL DEFAULT 1,
    tipo VARCHAR(20) NOT NULL,
    valor INT DEFAULT 0,

    CONSTRAINT CHK_grado CHECK (grado > 0 AND grado <= 70)
);
GO

CREATE TABLE propiedades(
    ID_item VARCHAR(12) NOT NULL,
    propiedad VARCHAR(20) NOT NULL,

	CONSTRAINT PK_Porpiedades PRIMARY KEY (ID_item, propiedad),

    CONSTRAINT FK_IDitem_prop FOREIGN KEY (ID_item)
    REFERENCES item(ID_item)
);

CREATE TABLE historial_precio(
    ID_Item VARCHAR(12) NOT NULL,
    valor INT NOT NULL,
    timestamp DATETIME NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT PK_historial_precio
    PRIMARY KEY (ID_item, timestamp),
    
    CONSTRAINT FK_IDitem_hist FOREIGN KEY (ID_item)
    REFERENCES item(ID_item)
);

CREATE TABLE entidad(
    nombre_entidad VARCHAR(20) PRIMARY KEY NOT NULL,
    oro_disponible INT,

    CONSTRAINT CHK_oro_disponible CHECK (oro_disponible >= 0)
);

CREATE TABLE tipo_entidad(
    identificador_tipo VARCHAR(3) PRIMARY KEY NOT NULL
);
GO

CREATE TABLE gremio(
    ID_Gremio INT PRIMARY KEY NOT NULL,
    nombre_gremio VARCHAR(50) NOT NULL,
    Fondo INT NOT NULL DEFAULT 0,
    nombre_entidad_lider VARCHAR(20) NOT NULL, -- Referencia al líder

    CONSTRAINT CHK_ID_Gremio CHECK (ID_Gremio BETWEEN 1000 AND 9999),
    CONSTRAINT CHK_fondo CHECK (Fondo >= 0),
    CONSTRAINT FK_gremio_lider FOREIGN KEY (nombre_entidad_lider) 
    REFERENCES entidad(nombre_entidad)
);

CREATE TABLE entidad_tipo(
    nombre_entidad VARCHAR(20) NOT NULL,
    identificador_tipo VARCHAR(3) NOT NULL,

	CONSTRAINT PK_entidad_tipo PRIMARY KEY (nombre_entidad, identificador_tipo),

    CONSTRAINT FK_entidad FOREIGN KEY (nombre_entidad)
    REFERENCES entidad(nombre_entidad),

    CONSTRAINT FK_tipo_entidad FOREIGN KEY (identificador_tipo)
    REFERENCES tipo_entidad(identificador_tipo),
);

CREATE TABLE item_entidad(
    ID_item VARCHAR(12) NOT NULL,
    nombre_entidad VARCHAR(20) NOT NULL,

    CONSTRAINT PK_item_entidad
    PRIMARY KEY (ID_item, nombre_entidad),

    CONSTRAINT FK_item_ent FOREIGN KEY (ID_item)
    REFERENCES item(ID_item),

    CONSTRAINT FK_entidad_item FOREIGN KEY (nombre_entidad)
    REFERENCES entidad(nombre_entidad),
);
GO

CREATE TABLE mazmorra(
    ID_mazmorra VARCHAR(5) PRIMARY KEY,
    nivel INT NOT NULL,
    ID_Gremio INT,
    ID_Item varchar(12) NOT NULL,
    drop_rate INT DEFAULT 1 NOT NULL,

    CONSTRAINT FK_Gremio_Mazmorra FOREIGN KEY (ID_Gremio)
    REFERENCES gremio(ID_Gremio),

    CONSTRAINT FK_Item_Mazmorra FOREIGN KEY (ID_Item)
    REFERENCES item(ID_item),

    CONSTRAINT CHK_nivel CHECK (nivel > 0 AND nivel <= 60)
);
GO

CREATE TABLE mazmorra_categoria(
    ID_mazmorra VARCHAR(5) NOT NULL PRIMARY KEY,
    categoria VARCHAR(20) NOT NULL,

    CONSTRAINT FK_Mazmorra_Cat FOREIGN KEY (ID_mazmorra)
    REFERENCES mazmorra(ID_mazmorra)
);

CREATE TABLE ventas(
    id_transaccion INT PRIMARY KEY NOT NULL IDENTITY(1,1),
    nombre_entidad_vendedor VARCHAR(20) NOT NULL,
    nombre_entidad_comprador VARCHAR(20) NOT NULL,
    oro_intercambiado INT NOT NULL,
    timestamp DATETIME NOT NULL DEFAULT SYSDATETIME(),
    chk_gremio INT NOT NULL,

    CONSTRAINT FK_entidad_vendedor FOREIGN KEY (nombre_entidad_vendedor)
    REFERENCES entidad(nombre_entidad),

    CONSTRAINT FK_entidad_comprador FOREIGN KEY (nombre_entidad_comprador)
    REFERENCES entidad(nombre_entidad),

    CONSTRAINT CHK_oro_intercambiado CHECK (oro_intercambiado > 0),

    CONSTRAINT CHK_chk_gremio CHECK (chk_gremio = 0 OR chk_gremio = 1)
);
GO

create table Detalle_Venta (
    id_transaccion INT NOT NULL,
    id_item VARCHAR(12) NOT NULL,

    CONSTRAINT PK_Detalle_Venta PRIMARY KEY (id_transaccion, id_item),

    CONSTRAINT FK_DetalleVenta_Venta FOREIGN KEY (id_transaccion)
    REFERENCES ventas(id_transaccion),

    CONSTRAINT FK_DetalleVenta_Item FOREIGN KEY (id_item)
    REFERENCES Item(id_item)
);

CREATE TABLE jugador(
    nombre_entidad VARCHAR(20) PRIMARY KEY NOT NULL,
    ID_gremio INT NOT NULL,

    CONSTRAINT FK_entidad_jugador FOREIGN KEY (nombre_entidad)
    REFERENCES entidad(nombre_entidad),

    CONSTRAINT FK_gremio_jugador FOREIGN KEY (ID_gremio)
    REFERENCES gremio(ID_gremio)
);

CREATE TABLE Item_mazmorra(
    ID_item VARCHAR(12) NOT NULL,
    ID_mazmorra VARCHAR(5) NOT NULL,

    CONSTRAINT PK_Item_mazmorra PRIMARY KEY (ID_item, ID_mazmorra),

    CONSTRAINT FK_Item_maz FOREIGN KEY (ID_item)
    REFERENCES item(ID_item),

    CONSTRAINT FK_Mazmorra FOREIGN KEY (ID_mazmorra)
    REFERENCES mazmorra(ID_mazmorra) 
);
GO


-- Procedimientos
--  Tabla ITEM

CREATE PROCEDURE Insertar_Item
@ID_item VARCHAR(12),
@grado INT,
@tipo VARCHAR(20),
@valor INT
AS
BEGIN
    INSERT INTO item (ID_item, grado, tipo, valor)
    VALUES (@ID_item, @grado, @tipo, @valor)
END;

GO

CREATE PROCEDURE Modificar_Item
@ID_item VARCHAR(12),
@grado INT,
@tipo VARCHAR(20),
@valor INT
AS
BEGIN
    UPDATE item
    SET grado = @grado,
        tipo = @tipo,
        valor = @valor
    WHERE ID_item = @ID_item
END;

GO

CREATE PROCEDURE Borrar_Item
@ID_item VARCHAR(12)
AS
BEGIN
    DELETE FROM item
    WHERE ID_item = @ID_item
END;

GO

--  Tabla Propiedades

CREATE PROCEDURE Insertar_Propiedades
@ID_item VARCHAR(12),
@propiedad VARCHAR(20)
AS
BEGIN
    INSERT INTO propiedades (ID_item, propiedad)
    VALUES (@ID_item, @propiedad)
END;

GO

CREATE PROCEDURE Modificar_Propiedades
@ID_item VARCHAR(12),
@propiedad VARCHAR(20)
AS
BEGIN
    UPDATE propiedades
    SET propiedad = @propiedad
    WHERE ID_item = @ID_item AND propiedad = @propiedad
END;

GO

CREATE PROCEDURE Borrar_Propiedades
@ID_item VARCHAR(12),
@propiedad VARCHAR(20)
AS
BEGIN
    DELETE FROM propiedades
    WHERE ID_item = @ID_item AND propiedad = @propiedad
END;

GO

--  Tabla historial_precio

CREATE PROCEDURE Insertar_historial_precio
@ID_item VARCHAR(12),
@valor INT
AS
BEGIN
    INSERT INTO historial_precio (ID_item, valor)
    VALUES (@ID_item, @valor)
END;

GO

CREATE PROCEDURE Modificar_historial_precio
@ID_item VARCHAR(12),
@valor INT,
@timestamp DATETIME
AS
BEGIN
    UPDATE historial_precio
    SET valor = @valor
    WHERE ID_item = @ID_item AND timestamp = @timestamp
END;

GO

--  Tabla Gremio

CREATE PROCEDURE Insertar_gremio
    @ID_Gremio INT,
    @Nombre_Gremio VARCHAR(50),
    @Fondo INT,
    @nombre_entidad_lider VARCHAR(20)
AS
BEGIN
    INSERT INTO gremio (ID_Gremio, nombre_gremio, Fondo, nombre_entidad_lider)
    VALUES (@ID_Gremio, @Nombre_Gremio, @Fondo, @nombre_entidad_lider)
END;
GO

CREATE PROCEDURE Modificar_Gremio
    @ID_Gremio INT,
    @Nombre_Gremio VARCHAR(50),
    @Fondo INT,
    @nombre_entidad_lider VARCHAR(20)
AS
BEGIN
    UPDATE gremio
    SET nombre_gremio = @Nombre_Gremio,
        Fondo = @Fondo,
        nombre_entidad_lider = @nombre_entidad_lider
    WHERE ID_Gremio = @ID_Gremio
END;
GO

CREATE PROCEDURE Borrar_Gremio
@ID_Gremio INT
AS
BEGIN
    DELETE FROM Gremio
    WHERE ID_Gremio = @ID_Gremio
END;

GO

--  Tabla entidad

CREATE PROCEDURE Insertar_entidad
@nombre_entidad VARCHAR(20),
@oro_disponible INT
AS
BEGIN
    INSERT INTO entidad (nombre_entidad, oro_disponible)
    VALUES (@nombre_entidad, @oro_disponible)
END;

GO

CREATE PROCEDURE Modificar_entidad
@nombre_entidad VARCHAR(20),
@oro_disponible INT
AS
BEGIN
    UPDATE entidad
    SET oro_disponible = @oro_disponible
    WHERE nombre_entidad = @nombre_entidad
END;

GO

CREATE PROCEDURE Borrar_entidad
@nombre_entidad VARCHAR(20)
AS
BEGIN
    DELETE FROM entidad
    WHERE nombre_entidad = @nombre_entidad
END;

GO

--  Tabla tipo_entidad

CREATE PROCEDURE Insertar_tipo_entidad
@identificador_tipo VARCHAR(3)
AS
BEGIN
    INSERT INTO tipo_entidad (identificador_tipo)
    VALUES (@identificador_tipo)
END;

GO

--  Tabla entidad_tipo

CREATE PROCEDURE Insertar_entidad_tipo
@identificador_tipo VARCHAR(3),
@nombre_entidad VARCHAR(20)
AS
BEGIN
    INSERT INTO entidad_tipo (identificador_tipo, nombre_entidad)
    VALUES (@identificador_tipo, @nombre_entidad)
END;

GO

CREATE PROCEDURE Modificar_entidad_tipo
@identificador_tipo VARCHAR(3),
@nombre_entidad VARCHAR(20)
AS
BEGIN
    UPDATE entidad_tipo
    SET identificador_tipo = @identificador_tipo
    WHERE nombre_entidad = @nombre_entidad
END;

GO

CREATE PROCEDURE Borrar_entidad_tipo
@nombre_entidad VARCHAR(20)
AS
BEGIN
    DELETE FROM entidad_tipo
    WHERE nombre_entidad = @nombre_entidad
END;

GO

-- Tabla ventas

CREATE PROCEDURE Insertar_Venta
@nombre_entidad_vendedor VARCHAR(20),
@nombre_entidad_comprador VARCHAR(20),
@oro_intercambiado INT,
@chk_gremio INT
AS
BEGIN
    INSERT INTO ventas (nombre_entidad_vendedor, nombre_entidad_comprador, oro_intercambiado, chk_gremio)
    VALUES (@nombre_entidad_vendedor, @nombre_entidad_comprador, @oro_intercambiado, @chk_gremio)
END;

GO

CREATE PROCEDURE Modificar_Venta
@id_transaccion INT,
@nombre_entidad_vendedor VARCHAR(20),
@nombre_entidad_comprador VARCHAR(20),
@oro_intercambiado INT,
@chk_gremio INT
AS
BEGIN
    UPDATE ventas
    SET nombre_entidad_vendedor = @nombre_entidad_vendedor,
        nombre_entidad_comprador = @nombre_entidad_comprador,
        oro_intercambiado = @oro_intercambiado,
        chk_gremio = @chk_gremio
    WHERE id_transaccion = @id_transaccion
END;

GO

CREATE PROCEDURE Borrar_Venta
@id_transaccion INT
AS
BEGIN
    DELETE FROM ventas
    WHERE id_transaccion = @id_transaccion
END;

GO

-- Tabla Detalle_Venta

CREATE PROCEDURE Insertar_Detalle_Venta
@id_transaccion INT,
@id_item VARCHAR(12)
AS
BEGIN
    INSERT INTO Detalle_Venta (id_transaccion, id_item)
    VALUES (@id_transaccion, @id_item)
END;

GO

CREATE PROCEDURE Modificar_Detalle_Venta
@id_transaccion INT,
@id_item VARCHAR(12)
AS
BEGIN
    UPDATE Detalle_Venta
    SET id_transaccion = @id_transaccion,
        id_item = @id_item
    WHERE id_transaccion = @id_transaccion AND id_item = @id_item
END;

GO

CREATE PROCEDURE Borrar_Detalle_Venta
@id_transaccion INT,
@id_item VARCHAR(12)
AS
BEGIN
    DELETE FROM Detalle_Venta
    WHERE id_transaccion = @id_transaccion AND id_item = @id_item
END;

GO

--  Tabla jugador

CREATE PROCEDURE Insertar_jugador
    @nombre_entidad VARCHAR(20),
    @ID_gremio INT
AS
BEGIN
    INSERT INTO jugador (nombre_entidad, ID_gremio)
    VALUES (@nombre_entidad, @ID_gremio)
END;
GO

CREATE PROCEDURE Modificar_jugador
    @nombre_entidad VARCHAR(20),
    @ID_gremio INT
AS
BEGIN
    UPDATE jugador
    SET ID_gremio = @ID_gremio
    WHERE nombre_entidad = @nombre_entidad
END;
GO

CREATE PROCEDURE Borrar_jugador
    @nombre_entidad VARCHAR(20)
AS
BEGIN
    DELETE FROM jugador
    WHERE nombre_entidad = @nombre_entidad
END;
GO

--  Tabla Mazmorra

CREATE PROCEDURE Insertar_Mazmorra
@ID_mazmorra VARCHAR(5),
@nivel INT,
@ID_Gremio INT,
@ID_Item INT,
@drop_rate INT
AS
BEGIN
    INSERT INTO mazmorra (ID_mazmorra, nivel, ID_Gremio, ID_Item, drop_rate)
    VALUES (@ID_mazmorra, @nivel, @ID_Gremio, @ID_Item, @drop_rate)
END;

GO

CREATE PROCEDURE Modificar_Mazmorra
@ID_mazmorra VARCHAR(5),
@nivel INT,
@ID_Gremio INT,
@ID_Item INT,
@drop_rate INT
AS
BEGIN
    UPDATE mazmorra
    SET nivel = @nivel,
        ID_Gremio = @ID_Gremio,
        ID_Item = @ID_Item,
        drop_rate = @drop_rate
    WHERE ID_mazmorra = @ID_mazmorra
END;

GO

CREATE PROCEDURE Borrar_Mazmorra
@ID_mazmorra VARCHAR(5)
AS
BEGIN
    DELETE FROM mazmorra
    WHERE ID_mazmorra = @ID_mazmorra
END;

GO

--  Tabla Mazmorra_Categoria

CREATE PROCEDURE Insertar_Mazmorra_Categoria
@ID_mazmorra VARCHAR(5),
@categoria VARCHAR(20)
AS
BEGIN
    INSERT INTO mazmorra_categoria (ID_mazmorra, categoria)
    VALUES (@ID_mazmorra, @categoria)
END;

GO

CREATE PROCEDURE Modificar_Mazmorra_Categoria
@ID_mazmorra VARCHAR(5),
@categoria VARCHAR(20)
AS
BEGIN
    UPDATE mazmorra_categoria
    SET categoria = @categoria
    WHERE ID_mazmorra = @ID_mazmorra
END;

GO

CREATE PROCEDURE Borrar_Mazmorra_Categoria
@ID_mazmorra VARCHAR(5)
AS
BEGIN
    DELETE FROM mazmorra_categoria
    WHERE ID_mazmorra = @ID_mazmorra
END;

GO

--  Tabla Item_Entidad

CREATE PROCEDURE Insertar_item_entidad
@id_item VARCHAR(12),
@nombre_entidad VARCHAR(20)
AS
BEGIN
    INSERT INTO item_entidad (id_item, nombre_entidad)
    VALUES (@id_item, @nombre_entidad)
END;

GO

CREATE PROCEDURE Modificar_item_entidad
@id_item VARCHAR(12),
@nombre_entidad VARCHAR(20)
AS
BEGIN
    UPDATE item_entidad
    SET id_item = @id_item,
        nombre_entidad = @nombre_entidad
    WHERE id_item = @id_item AND nombre_entidad = @nombre_entidad
END;

GO

CREATE PROCEDURE Borrar_item_entidad
@id_item VARCHAR(12),
@nombre_entidad VARCHAR(20)
AS
BEGIN
    DELETE FROM item_entidad
    WHERE id_item = @id_item AND nombre_entidad = @nombre_entidad
END;

GO

--  Tabla Item_Mazmorra

CREATE PROCEDURE Insertar_item_mazmorra
@ID_item VARCHAR(12),
@ID_mazmorra VARCHAR(5)
AS
BEGIN
    INSERT INTO item_mazmorra (ID_item, ID_mazmorra)
    VALUES (@ID_item, @ID_mazmorra)
END;

GO

CREATE PROCEDURE Modificar_item_mazmorra
@ID_item VARCHAR(12),
@ID_mazmorra VARCHAR(5)
AS
BEGIN
    UPDATE item_mazmorra
    SET ID_item = @ID_item,
        ID_mazmorra = @ID_mazmorra
    WHERE ID_item = @ID_item AND ID_mazmorra = @ID_mazmorra
END;

GO

CREATE PROCEDURE Borrar_item_mazmorra
@ID_item VARCHAR(12),
@ID_mazmorra VARCHAR(5)
AS
BEGIN
    DELETE FROM item_mazmorra
    WHERE ID_item = @ID_item AND ID_mazmorra = @ID_mazmorra
END;

GO

-- VISTAS

-- Items vendidos por NPC          

CREATE VIEW VW_Items_Vendidos_NPC AS
SELECT 
    v.nombre_entidad_vendedor AS NPC_Vendedor,
    dv.id_item,
    COUNT(*) AS cantidad_vendida
FROM ventas v
JOIN Detalle_Venta dv ON v.id_transaccion = dv.id_transaccion
JOIN entidad_tipo et ON v.nombre_entidad_vendedor = et.nombre_entidad
WHERE et.identificador_tipo = 'NPC'
GROUP BY v.nombre_entidad_vendedor, dv.id_item;
GO

-- Valor total del inventario por jugador

CREATE VIEW VW_Valor_Inventario_Jugador AS
SELECT 
    e.nombre_entidad,
    SUM(i.valor) AS valor_total_inventario
FROM item_entidad ie
JOIN item i ON i.ID_item = ie.ID_item
JOIN entidad e ON ie.nombre_entidad = e.nombre_entidad
GROUP BY e.nombre_entidad;
GO


-- Ranking de jugadores mas ricos

CREATE VIEW VW_Jugadores_Mas_Ricos AS
SELECT 
    e.nombre_entidad,
    e.oro_disponible,
    ISNULL(v.valor_total_inventario, 0) AS valor_items,
    e.oro_disponible + ISNULL(v.valor_total_inventario, 0) AS riqueza_total
FROM jugador j
JOIN entidad e ON j.nombre_entidad = e.nombre_entidad 
LEFT JOIN VW_Valor_Inventario_Jugador v ON v.nombre_entidad = e.nombre_entidad;
GO

-- Ranking de riqueza total por gremio

CREATE VIEW VW_Riqueza_Gremio AS
SELECT 
    g.id_gremio,
    g.nombre_gremio,
    g.fondo + ISNULL(SUM(e.oro_disponible + ISNULL(v.valor_total_inventario, 0)), 0) AS riqueza_total_gremio
FROM gremio g
LEFT JOIN jugador j ON j.id_gremio = g.id_gremio
LEFT JOIN entidad e ON j.nombre_entidad = e.nombre_entidad
LEFT JOIN VW_Valor_Inventario_Jugador v ON v.nombre_entidad = e.nombre_entidad
GROUP BY g.id_gremio, g.nombre_gremio, g.fondo;
GO


-- Jugadores con su oro actual 

CREATE VIEW Info_Jugador AS
SELECT 
j.nombre_entidad AS Jugador, 
e.oro_disponible AS Oro 

FROM jugador j 
JOIN entidad e ON j.nombre_entidad = e.nombre_entidad;
GO


-- Jugadores con su gremio 

CREATE VIEW Info_Jugador_Gremio AS
SELECT 
    j.nombre_entidad,
    g.nombre_gremio AS Gremio
FROM jugador j
JOIN gremio g ON j.ID_gremio = g.ID_Gremio;
GO


-- Jugadores que son lideres de gremio 

CREATE VIEW Jugadores_Lideres AS
SELECT
    j.nombre_entidad AS 'Jugador Lider', 
    g.Nombre_Gremio AS Gremio
FROM jugador j 
JOIN gremio g ON g.nombre_entidad_lider = j.nombre_entidad;
GO


-- Jugadores con la info de sus items

CREATE VIEW Jugadores_Items AS
SELECT
    e.nombre_entidad AS Nombre,
    it.ID_item,
    it.grado,
    it.tipo,
    it.valor
FROM item it
JOIN item_entidad ie on it.ID_Item = ie.ID_Item
JOIN entidad e ON ie.nombre_entidad = e.nombre_entidad;
GO


-- Inventario completo de jugadores

CREATE VIEW Inventario_Jugador AS
SELECT 
    e.nombre_entidad AS Propietario, 
    ie.ID_item, 
    i.tipo,
    i.grado,
    i.valor
FROM item_entidad ie
JOIN entidad e ON ie.nombre_entidad = e.nombre_entidad
JOIN item i ON ie.ID_item = i.ID_item;
GO


-- Items por valor

CREATE VIEW Item_valor
AS
SELECT i.ID_item, p.propiedad, i.valor
FROM item as i
LEFT JOIN propiedades p ON i.ID_item = p.ID_item;
GO


--Items por tipo

CREATE VIEW Item_tipo
AS
SELECT i.ID_item, i.tipo
FROM item as i
GO


--Items por grado

CREATE VIEW Item_grado
AS
SELECT i.ID_item, i.grado
FROM item as i
GO


--Items con propietario actual

CREATE VIEW Item_Propietario AS
SELECT 
    i.ID_item, 
    i.tipo, 
    i.grado, 
    i.valor, 
    ie.nombre_entidad AS Propietario
FROM item i
LEFT JOIN item_entidad ie ON i.ID_item = ie.ID_item;
GO


-- CONSULTAS

-- Promedio de oro por jugador

SELECT 
AVG(e.oro_disponible) AS 'Promedio Oro de Jugadores'

FROM jugador j
JOIN entidad e ON j.nombre_entidad = e.nombre_entidad;


-- Top 5 jugadores mas ricos

SELECT TOP 5
    nombre_entidad,
    oro_disponible
FROM entidad
ORDER BY oro_disponible DESC;


-- Top 5 gremios mas ricos

SELECT TOP 5
Nombre_Gremio,
Fondo

FROM gremio

ORDER BY Fondo DESC


--Cantidad de items por tipo

SELECT i.tipo, COUNT(i.tipo) AS Cantidad
FROM item AS i
GROUP BY i.tipo


--Cantidad total de jugadores

SELECT COUNT(nombre_entidad) AS 'Cantidad de Jugadores'
FROM jugador;

--Promedio de valor de items

SELECT AVG(i.valor) AS 'Promedio valor items'
FROM item as i


--Gremios sin miembros

SELECT g.ID_Gremio, g.nombre_gremio
FROM gremio g
LEFT JOIN jugador j ON j.ID_gremio = g.ID_Gremio
WHERE j.nombre_entidad IS NULL;


--Miembros de un gremio específico

DECLARE @ID_Gremio INT = 1000; -- Cambiar por el que quieran

SELECT 
    j.nombre_entidad AS Jugador,
    e.oro_disponible,
    g.nombre_gremio
FROM jugador j
JOIN entidad e ON j.nombre_entidad = e.nombre_entidad
JOIN gremio g ON j.ID_gremio = g.ID_Gremio
WHERE j.ID_gremio = @ID_Gremio;


-- Items de grado máximo

SELECT *
FROM item
WHERE grado = (
    SELECT MAX(grado)
    FROM item
);
