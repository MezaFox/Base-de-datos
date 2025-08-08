DROP DATABASE IF exists biblioteca;
CREATE DATABASE IF NOT EXISTS biblioteca;
USE biblioteca;

-- creacion de tablas 

CREATE TABLE libros 
(id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    id_categoria INT,
    anio_publicacion INT,
    isbn VARCHAR(20) UNIQUE,
    editorial VARCHAR(150));
    
    

    
    CREATE TABLE autores 
    (id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL);
    
    CREATE TABLE categorias 
    (id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE);
    
    CREATE TABLE ejemplares 
    (id INT AUTO_INCREMENT PRIMARY KEY,
    id_libro INT NOT NULL,
    cantidad INT NOT NULL DEFAULT 1,
    estado ENUM('disponible', 'prestado', 'deteriorado') DEFAULT 'disponible');
    
    CREATE TABLE usuarios 
    (id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    tipo ENUM('estudiante', 'docente') NOT NULL,
    email VARCHAR(100) UNIQUE);
    
    CREATE TABLE prestamos 
    (id INT AUTO_INCREMENT PRIMARY KEY,
    id_ejemplar INT NOT NULL,
    id_usuario INT NOT NULL,
    id_empleado INT NOT NULL,
    fecha_prestamo DATE NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    fecha_devolucion DATE);
    
    CREATE TABLE devoluciones 
    (id INT AUTO_INCREMENT PRIMARY KEY,
    id_prestamo INT NOT NULL,
    fecha_devolucion DATE NOT NULL,
    observaciones TEXT);
 
 
 -- creacion de trigger para actualizar la tabla de fecha de prestamos
    CREATE TRIGGER after_devolucion_insert
AFTER INSERT ON devoluciones
FOR EACH ROW
BEGIN
    UPDATE prestamos
    SET fecha_devolucion = NEW.fecha_devolucion
    WHERE id = NEW.id_prestamo
END $$
DELIMITER ;
    
    CREATE TABLE empleados 
    (id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    puesto VARCHAR(50));
    -- agregamos que los usuarios tenga contraseña
    ALTER TABLE empleados 
ADD COLUMN typeuser VARCHAR(50) UNIQUE,
ADD COLUMN usuario VARCHAR(50) UNIQUE,
ADD COLUMN password VARCHAR(255);


    
    
    -- Relación muchos a muchos entre libros y autores
    
    CREATE TABLE libro_autor (
    id_libro INT,
    id_autor INT);
    
    
-- indices que pide el proyecto

CREATE INDEX idx_titulo_libro ON libros(titulo);
CREATE INDEX idx_id_autor ON libro_autor(id_autor);
CREATE INDEX idx_id_usuario ON prestamos(id_usuario);

-- creacion de llaves foreanas



-- llave foreana de libros
ALTER TABLE libros
ADD CONSTRAINT fk_libros_categoria
FOREIGN KEY (id_categoria) REFERENCES categorias(id);


-- llave foreana de libro_autor
ALTER TABLE libro_autor
ADD CONSTRAINT fk_libro_autor_libro
FOREIGN KEY (id_libro) REFERENCES libros(id);


ALTER TABLE libro_autor
ADD CONSTRAINT fk_libro_autor_autor
FOREIGN KEY (id_autor) REFERENCES autores(id);

-- llave foreana de ejemplares
ALTER TABLE ejemplares
ADD CONSTRAINT fk_ejemplares_libro
FOREIGN KEY (id_libro) REFERENCES libros(id);

-- llave foreana de prestamos
ALTER TABLE prestamos
ADD CONSTRAINT fk_prestamos_ejemplar
FOREIGN KEY (id_ejemplar) REFERENCES ejemplares(id);

ALTER TABLE prestamos
ADD CONSTRAINT fk_prestamos_usuario
FOREIGN KEY (id_usuario) REFERENCES usuarios(id);

ALTER TABLE prestamos
ADD CONSTRAINT fk_prestamos_empleado
FOREIGN KEY (id_empleado) REFERENCES empleados(id);


-- lave foreana de devoluciones
ALTER TABLE devoluciones
ADD CONSTRAINT fk_devoluciones_prestamo
FOREIGN KEY (id_prestamo) REFERENCES prestamos(id);


-- AGREGANDO DATOS A LAS TABLAS

