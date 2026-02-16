--- CREACION DE TABLAS ---

CREATE TABLE Gremio
(
	ID_Gremio INT PRIMARY KEY CHECK (ID_Gremio BETWEEN 100 AND 999),
	Nombre_Gremio VARCHAR(50),
	Fondo DECIMAL(10,2),
	ID_Lider INT  
)
GO

CREATE TABLE Admin
(
    ID_Jugador INT PRIMARY KEY,
    Nombre_Admin VARCHAR(50)

)

ALTER TABLE Admin
ADD CONSTRAINT FK_Jugador_Admin
FOREIGN KEY (ID_Jugador)
REFERENCES Jugador(ID_Jugador)
GO

ALTER TABLE Gremio
ADD CONSTRAINT FK_Jugador_Gremio
FOREIGN KEY (ID_Lider)
REFERENCES Jugador(ID_Jugador)
GO



--- PROCEDURES GREMIO ---
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



--- PROCEDURES Admin ---

CREATE PROCEDURE Insertar_Admin

@ID_Jugador INT,
@Nombre_Admin VARCHAR(50)

AS
BEGIN
    INSERT INTO Admin (ID_Jugador, Nombre_Admin)
    VALUES (@ID_Jugador, @Nombre_Admin)
END
GO


CREATE PROCEDURE Modificar_Admin

@ID_Jugador INT,
@Nombre_Admin VARCHAR(50)

AS
BEGIN
    UPDATE Admin
    SET Nombre_Admin = @Nombre_Admin
    WHERE ID_Jugador = @ID_Jugador
END
GO

CREATE PROCEDURE EliminarAdmin

@ID_Jugador INT

AS
BEGIN
    DELETE FROM Admin
    WHERE ID_Jugador = @ID_Jugador
END
GO




