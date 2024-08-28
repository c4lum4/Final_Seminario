create database seminario ;

use seminario


-- Tabla propietarios
CREATE TABLE propietarios (
    PK_propietario_ID INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(20) NOT NULL,
    apellido VARCHAR(20) NOT NULL,
    direccion VARCHAR(50),
    telefono VARCHAR(20),
    genero VARCHAR(10) NOT NULL,
	email VARCHAR(50) NOT NULL,
	contraseña VARCHAR(20) NOT NULL
);

select * from propietarios;

truncate table propietarios;


-- Tabla propiedades
CREATE TABLE propiedades (
    PK_propiedad_ID INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(20) NOT NULL,
	barrio varchar(20) NOT NULL,
    direccion VARCHAR(50) NOT NULL,
	estado varchar(20) NOT NULL,
    tamano int NOT NULL,
    tipo varchar(20) not null,
	FK_propietario_ID INT NOT NULL,
    CONSTRAINT FK_propietario_fk FOREIGN KEY (FK_propietario_ID) REFERENCES propietarios(PK_propietario_ID)

);
update propiedades set estado = 'Disponible' where PK_propiedad_ID = 2;


insert into propiedades (nombre, barrio, direccion, estado, tamano, tipo,FK_propietario_ID, PK_propiedad_ID) values ('Depto1', 'Caballito', 'Av Sarmiento 243', 'Disponible', 123, 'Oficina',2,-1);
insert into propiedades (nombre, barrio, direccion, estado, tamano, tipo,FK_propietario_ID, PK_propiedad_ID) values ('Claro', 'Recoleta', 'Av Sarmiento 243', 'Disponible', 123, 'Oficina',2,1);

select  * from propiedades;

delete from propiedades where PK_propiedad_ID =10;

drop table propiedades;

truncate table propiedades;

CREATE TABLE personal (
    PK_personal_ID INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(20) NOT NULL,
    apellido VARCHAR(20) NOT NULL,    
    barrio VARCHAR(25) NOT NULL,
    calificación FLOAT(5),
	disponible bit default 1
);

-- Lista de nombres y apellidos para las entradas
DECLARE @nombres TABLE (nombre VARCHAR(20));
DECLARE @apellidos TABLE (apellido VARCHAR(20));
DECLARE @barrios TABLE (barrio VARCHAR(25));

INSERT INTO @nombres VALUES ('Juan'), ('María'), ('Carlos'), ('Ana'), ('Luis'), ('Sofía'), ('Pedro'), ('Lucía'), ('Jorge'), ('Laura'),
                            ('Miguel'), ('Andrea'), ('Fernando'), ('Isabel'), ('Diego'), ('Gabriela'), ('Roberto'), ('Patricia'), ('Enrique'), ('Carmen'),
                            ('Raúl'), ('Julia'), ('Martín'), ('Rosa'), ('David'), ('Elena'), ('José'), ('Clara'), ('Alberto'), ('Marta'),
                            ('Ricardo'), ('Adriana'), ('Eduardo'), ('Verónica'), ('Manuel'), ('Silvia'), ('Alejandro'), ('Liliana'), ('Hernán'), ('Valeria'),
                            ('Pablo'), ('Lorena'), ('Javier'), ('Paula'), ('Santiago'), ('Beatriz'), ('Mariano'), ('Natalia'), ('Hugo'), ('Teresa');

INSERT INTO @apellidos VALUES ('Gómez'), ('Martínez'), ('López'), ('Rodríguez'), ('Pérez'), ('González'), ('Fernández'), ('García'), ('Sánchez'), ('Ramírez'),
                              ('Torres'), ('Flores'), ('Rivas'), ('Jiménez'), ('Castillo'), ('Rojas'), ('Vargas'), ('Morales'), ('Herrera'), ('Paredes'),
                              ('Reyes'), ('Cruz'), ('Ortega'), ('Castro'), ('Soto'), ('Rivera'), ('Vega'), ('Mendoza'), ('Guerrero'), ('Campos'),
                              ('Benítez'), ('Luna'), ('Silva'), ('Ramos'), ('Romero'), ('Ortiz'), ('Delgado'), ('Medina'), ('Cabrera'), ('Hernández'),
                              ('Cordero'), ('Rosales'), ('Quintero'), ('Blanco'), ('Mora'), ('Mejía'), ('Reynoso'), ('Bermúdez'), ('Bustos'), ('Ávila');

INSERT INTO @barrios VALUES ('Palermo'), ('Recoleta'), ('Belgrano'), ('Caballito'), ('Villa Urquiza'), ('San Telmo'), ('Villa Crespo'), ('Puerto Madero'), ('Almagro'), ('Boedo'), ('San Nicolás'), ('Montserrat'), ('Flores'), ('Retiro'), ('Chacarita'), ('Villa Devoto'), ('Villa del Parque'), ('Parque Patricios'), ('La Boca'), ('Barracas');

-- Variables para los bucles
DECLARE @nombre VARCHAR(20);
DECLARE @apellido VARCHAR(20);
DECLARE @barrio VARCHAR(25);
DECLARE @i INT = 1;
DECLARE @empleadosPorBarrio INT;