-- INSERT A LA TABLA DE GENEROS
INSERT INTO categorias (nombre) VALUES
('Ficción'),
('No Ficción'),
('Ciencia Ficción'),
('Fantasía'),
('Misterio'),
('Romance'),
('Aventura'),
('Biografía'),
('Historia'),
('Poesía'),
('Drama'),
('Terror'),
('Autoayuda'),
('Infantil'),
('Juvenil'),
('Clásicos'),
('Cómics'),
('Educativo');

select * from biblioteca.libros;

-- agregando datos a la tabla libros
INSERT INTO libros (titulo, id_categoria, anio_publicacion, editorial) VALUES
-- Miguel de Cervantes (Ficción)
('Don Quijote de la Mancha', 1, 1605, 'Francisco de Robles'),
('La Galatea', 1, 1585, 'Juan Gracián'),
('Novelas ejemplares', 1, 1613, 'Juan de la Cuesta'),
('Los trabajos de Persiles y Sigismunda', 1, 1617, 'Juan de la Cuesta'),
('La Numancia', 11, 1582, 'Juan de la Cuesta'), -- Drama

-- Gabriel García Márquez (Ficción)
('Cien años de soledad', 1, 1967, 'Editorial Sudamericana'),
('El amor en los tiempos del cólera', 1, 1985, 'Editorial Oveja Negra'),
('Crónica de una muerte anunciada', 1, 1981, 'Editorial Oveja Negra'),
('El otoño del patriarca', 1, 1975, 'Editorial Sudamericana'),
('El coronel no tiene quien le escriba', 1, 1961, 'Editorial Sudamericana'),

-- Jorge Luis Borges (Ficción, Poesía, Clásicos)
('Ficciones', 1, 1944, 'Editorial Sur'),
('El Aleph', 1, 1949, 'Editorial Losada'),
('El libro de arena', 1, 1975, 'Editorial Emecé'),
('Seis problemas para don Isidro Parodi', 5, 1942, 'Editorial Sur'), -- Misterio
('Historia universal de la infamia', 1, 1935, 'Editorial Tor'),

-- Isabel Allende (Ficción, Fantasía, Juvenil)
('La casa de los espíritus', 1, 1982, 'Editorial Plaza & Janés'),
('De amor y de sombra', 1, 1984, 'Editorial Plaza & Janés'),
('Eva Luna', 1, 1987, 'Editorial Plaza & Janés'),
('Paula', 2, 1994, 'Editorial Plaza & Janés'), -- No Ficción (memorias)
('La ciudad de las bestias', 14, 2002, 'Editorial Montena'), -- Juvenil

-- Mario Vargas Llosa (Ficción)
('La ciudad y los perros', 1, 1963, 'Editorial Seix Barral'),
('La casa verde', 1, 1966, 'Editorial Seix Barral'),
('Conversación en La Catedral', 1, 1969, 'Editorial Seix Barral'),
('Pantaleón y las visitadoras', 1, 1973, 'Editorial Seix Barral'),
('La fiesta del chivo', 1, 2000, 'Editorial Alfaguara'),

-- George R. R. Martin (Fantasía)
('Juego de tronos', 4, 1996, 'Bantam Books'),
('Choque de reyes', 4, 1998, 'Bantam Books'),
('Tormenta de espadas', 4, 2000, 'Bantam Books'),
('Festín de cuervos', 4, 2005, 'Bantam Books'),
('Danza de dragones', 4, 2011, 'Bantam Books'),

-- Haruki Murakami (Ficción)
('Kafka en la orilla', 1, 2002, 'Kodansha'),
('Tokio Blues', 1, 1987, 'Kodansha'),
('Crónica del pájaro que da cuerda al mundo', 1, 1994, 'Shinchosha'),
('1Q84', 1, 2009, 'Shinchosha'),
('After Dark', 1, 2004, 'Kodansha'),

-- Stephen King (Terror, Ciencia Ficción, Clásicos)
('El resplandor', 11, 1977, 'Doubleday'), -- Terror
('It', 11, 1986, 'Viking Press'), -- Terror
('Carrie', 11, 1974, 'Doubleday'), -- Terror
('Cementerio de animales', 11, 1983, 'Doubleday'), -- Terror
('La torre oscura I: El pistolero', 3, 1982, 'Grant'), -- Ciencia Ficción

