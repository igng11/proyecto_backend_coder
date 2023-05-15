CREATE TABLE usuarios (
  id INT(11) NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(255),
  email VARCHAR(255) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE aves (
  id INT(11) NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(255),
  color_principal VARCHAR(50) NOT NULL UNIQUE,
  tamaño VARCHAR(50),
  descripcion TEXT,
  id_usuario INT(11),
  PRIMARY KEY (id),
  FOREIGN KEY (id_usuario) REFERENCES usuarios(id)
);

CREATE TABLE avistamientos (
  id INT(11) NOT NULL AUTO_INCREMENT,
  id_usuario INT(11) NOT NULL,
  id_ave INT(11) NOT NULL,
  fecha DATE NOT NULL,
  hora TIME,
  ubicacion DECIMAL(10,6),
  notas TEXT,
  PRIMARY KEY (id),
  FOREIGN KEY (id_usuario) REFERENCES aves(id),
  FOREIGN KEY (id_ave) REFERENCES usuarios(id)
);

// insertar tabla usuarios

INSERT INTO usuarios (nombre, email, password) VALUES
('Juan Pérez', 'juanperez@example.com', 'abc123'),
('María López', 'marialopez@example.com', 'password01'),
('Carlos Ruiz', 'carlosruiz@example.com', 'securepass'),
('Ana García', 'anagarcia@example.com', 'secret123'),
('Luis Torres', 'luistorres@example.com', 'mypass123'),
('Laura Vega', 'lauravega@example.com', '12345678'),
('Pablo Soto', 'pablosoto@example.com', 'pass1234'),
('Andrea Díaz', 'andreadiaz@example.com', 'mypass'),
('David Gómez', 'davidgomez@example.com', 'qwerty123'),
('Isabel Pérez', 'isabelperez@example.com', 'secretpass');

// insertar tabla aves

INSERT INTO aves (nombre, color_principal, tamanio, descripcion) VALUES
('Paloma', 'Gris o marrón', 'Pequeño', 'Ave urbana común'),
('Tero', 'Rojo y negro', 'Mediano', 'Cantor de agua'),
('Zorzal', 'Marrón', 'Mediano', 'Pájaro de jardín'),
('Hornero', 'Marrón rojizo', 'Pequeño', 'Construye nidos de barro'),
('Garza', 'Blanca y negra', 'Grande', 'Ave acuática'),
('Ratonera', 'Marrón y gris', 'Pequeño', 'Cazadora de roedores'),
('Gorrión', 'Marrón', 'Pequeño', 'Ave de jardín común'),
('Cardenal', 'Rojo brillante', 'Mediano', 'Pájaro de jardín'),
('Búho', 'Marrón y blanco', 'Mediano', 'Ave nocturna'),
('Aguilucho', 'Marrón y blanco', 'Grande', 'Ave de presa');

// insertar tabla avistamientos

INSERT INTO avistamientos (id_usuario, id_ave, fecha, hora, ubicacion, notas) VALUES
(1, 2, '2022-03-14', '09:15:00', '40.4165, -3.7026', 'Avistado en el parque de la ciudad'),
(2, 7, '2022-05-22', '14:30:00', '37.9838, -1.1282', 'Avistado en las montañas'),
(3, 5, '2022-01-07', '16:45:00', '51.5074, -0.1278', 'Avistado en un jardín público'),
(4, 3, '2022-06-01', '10:00:00', '19.4326, -99.1332', 'Avistado en un parque nacional'),
(5, 6, '2022-04-18', '20:00:00', '39.9042, 116.4074', 'Avistado en un bosque'),
(6, 1, '2022-02-12', '06:30:00', '35.6895, 139.6917', 'Avistado en un lago'),
(7, 9, '2022-07-08', '12:15:00', '51.7520, -1.2577', 'Avistado en un zoológico'),
(8, 4, '2022-08-05', '18:00:00', '51.5074, -0.1278', 'Avistado en una playa'),
(9, 10, '2022-09-03', '07:00:00', '41.3851, 2.1734', 'Avistado en un jardín botánico'),
(10, 8, '2022-10-20', '15:00:00', '45.4642, 9.1900', 'Avistado en un puerto pesquero');

// Vista de avistamientos en parques ordenados por fecha y hora de avistamiento
CREATE VIEW avistamientos_parques AS 
SELECT * FROM avistamientos
WHERE ubicacion LIKE '%parque%' 
ORDER BY fecha_avistamiento DESC, hora_avistamiento DESC;

// Vista que muestra los avistamientos registrados en Montevideo:
CREATE VIEW vistas_montevideo AS
SELECT *
FROM avistamientos
WHERE lugar = 'Montevideo';

// Vista que muestra los avistamientos registrados entre las 12:00 y las 18:00 horas:
CREATE VIEW vistas_mediodia AS
SELECT *
FROM avistamientos
WHERE hora BETWEEN '12:00:00' AND '18:00:00';

// Vista que muestra los avistamientos registrados en el año 2022:
CREATE VIEW avistameintos_2022 AS
SELECT *
FROM avistamientos
WHERE YEAR(fecha) = 2022;

// Vista de avistamientos en la costa, ordenados por fecha y hora de avistamiento
CREATE VIEW avistamientos_costa AS 
SELECT * FROM avistamientos
WHERE ubicacion LIKE '%playa%' OR ubicacion LIKE '%puerto%'
ORDER BY fecha_avistamiento DESC, hora_avistamiento DESC;

//FUNCIONES
// función calcular_edad toma como argumento una fecha de nacimiento y devuelve la edad en años utilizando la función YEAR de MySQL y la función CURRENT_DATE para obtener la fecha actual.

DELIMITER //
CREATE FUNCTION calcular_edad(fecha_nacimiento DATE) RETURNS INT
BEGIN
    RETURN YEAR(CURRENT_DATE()) - YEAR(fecha_nacimiento) - (RIGHT(CURRENT_DATE(), 5) < RIGHT(fecha_nacimiento, 5));
END //
DELIMITER ;

// función obtener_nombre_usuario toma como argumento un ID de usuario y devuelve el nombre del usuario correspondiente utilizando una consulta SELECT en la tabla usuarios.

DELIMITER //
CREATE FUNCTION obtener_nombre_usuario(id_usuario INT) RETURNS VARCHAR(255)
BEGIN
    DECLARE nombre_usuario VARCHAR(255);
    SELECT nombre INTO nombre_usuario FROM usuarios WHERE id = id_usuario;
    RETURN nombre_usuario;
END //
DELIMITER ;

//STORED PROCEDURE

DELIMITER //

CREATE PROCEDURE ordenar_por_campo(IN tabla VARCHAR(50), IN campo VARCHAR(50), IN orden VARCHAR(10))
BEGIN
  SET @query = CONCAT('SELECT * FROM ', tabla, ' ORDER BY ', campo, ' ', orden);
  PREPARE stmt FROM @query;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;
END //

DELIMITER ;

/* recibe tres parámetros: el nombre de la tabla que se desea ordenar, el nombre del campo por el cual se desea ordenar y el tipo de ordenamiento (ASC o DESC). El stored procedure construye dinámicamente la consulta utilizando los parámetros y la ejecuta mediante la sentencia PREPARE, EXECUTE y DEALLOCATE*/

DELIMITER //

CREATE PROCEDURE insertar_aves(IN nombre_ave VARCHAR(50), IN especie VARCHAR(50), IN fecha_avistamiento DATE, IN id_usuario INT)
BEGIN
  INSERT INTO aves(nombre_ave, especie, fecha_avistamiento, id_usuario) VALUES(nombre_ave, especie, fecha_avistamiento, id_usuario);
END //

DELIMITER ;
/* recibe cuatro parámetros: el nombre de la ave, la especie, la fecha del avistamiento y el ID del usuario que reportó el avistamiento. El stored procedure inserta un registro en la tabla de aves con los valores proporcionados*/


/* CREACION DE TABLAS LOG */

CREATE TABLE usuarios_log (
id INT(11) NOT NULL AUTO_INCREMENT,
id_usuario INT(11) NOT NULL,
nombre_anterior VARCHAR(255),
nombre_nuevo VARCHAR(255),
email_anterior VARCHAR(255),
email_nuevo VARCHAR(255),
password_anterior VARCHAR(255),
password_nuevo VARCHAR(255),
accion VARCHAR(10) NOT NULL,
usuario_registro VARCHAR(255),
fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY (id)
);

CREATE TABLE avistamientos_log (
id INT(11) NOT NULL AUTO_INCREMENT,
id_avistamiento INT(11) NOT NULL,
id_usuario_anterior INT(11),
id_usuario_nuevo INT(11),
id_ave_anterior INT(11),
id_ave_nuevo INT(11),
fecha_anterior DATE,
fecha_nueva DATE,
hora_anterior TIME,
hora_nueva TIME,
ubicacion_anterior DECIMAL(10,6),
ubicacion_nueva DECIMAL(10,6),
notas_anterior TEXT,
notas_nueva TEXT,
accion VARCHAR(10) NOT NULL,
usuario_registro VARCHAR(255),
fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY (id)
);


/* Trigger que se activa antes de una operación de actualización (BEFORE UPDATE) en la tabla "usuarios" y registra la información anterior del usuario en la tabla "usuarios_log". */

CREATE TRIGGER usuarios_before_update
BEFORE UPDATE ON usuarios
FOR EACH ROW
BEGIN
DECLARE registro_usuario VARCHAR(255);
SELECT user() INTO registro_usuario;
INSERT INTO usuarios_log (id_usuario, nombre_anterior, email_anterior, password_anterior, accion, usuario_registro)
VALUES (OLD.id, OLD.nombre, OLD.email, OLD.password, 'UPDATE', registro_usuario);
END;


* Trigger que se activa después de una operación de actualización (AFTER UPDATE) en la tabla "usuarios" y registra la información nueva del usuario en la tabla "usuarios_log"*/

CREATE TRIGGER usuarios_after_update
AFTER UPDATE ON usuarios
FOR EACH ROW
BEGIN
DECLARE registro_usuario VARCHAR(255);
SELECT user() INTO registro_usuario;
INSERT INTO usuarios_log (id_usuario, nombre_nuevo, email_nuevo, password_nuevo, accion, usuario_registro)
VALUES (NEW.id, NEW.nombre, NEW.email, NEW.password, 'UPDATE', registro_usuario);
END;

/* Trigger que se activa antes de una operación de actualización (BEFORE UPDATE) en la tabla "avistamientos" y registra la información anterior del avistamiento en la tabla "avistamientos_log" */

CREATE TRIGGER avistamientos_before_update
BEFORE UPDATE ON avistamientos
FOR EACH ROW
BEGIN
SET NEW.updated_by = CURRENT_USER();
SET NEW.updated_at = NOW();
INSERT INTO avistamientos_log (id_avistamiento, id_usuario_anterior, id_usuario_nuevo, id_ave_anterior, id_ave_nuevo, fecha_anterior, fecha_nueva, hora_anterior, hora_nueva, ubicacion_anterior, ubicacion_nueva, notas_anterior, notas_nueva, accion)
VALUES (OLD.id, OLD.id_usuario, NEW.id_usuario, OLD.id_ave, NEW.id_ave, OLD.fecha, NEW.fecha, OLD.hora, NEW.hora, OLD.ubicacion, NEW.ubicacion, OLD.notas, NEW.notas, 'UPDATE');
END;


/* Trigger que se activa después de una operación de actualización (AFTER UPDATE) en la tabla "avistamientos" y registra la información nueva del avistamiento en la tabla "avistamientos_log" */

CREATE TRIGGER avistamientos_after_update
AFTER UPDATE ON avistamientos
FOR EACH ROW
BEGIN
INSERT INTO avistamientos_log (id_avistamiento, id_usuario_anterior, id_usuario_nuevo, id_ave_anterior, id_ave_nuevo, fecha_anterior, fecha_nueva, hora_anterior, hora_nueva, ubicacion_anterior, ubicacion_nueva, notas_anterior, notas_nueva, accion)
VALUES (NEW.id, OLD.id_usuario, NEW.id_usuario, OLD.id_ave, NEW.id_ave, OLD.fecha, NEW.fecha, OLD.hora, NEW.hora, OLD.ubicacion, NEW.ubicacion, OLD.notas, NEW.notas, 'UPDATE');
END;