-- Genera las entradas
WHILE @i <= 50
BEGIN
    -- Selecciona un nombre y un apellido aleatorio
    SELECT TOP 1 @nombre = nombre FROM @nombres ORDER BY NEWID();
    SELECT TOP 1 @apellido = apellido FROM @apellidos ORDER BY NEWID();
    
    -- Selecciona un barrio aleatorio y cuenta cuántos empleados tiene actualmente
    SELECT TOP 1 @barrio = barrio FROM @barrios ORDER BY NEWID();
    SET @empleadosPorBarrio = (SELECT COUNT(*) FROM personal WHERE barrio = @barrio);
    
    -- Asegura que haya entre 2 y 5 empleados por barrio
    IF @empleadosPorBarrio < 5
    BEGIN
        INSERT INTO personal (nombre, apellido, barrio, calificación) 
        VALUES (@nombre, @apellido, @barrio, NULL);
        SET @i = @i + 1;
    END
    ELSE
    BEGIN
        -- Seleccionar otro barrio que tenga menos de 5 empleados
        SELECT TOP 1 @barrio = barrio 
        FROM @barrios b
        WHERE NOT EXISTS (
            SELECT 1
            FROM personal p
            WHERE p.barrio = b.barrio
            GROUP BY p.barrio
            HAVING COUNT(*) >= 5
        )
        ORDER BY NEWID();
    END
END;

select * from personal 
UPDATE personal
SET disponible = 1;


SELECT distinct barrio
from personal

SELECT TOP 1 *
FROM personal
WHERE barrio = 'Caballito' AND disponible = 1;

-- Tabla limpiezas
CREATE TABLE limpiezas (
    PK_limpieza_ID INT IDENTITY(1,1) PRIMARY KEY,
    FK_propiedad_ID INT NOT NULL,
	FK_empleado_ID INT not null,
    valor FLOAT(10) NOT NULL,
    fecha VARCHAR (20) NOT NULL,
    modo VARCHAR(20),
    estado VARCHAR(20),
	calificacion INT,
	calificar varchar(20) default 'No calificada',
    CONSTRAINT FK_limpieza_propiedad_fk FOREIGN KEY (FK_propiedad_ID) REFERENCES propiedades(PK_propiedad_ID),
	CONSTRAINT FK_limpieza_empleado_fk FOREIGN KEY (FK_empleado_ID) REFERENCES personal(PK_personal_ID)
);

select * from limpiezas;

drop table limpiezas;

truncate table limpiezas;

update limpiezas set calificar = 'No calificada' where PK_limpieza_ID = 1;

SELECT FK_propiedad_ID, FK_empleado_ID, fecha, valor FROM limpiezas

-- Tabla personal_x_limpieza
CREATE TABLE personal_x_limpieza (
    PK_personal_x_limpieza INT NOT NULL PRIMARY KEY,
    FK_personal_ID INT NOT NULL,
    FK_limpieza_ID INT NOT NULL,
    CONSTRAINT FK_personal_limpieza_personal_fk FOREIGN KEY (FK_personal_ID) REFERENCES personal(PK_personal_ID),
    CONSTRAINT FK_personal_limpieza_limpieza_fk FOREIGN KEY (FK_limpieza_ID) REFERENCES limpiezas(PK_limpieza_ID)
);

-- Tabla facturas
CREATE TABLE facturas (
    PK_factura_ID INT NOT NULL PRIMARY KEY,
    FK_limpieza_ID INT NOT NULL,
    monto FLOAT(10) NOT NULL,
    fecha_pago DATE NOT NULL,
    CONSTRAINT FK_factura_limpieza_fk FOREIGN KEY (FK_limpieza_ID) REFERENCES limpiezas(PK_limpieza_ID)
);

-- Tabla user_log
CREATE TABLE user_log (
    PK_user_ID INT NOT NULL PRIMARY KEY,
    FK_propietario_ID INT NOT NULL,
    nombre_usuario VARCHAR(20) NOT NULL,
    contrasena VARCHAR(20) NOT NULL,
    correo VARCHAR(30) NOT NULL,
    CONSTRAINT FK_user_propietario_fk FOREIGN KEY (FK_propietario_ID) REFERENCES propietarios(PK_propietario_ID)
);

-- Tabla logo_notificaciones
CREATE TABLE logo_notificaciones (
    PK_logo_notificacion_ID INT NOT NULL PRIMARY KEY,
    logo VARBINARY(MAX) NOT NULL
);

-- Tabla notificaciones
CREATE TABLE notificaciones (
    PK_notificacion_ID INT NOT NULL PRIMARY KEY,
    FK_propietario_ID INT NOT NULL,
    descripcion VARCHAR(50),
    FK_logo_notificacion_ID INT NOT NULL,
    CONSTRAINT FK_notificacion_propietario_fk FOREIGN KEY (FK_propietario_ID) REFERENCES propietarios(PK_propietario_ID),
    CONSTRAINT FK_logo_notificacion_fk FOREIGN KEY (FK_logo_notificacion_ID) REFERENCES logo_notificaciones(PK_logo_notificacion_ID)
);

-- Tabla foto_perfil_personal
CREATE TABLE foto_perfil_personal (
    PK_imagen_id INT NOT NULL PRIMARY KEY,
    FK_personal_ID INT NOT NULL,
    imagen VARBINARY(MAX) NOT NULL,
    CONSTRAINT FK_personal_fk FOREIGN KEY (FK_personal_ID) REFERENCES personal(PK_personal_ID)
);

-- Tabla foto_perfil_propietario
CREATE TABLE foto_perfil_propietario (
    PK_imagen_id INT NOT NULL PRIMARY KEY,
    FK_propietario_ID INT NOT NULL,
    imagen VARBINARY(MAX) NOT NULL,
    CONSTRAINT FK_foto_propietario FOREIGN KEY (FK_propietario_ID) REFERENCES propietarios(PK_propietario_ID)
);

-- Tabla imagenes_propiedad
CREATE TABLE imagenes_propiedad (
    PK_imagen_id INT NOT NULL PRIMARY KEY,
    FK_propiedad_ID INT NOT NULL,
    imagen VARBINARY(MAX) NOT NULL,
    CONSTRAINT FK_propiedad_fk FOREIGN KEY (FK_propiedad_ID) REFERENCES propiedades(PK_propiedad_ID)
);