-- Julio Cortázar (Ficción, Clásicos)
('Rayuela', 1, 1963, 'Editorial Sudamericana'),
('Bestiario', 1, 1951, 'Editorial Sudamericana'),
('Final del juego', 1, 1956, 'Editorial Sudamericana'),
('Las armas secretas', 1, 1959, 'Editorial Sudamericana'),
('Todos los fuegos el fuego', 1, 1966, 'Editorial Sudamericana'),

-- George Orwell (Ciencia Ficción, Historia, Ficción)
('1984', 3, 1949, 'Secker & Warburg'), -- Ciencia Ficción
('Rebelión en la granja', 3, 1945, 'Secker & Warburg'), -- Ciencia Ficción
('Homenaje a Cataluña', 9, 1938, 'Secker & Warburg'), -- Historia
('Subir a por aire', 1, 1939, 'Victor Gollancz'),
('Los días de Birmania', 1, 1934, 'HarperCollins');


-- agregando datos a la tabla de autores
INSERT INTO autores (nombre, apellido) VALUES
('Miguel', 'de Cervantes'),
('Gabriel', 'García Márquez'),
('Jorge Luis', 'Borges'),
('Isabel', 'Allende'),
('Mario', 'Vargas Llosa'),
('George R. R.', 'Martin'),
('Haruki', 'Murakami'),
('Stephen', 'King'),
('Julio', 'Cortázar'),
('George', 'Orwell');


-- agregando datos a la tabla de libro_autor para unirlas
INSERT INTO libro_autor (id_libro, id_autor) VALUES
(1,1),(2,1),(3,1),(4,1),(5,1),
(6,2),(7,2),(8,2),(9,2),(10,2),
(11,3),(12,3),(13,3),(14,3),(15,3),
(16,4),(17,4),(18,4),(19,4),(20,4),
(21,5),(22,5),(23,5),(24,5),(25,5),
(26,6),(27,6),(28,6),(29,6),(30,6),
(31,7),(32,7),(33,7),(34,7),(35,7),
(36,8),(37,8),(38,8),(39,8),(40,8),
(41,9),(42,9),(43,9),(44,9),(45,9),
(46,10),(47,10),(48,10),(49,10),(50,10);


-- agregando datos a la tabla de usuarios
INSERT INTO usuarios (nombre, apellido, tipo, email) VALUES
('Ana', 'Ramírez', 'docente', 'ana.ramirez@escuela.edu'),
('Carlos', 'Gómez', 'docente', 'carlos.gomez@escuela.edu'),
('María', 'López', 'docente', 'maria.lopez@escuela.edu'),
('Javier', 'Martínez', 'docente', 'javier.martinez@escuela.edu'),
('Lucía', 'Fernández', 'docente', 'lucia.fernandez@escuela.edu'),
('Pedro', 'Sánchez', 'estudiante', 'pedro.sanchez@escuela.edu'),
('Sofía', 'Torres', 'estudiante', 'sofia.torres@escuela.edu'),
('Miguel', 'Castro', 'estudiante', 'miguel.castro@escuela.edu'),
('Valeria', 'Ruiz', 'estudiante', 'valeria.ruiz@escuela.edu'),
('Diego', 'Molina', 'estudiante', 'diego.molina@escuela.edu'),
('Elena', 'Vega', 'estudiante', 'elena.vega@escuela.edu'),
('Luis', 'Navarro', 'estudiante', 'luis.navarro@escuela.edu'),
('Camila', 'Silva', 'estudiante', 'camila.silva@escuela.edu'),
('Mateo', 'Pérez', 'estudiante', 'mateo.perez@escuela.edu'),
('Daniela', 'Ortega', 'estudiante', 'daniela.ortega@escuela.edu');

use biblioteca;

ALTER TABLE usuarios MODIFY tipo ENUM('estudiante','docente','visitante') NOT NULL;


INSERT INTO usuarios (nombre, apellido, tipo, email) 
VALUES ('Luis', 'Pérez', 'visitante', 'luis.perez@escuela.edu');


INSERT INTO usuarios (nombre, apellido, tipo, email) VALUES
('Dylan', 'Ramírez', 'visitante', 'dylan.ramirez@escuela.edu');

SELECT * FROM usuarios;

SELECT * FROM empleados;


