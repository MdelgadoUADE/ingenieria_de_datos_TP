
--Tablas
CREATE TABLE Inventario(
ID_Jugador INT PRIMARY KEY,
ID_Item INT NOT NULL,
CONSTRAINT FK_IDjug_Inv
FOREIGN KEY (ID_Jugador) REFERENCES Jugador(ID_Jugador)
CONSTRAINT FK_IDitem_Inv
FOREIGN KEY (ID_Item) REFERENCES Item(ID_Item)
);

CREATE TABLE Vendedor_NPC(
ID_Vendedor INT PRIMARY KEY
CONSTRAINT CH_NPC_5dig
CHECK (ID_Vendedor BETWEEN 10000 AND 99999)
);


CREATE TABLE Gremio
(
	ID_Gremio INT PRIMARY KEY CHECK (ID_Gremio BETWEEN 100 AND 999),
	Nombre_Gremio VARCHAR(50),
	Fondo DECIMAL(10,2),
	ID_Lider INT  
)
GO

CREATE TABLE Administrador
(
    ID_Jugador INT PRIMARY KEY,
    Nombre_Admin VARCHAR(50)

)

ALTER TABLE Administrador
ADD CONSTRAINT FK_Jugador_Admin
FOREIGN KEY (ID_Jugador)
REFERENCES Jugador(ID_Jugador)
GO

ALTER TABLE Gremio
ADD CONSTRAINT FK_Jugador_Gremio
FOREIGN KEY (ID_Lider)
REFERENCES Jugador(ID_Jugador)
GO




--Procedimientos

--Tabla Gremio

CREATE PROCEDURE Insertar_Gremio

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

@ID_Jugador INT,
@Nombre_Admin VARCHAR(50)

AS
BEGIN
    INSERT INTO Administrador (ID_Jugador, Nombre_Admin)
    VALUES (@ID_Jugador, @Nombre_Admin)
END
GO


CREATE PROCEDURE Modificar_Admin

@ID_Jugador INT,
@Nombre_Admin VARCHAR(50)

AS
BEGIN
    UPDATE Administrador
    SET Nombre_Admin = @Nombre_Admin
    WHERE ID_Jugador = @ID_Jugador
END
GO

CREATE PROCEDURE EliminarAdmin

@ID_Jugador INT

AS
BEGIN
    DELETE FROM Administrador
    WHERE ID_Jugador = @ID_Jugador
END
GO


--Tabla inventario

CREATE PROCEDURE SP_Insert_Inv
@ID_jugador int,
@ID_item int
AS BEGIN
INSERT INTO Inventario(ID_Jugador, ID_Item) VALUES
(@ID_jugador, @ID_item)
END;
GO

CREATE PROCEDURE SP_Update_Inv
@ID_jugador int,
@ID_item int 
AS BEGIN
UPDATE Inventario
SET ID_Jugador = @ID_jugador
WHERE ID_Item = @ID_item
END;
GO

CREATE PROCEDURE SP_Delete_Inv
@ID_jugador int
AS BEGIN
DELETE FROM Inventario
WHERE ID_jugador = @ID_jugador
END;
GO


--Tabla NPC

CREATE PROCEDURE SP_Insert_NPC
@ID_vendedor int,
AS BEGIN
INSERT INTO Vendedor_NPC(ID_Vendedor) VALUES
(@ID_vendedor)
END;
GO


CREATE PROCEDURE SP_Update_NPC
@ID_vendedor int,
AS BEGIN
UPDATE Vendedor_NPC
WHERE ID_Vendedor = @ID_Vendedor
END;
GO


CREATE PROCEDURE SP_Delete_NPC
@ID_vendedor int
AS BEGIN
DELETE FROM Vendedor_NPC
WHERE ID_Vendedor = @ID_Vendedor
END;
GO
