use biblioteca;
DESCRIBE prestamos;
select * from empleados;
SELECT DISTINCT id_libro FROM ejemplares;
help prestamos;
SELECT DISTINCT empleados.nombre
FROM ejemplares
JOIN empleados ON ejemplares.id_empleado = empleados.id;

SELECT DISTINCT libros.titulo
FROM ejemplares
JOIN libros ON ejemplares.id_libro = libros.id;

SELECT DISTINCT empleados.nombre
FROM prestamos
JOIN empleados ON prestamos.id_empleado = empleados.id;

DESCRIBE prestamos;
DESCRIBE empleados;