INSERT INTO empleados (nombre, apellido, puesto) VALUES
('Roberto', 'Mendoza', 'Bibliotecario'),
('Patricia', 'Salinas', 'Auxiliar de Biblioteca'),
('Fernando', 'Reyes', 'Encargado de Préstamos'),
('Carmen', 'Soto', 'Recepcionista'),
('Jorge', 'Paredes', 'Catalogador'),
('Silvia', 'Morales', 'Encargada de Sala de Lectura'),
('Andrés', 'Vargas', 'Soporte Técnico'),
('Beatriz', 'Herrera', 'Limpieza'),
('Guillermo', 'Flores', 'Vigilancia'),
('Marina', 'Aguilar', 'Coordinadora');

-- agregando 10 unidades de cada ejemplar 
INSERT INTO ejemplares (id_libro, cantidad, estado) VALUES
(1, 10, 'disponible'),(2, 10, 'disponible'),(3, 10, 'disponible'),(4, 10, 'disponible'),(5, 10, 'disponible'),
(6, 10, 'disponible'),(7, 10, 'disponible'),(8, 10, 'disponible'),(9, 10, 'disponible'),(10, 10, 'disponible'),
(11, 10, 'disponible'),(12, 10, 'disponible'),(13, 10, 'disponible'),(14, 10, 'disponible'),(15, 10, 'disponible'),
(16, 10, 'disponible'),(17, 10, 'disponible'),(18, 10, 'disponible'),(19, 10, 'disponible'),(20, 10, 'disponible'),
(21, 10, 'disponible'),(22, 10, 'disponible'),(23, 10, 'disponible'),(24, 10, 'disponible'),(25, 10, 'disponible'),
(26, 10, 'disponible'),(27, 10, 'disponible'),(28, 10, 'disponible'),(29, 10, 'disponible'),(30, 10, 'disponible'),
(31, 10, 'disponible'),(32, 10, 'disponible'),(33, 10, 'disponible'),(34, 10, 'disponible'),(35, 10, 'disponible'),
(36, 10, 'disponible'),(37, 10, 'disponible'),(38, 10, 'disponible'),(39, 10, 'disponible'),(40, 10, 'disponible'),
(41, 10, 'disponible'),(42, 10, 'disponible'),(43, 10, 'disponible'),(44, 10, 'disponible'),(45, 10, 'disponible'),
(46, 10, 'disponible'),(47, 10, 'disponible'),(48, 10, 'disponible'),(49, 10, 'disponible'),(50, 10, 'disponible');


