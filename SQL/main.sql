CREATE DATABASE main_runescape

USE main_runescape
GO;

CREATE TABLE ITEM(
    ID_item INT PRIMARY KEY,
    grado INT NOT NULL DEFAULT 1,
    tipo VARCHAR(20) NOT NULL,
    valor INT DEFAULT 0,
    propietario INT,
    propiedades VARCHAR(50),

    CONSTRAINT CHK_grado CHECK (grado > 0 AND grado <= 70)
)

CREATE TABLE JUGADORES(
    ID_jugador INT PRIMARY KEY,
    nombre_usuario VARCHAR(20),
    oro_disponible INT,
    ID_gremio INT,

    CONSTRAINT CHK_oro_disponible CHECK (oro_disponible > 0),

    CONSTRAINT FK_ID_gremio FOREIGN KEY (ID_gremio) 
    REFERENCES GREMIO(ID_gremio)
)


