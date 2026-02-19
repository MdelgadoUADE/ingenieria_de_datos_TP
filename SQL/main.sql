CREATE DATABASE main_runescape

USE main_runescape
GO;

--Tablas

CREATE TABLE item(
    ID_item INT PRIMARY KEY NOT NULL,
    grado INT NOT NULL DEFAULT 1,
    tipo VARCHAR(20) NOT NULL,
    valor INT DEFAULT 0,
    propiedades VARCHAR(50),

    CONSTRAINT CHK_grado CHECK (grado > 0 AND grado <= 70)
);

CREATE TABLE entidad(
    ID_entidad INT PRIMARY KEY NOT NULL,
    tipo VARCHAR(3),
    nombre_entidad VARCHAR(20),
    oro_disponible INT,

    CONSTRAINT CHK_tipo CHECK (tipo IN ('jug', 'npc')),

    CONSTRAINT CHK_oro_disponible CHECK (oro_disponible > 0),

    CONSTRAINT FK_ID_gremio FOREIGN KEY (ID_gremio) 
    REFERENCES GREMIO(ID_gremio)
);

CREATE TABLE jugador(
    ID_jugador INT PRIMARY KEY NOT NULL,
    ID_gremio INT,

    CONSTRAINT FK_ID_jugador FOREIGN KEY (ID_jugador)
    REFERENCES entidad(ID_entidad),

    CONSTRAINT FK_ID_gremio FOREIGN KEY (ID_gremio) 
    REFERENCES GREMIO(ID_gremio),

    CONSTRAINT CHK_ID_jugador CHECK (ID_jugador BETWEEN 10000000 AND 99999999)
);

CREATE TABLE vendedor_npc(
    ID_vendedor INT PRIMARY KEY NOT NULL,

    CONSTRAINT FK_vendedor_npc FOREIGN KEY (ID_vendedor)
    REFERENCES entidad(ID_entidad),

    CONSTRAINT CH_NPC_5dig
    CHECK (ID_Vendedor BETWEEN 10000 AND 99999)
);

CREATE TABLE item_en_inventario(
    ID_jugador INT PRIMARY KEY,
    ID_Item INT NOT NULL,

    CONSTRAINT FK_IDjug_Inv
    FOREIGN KEY (ID_jugador) REFERENCES jugador(ID_jugador),
    CONSTRAINT FK_IDitem_Inv
    FOREIGN KEY (ID_Item) REFERENCES Item(ID_Item)
);


CREATE TABLE gremio
(
	ID_Gremio INT PRIMARY KEY,
	Nombre_Gremio VARCHAR(50),
	Fondo INT,
	ID_Lider INT,

    CONSTRAINT CHK_ID_Gremio CHECK (ID_Gremio BETWEEN 100 AND 999),
    CONSTRAINT CHK_fondo CHECK (Fondo > 0),

    CONSTRAINT FK_Jugador_Gremio FOREIGN KEY (ID_Lider)
    REFERENCES jugador(ID_jugador)
);

CREATE TABLE Administrador
(   
    ID_jugador INT,
    Nombre_Admin VARCHAR(50)

    CONSTRAINT FK_Jugador_Admin FOREIGN KEY (ID_jugador)
    REFERENCES jugador(ID_jugador)

    CONSTRAINT PK_admin PRIMARY KEY (ID_jugador,Nombre_Admin)
);

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
)

--Procedimientos
--  Tabla ITEM

GO;
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


GO;
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
    INSERT INTO Administrador (ID_entidad, Nombre_Admin)
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
    WHERE ID_entidad = @ID_entidad
END
GO

CREATE PROCEDURE EliminarAdmin

@ID_entidad INT

AS
BEGIN
    DELETE FROM Administrador
    WHERE ID_entidad = @ID_entidad
END
GO


--Tabla item_en_inventario

CREATE PROCEDURE SP_Insert_Inv
@ID_entidad int,
@ID_item int
AS BEGIN
INSERT INTO item_en_inventario(ID_entidad, ID_Item) VALUES
(@ID_entidad, @ID_item)
END;
GO

CREATE PROCEDURE SP_Update_Inv
@ID_entidad int,
@ID_item int 
AS BEGIN
UPDATE item_en_inventario
SET ID_Item = @ID_Item
WHERE ID_entidad = @ID_entidad
END;
GO

CREATE PROCEDURE SP_Delete_Inv
@ID_entidad int
AS BEGIN
DELETE FROM item_en_inventario
WHERE ID_entidad = @ID_entidad
END;

GO;


--Tabla NPC

CREATE PROCEDURE SP_Insert_NPC
@ID_vendedor int,
AS BEGIN
INSERT INTO Vendedor_NPC(ID_Vendedor) VALUES
(@ID_vendedor)
END;

GO;

CREATE PROCEDURE SP_Update_NPC
@ID_vendedor int,
AS BEGIN
UPDATE Vendedor_NPC
WHERE ID_Vendedor = @ID_Vendedor
END;

GO;

CREATE PROCEDURE SP_Delete_NPC
@ID_vendedor int
AS BEGIN
DELETE FROM Vendedor_NPC
WHERE ID_Vendedor = @ID_Vendedor
END;

GO;