-- agregar datos a tabla de prestamos
INSERT INTO prestamos (id_ejemplar, id_usuario, id_empleado, fecha_prestamo, fecha_vencimiento, fecha_devolucion) VALUES
(12, 4, 3, '2025-01-12', '2025-02-11', '2025-02-05'),
(15, 8, 3, '2025-01-14', '2025-02-13', '2025-02-10'),
(18, 2, 3, '2025-01-17', '2025-02-16', '2025-02-12'),
(21, 13, 3, '2025-01-20', '2025-02-19', '2025-02-15'),
(24, 7, 3, '2025-01-22', '2025-02-21', '2025-02-18'),
(27, 9, 3, '2025-02-01', '2025-03-03', '2025-02-28'),
(30, 11, 3, '2025-02-03', '2025-03-05', '2025-03-01'),
(33, 6, 3, '2025-02-06', '2025-03-08', '2025-03-06'),
(36, 10, 3, '2025-02-09', '2025-03-11', '2025-03-10'),
(39, 12, 3, '2025-02-12', '2025-03-14', '2025-03-12'),
(42, 1, 3, '2025-03-01', '2025-03-31', '2025-03-25'),
(45, 5, 3, '2025-03-04', '2025-04-03', '2025-03-30'),
(48, 14, 3, '2025-03-07', '2025-04-06', '2025-04-02'),
(8, 15, 3, '2025-03-10', '2025-04-09', '2025-04-05'),
(17, 3, 3, '2025-03-13', '2025-04-12', '2025-04-09'),
(26, 7, 3, '2025-03-16', '2025-04-15', '2025-04-12'),
(35, 2, 3, '2025-03-19', '2025-04-18', '2025-04-14'),
(44, 6, 3, '2025-03-22', '2025-04-21', '2025-04-17'),
(5, 10, 3, '2025-03-25', '2025-04-24', '2025-04-20'),
(13, 13, 3, '2025-03-28', '2025-04-27', '2025-04-22'),
(12, 4, 3, '2025-01-12', '2025-02-11', '2025-02-05'),
(15, 8, 3, '2025-01-14', '2025-02-13', '2025-02-10'),
(18, 2, 3, '2025-01-17', '2025-02-16', '2025-02-12'),
(21, 13, 3, '2025-01-20', '2025-02-19', '2025-02-15'),
(24, 7, 3, '2025-01-22', '2025-02-21', '2025-02-18'),
(1, 1, 3, '2025-01-05', '2025-02-05', NULL),
(2, 2, 3, '2025-01-10', '2025-02-10', NULL),
(3, 3, 3, '2025-01-15', '2025-02-15', '2025-02-10'),
(4, 4, 3, '2025-01-20', '2025-02-20', NULL),  
(5, 5, 3, '2025-01-25', '2025-02-25', '2025-02-24'),
(6, 6, 3, '2025-02-01', '2025-03-01', NULL),   
(7, 7, 3, '2025-02-05', '2025-03-05', '2025-03-02'),
(8, 8, 3, '2025-02-10', '2025-03-10', NULL),   
(9, 9, 3, '2025-02-15', '2025-03-15', '2025-03-13'),
(10, 10, 3, '2025-02-20', '2025-03-20', NULL),
(11, 11, 3, '2025-03-01', '2025-04-01', '2025-03-25'),
(12, 12, 3, '2025-03-05', '2025-04-05', NULL),  
(13, 13, 3, '2025-03-10', '2025-04-10', '2025-04-08'),
(14, 14, 3, '2025-03-15', '2025-04-15', NULL),  
(15, 15, 3, '2025-03-20', '2025-04-20', '2025-04-18'),
(16, 1, 3, '2025-04-01', '2025-05-01', NULL),
(17, 2, 3, '2025-04-05', '2025-05-05', NULL),
(18, 3, 3, '2025-04-10', '2025-05-10', NULL),
(19, 4, 3, '2025-04-15', '2025-05-15', NULL),
(20, 5, 3, '2025-04-20', '2025-05-20', NULL);

-- agregando valores a la tabla de devoluciones
INSERT INTO devoluciones (id_prestamo, fecha_devolucion, observaciones) VALUES
(3, '2025-02-10', 'Libro devuelto en buen estado'),
(5, '2025-02-24', 'Libro devuelto en buen estado'),
(7, '2025-03-02', 'Portada ligeramente doblada'),
(9, '2025-03-13', 'Portada ligeramente doblada'),
(11, '2025-03-25', 'Libro con marcas de lápiz'),
(13, '2025-04-08', 'Sin observaciones'),
(15, '2025-04-18', 'Libro con marcas de lápiz'),
(16, '2025-04-25', 'Devolución anticipada'),
(18, '2025-05-05', 'Portada ligeramente doblada'),
(20, '2025-05-20', 'Libro con marcas de lápiz');


-- Consultas
-- 1 Libros prestados por usuario
SELECT usuarios.nombre, usuarios.apellido, libros.titulo
FROM prestamos
JOIN usuarios ON prestamos.id_usuario = usuarios.id
JOIN ejemplares ON prestamos.id_ejemplar = ejemplares.id
JOIN libros ON ejemplares.id_libro = libros.id;

-- 2 Libros no devueltos después de la fecha límite
SELECT usuarios.nombre, usuarios.apellido, libros.titulo, prestamos.fecha_prestamo, prestamos.fecha_vencimiento
FROM prestamos
JOIN usuarios ON prestamos.id_usuario = usuarios.id
JOIN ejemplares ON prestamos.id_ejemplar = ejemplares.id
JOIN libros ON ejemplares.id_libro = libros.id
WHERE prestamos.fecha_devolucion IS NULL
  AND DATE_ADD(prestamos.fecha_prestamo, INTERVAL 30 DAY) < CURDATE();
  
  
  -- 3 Libros más populares con más préstamos
SELECT libros.titulo, COUNT(*) AS total_prestamos
FROM prestamos
JOIN ejemplares ON prestamos.id_ejemplar = ejemplares.id
JOIN libros ON ejemplares.id_libro = libros.id
GROUP BY libros.id, libros.titulo
ORDER BY total_prestamos DESC
LIMIT 5;

