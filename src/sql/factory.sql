-- LINK: https://en.wikibooks.org/wiki/SQL_Exercises/The_computer_store

CREATE TABLE Manufacturers (
    Code INTEGER,
    Name VARCHAR(255) NOT NULL,
    PRIMARY KEY (Code)
);

CREATE TABLE Products (
    Code INTEGER,
    Name VARCHAR(255) NOT NULL,
    Price DECIMAL NOT NULL,
    Manufacturer INTEGER NOT NULL,
    PRIMARY KEY (Code),
    FOREIGN KEY (Manufacturer) REFERENCES Manufacturers (Code)
) ENGINE = INNODB;

INSERT INTO Manufacturers (Code, Name) VALUES (1, 'Sony');

INSERT INTO Manufacturers (Code, Name) VALUES (2, 'Creative Labs');

INSERT INTO Manufacturers (Code, Name) VALUES (3, 'Hewlett-Packard');

INSERT INTO Manufacturers (Code, Name) VALUES (4, 'Iomega');

INSERT INTO Manufacturers (Code, Name) VALUES (5, 'Fujitsu');

INSERT INTO Manufacturers (Code, Name) VALUES (6, 'Winchester');

INSERT INTO
    Products (
        Code,
        Name,
        Price,
        Manufacturer
    )
VALUES (1, 'Hard drive', 240, 5);

INSERT INTO
    Products (
        Code,
        Name,
        Price,
        Manufacturer
    )
VALUES (2, 'Memory', 120, 6);

INSERT INTO
    Products (
        Code,
        Name,
        Price,
        Manufacturer
    )
VALUES (3, 'ZIP drive', 150, 4);

INSERT INTO
    Products (
        Code,
        Name,
        Price,
        Manufacturer
    )
VALUES (4, 'Floppy disk', 5, 6);

INSERT INTO
    Products (
        Code,
        Name,
        Price,
        Manufacturer
    )
VALUES (5, 'Monitor', 240, 1);

INSERT INTO
    Products (
        Code,
        Name,
        Price,
        Manufacturer
    )
VALUES (6, 'DVD drive', 180, 2);

INSERT INTO
    Products (
        Code,
        Name,
        Price,
        Manufacturer
    )
VALUES (7, 'CD drive', 90, 2);

INSERT INTO
    Products (
        Code,
        Name,
        Price,
        Manufacturer
    )
VALUES (8, 'Printer', 270, 3);

INSERT INTO
    Products (
        Code,
        Name,
        Price,
        Manufacturer
    )
VALUES (9, 'Toner cartridge', 66, 3);

INSERT INTO
    Products (
        Code,
        Name,
        Price,
        Manufacturer
    )
VALUES (10, 'DVD burner', 180, 2);

-- Ejercicio 1: Inner Join básico
-- Escribe una consulta que muestre el nombre de los productos y el nombre del fabricante para todos los productos:

select
    p.`Name` as `Product name`,
    m.`Name` as `Manufacturer name`
from Products p
    inner join Manufacturers m on p.`Manufacturer` = m.`Code`;

-- Ejercicio 2: Inner Join con condición de precio
-- Escribe una consulta que muestre el nombre de los productos, su precio y el nombre del fabricante, solo para los productos cuyo precio sea mayor a 100.
select
    p.`Name` as `Product name`,
    p.`Price` as `Product price`,
    m.`Name` as `Manufacturer name`
from Products p
    inner join Manufacturers m on p.`Manufacturer` = m.`Code`
where
    p.`Price` > 100;
-- Ejercicio 3: Cláusula BETWEEN para filtrar precios
-- Escribe una consulta que muestre los nombres de los productos cuyo precio esté entre 100 y 200, y también incluya el nombre del fabricante.
select
    p.`Name` as `Product name`,
    p.`Price` as `Product price`,
    m.`Name` as `Manufacturer name`
from Products p
    inner join Manufacturers m on p.`Manufacturer` = m.`Code`
where
    p.price between 100 and 200;

-- Ejercicio 4: Cláusula IN para seleccionar fabricantes específicos
-- Escribe una consulta que muestre todos los productos que sean fabricados por Sony o Fujitsu.
select
    p.`Name` as `Product name`,
    p.`Price` as `Product price`,
    m.`Name` as `Manufacturer name`
from Products p
    inner join Manufacturers m on p.`Manufacturer` = m.`Code`
where
    m.`Name` in ('Sony', 'Fujitsu');
-- Ejercicio 5: Cláusula ORDER BY para ordenar productos por precio
-- Escribe una consulta que muestre todos los productos y sus precios ordenados de mayor a menor precio.
select * from Products p order by p.`Price` desc;

-- Ejercicio 6: Cláusulas AND y OR para combinar condiciones
-- Escribe una consulta que muestre todos los productos cuyo precio sea menor a 200 o que sean fabricados por Sony.
select
    p.`Name` as `Product name`,
    p.`Price` as `Product price`,
    m.`Name` as `Manufacturer name`
from Products p
    inner join Manufacturers m on p.`Manufacturer` = m.`Code`
where
    p.`Price` < 200
    or m.`Name` = 'Sony';

-- Ejercicio 7: Cláusula NOT para excluir un fabricante
-- Escribe una consulta que muestre los productos cuyo fabricante no sea Creative Labs.
select
    p.`Name` as `Product name`,
    p.`Price` as `Product price`,
    m.`Name` as `Manufacturer name`
from Products p
    inner join Manufacturers m on p.`Manufacturer` = m.`Code`
where
    m.`Name` <> 'Creative Labs';

-- Ejercicio 8: Cláusulas BETWEEN y AND con Inner Join
-- Escribe una consulta que muestre los productos cuyo precio esté entre 50 y 150, y también el nombre del fabricante.
select
    m.`Name` as `Manufacturer name`,
    p.`Name` as `Product name`,
    p.`Price` as `Product price`
from Products p
    inner join Manufacturers m on p.`Manufacturer` = m.`Code`
where
    p.price between 50 and 150

-- Ejercicio 9: Inner Join con múltiples condiciones
-- Escribe una consulta que muestre el nombre del producto, el precio y el fabricante para los productos cuyo precio sea mayor a 100 y el fabricante sea Sony o Fujitsu.
select
    m.`Name` as `Manufacturer name`,
    p.`Name` as `Product name`,
    p.`Price` as `Product price`
from Products p
    inner join Manufacturers m on p.`Manufacturer` = m.`Code`
where
    p.price > 100
    and m.`Name` in ('Sony', 'Fujitsu');

-- Ejercicio 10: Cláusula ORDER BY y Inner Join con múltiples columnas
-- Escribe una consulta que muestre el nombre del producto y el nombre del fabricante, ordenado por nombre del fabricante y luego por el precio del producto de manera ascendente.

select
    m.`Name` as `Manufacturer name`,
    p.`Name` as `Product name`,
    p.`Price` as `Product price`
from Products p
    inner join Manufacturers m on p.`Manufacturer` = m.`Code`
order by m.`Name`, p.`Price` asc;