-- 4 Autores con más publicaciones
SELECT autores.nombre, autores.apellido, COUNT(libro_autor.id_libro) AS total_publicaciones
FROM autores
JOIN libro_autor ON autores.id = libro_autor.id_autor
GROUP BY autores.id, autores.nombre, autores.apellido
ORDER BY total_publicaciones DESC;




-- 5 Prestamos realizados por mes
SELECT YEAR(fecha_prestamo) AS anio, MONTH(fecha_prestamo) AS mes, COUNT(*) AS total_prestamos
FROM prestamos
GROUP BY anio, mes
ORDER BY anio, mes;



-- 6 Total de libros prestados por categoría
SELECT categorias.nombre AS categoria, COUNT(*) AS total_prestados
FROM prestamos
JOIN ejemplares ON prestamos.id_ejemplar = ejemplares.id
JOIN libros ON ejemplares.id_libro = libros.id
JOIN categorias ON libros.id_categoria = categorias.id
GROUP BY categorias.id, categorias.nombre
ORDER BY total_prestados DESC;


-- 7 Procedimiento para registrar préstamo y devolución (con control de stock)
SELECT ejemplares.id_libro, libros.titulo, 
  ejemplares.cantidad - IFNULL(SUM(CASE WHEN prestamos.fecha_devolucion IS NULL THEN 1 ELSE 0 END),0) AS ejemplares_disponibles
FROM ejemplares
JOIN libros ON ejemplares.id_libro = libros.id
LEFT JOIN prestamos ON prestamos.id_ejemplar = ejemplares.id
GROUP BY ejemplares.id_libro, libros.titulo, ejemplares.cantidad;


-- 8 Simulación de multa si se pasa la fecha (se cobrar 2 lempiras por dia despues de la fecha de entrega)
SELECT usuarios.nombre, libros.titulo,
  CASE 
    WHEN prestamos.fecha_devolucion IS NOT NULL THEN
      GREATEST(DATEDIFF(prestamos.fecha_devolucion, prestamos.fecha_prestamo) - 30, 0) * 2
    ELSE
      GREATEST(DATEDIFF(CURDATE(), prestamos.fecha_prestamo) - 30, 0) * 2
  END AS multa_lempiras
FROM prestamos
JOIN usuarios ON prestamos.id_usuario = usuarios.id
JOIN ejemplares ON prestamos.id_ejemplar = ejemplares.id
JOIN libros ON ejemplares.id_libro = libros.id;


-- 9 Los 10 libros menos prestados
SELECT libros.titulo, COUNT(prestamos.id) AS total_prestamos
FROM libros
LEFT JOIN ejemplares ON ejemplares.id_libro = libros.id
LEFT JOIN prestamos ON prestamos.id_ejemplar = ejemplares.id
GROUP BY libros.id, libros.titulo
ORDER BY total_prestamos ASC
LIMIT 10;


-- 10  los 10 autores mas leidos
SELECT autores.nombre, autores.apellido, COUNT(prestamos.id) AS total_prestamos
FROM autores
JOIN libro_autor ON autores.id = libro_autor.id_autor
JOIN libros ON libro_autor.id_libro = libros.id
JOIN ejemplares ON ejemplares.id_libro = libros.id
JOIN prestamos ON prestamos.id_ejemplar = ejemplares.id
GROUP BY autores.id, autores.nombre, autores.apellido
ORDER BY total_prestamos DESC
LIMIT 10;

-- 11 muestra que generos hay mas libros

SELECT categorias.nombre AS genero, COUNT(libros.id) AS total_libros
FROM categorias
JOIN libros ON libros.id_categoria = categorias.id
GROUP BY categorias.id, categorias.nombre
ORDER BY total_libros DESC;


-- 12 cuantos libros hay prestados por usuarios docentes y estudiantes

SELECT usuarios.tipo, COUNT(prestamos.id) AS total_prestamos
FROM prestamos
JOIN usuarios ON prestamos.id_usuario = usuarios.id
GROUP BY usuarios.tipo;


-- 13  Cantidad de libros por editorial
SELECT libros.editorial, COUNT(libros.id) AS total_libros
FROM libros
GROUP BY libros.editorial
ORDER BY total_libros DESC;