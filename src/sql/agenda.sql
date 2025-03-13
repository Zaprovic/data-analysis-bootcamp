CREATE DATABASE IF NOT EXISTS Libreria;

USE Libreria;

DROP Table IF EXISTS Libros;

CREATE TABLE IF NOT EXISTS Libros (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(40) NOT NULL,
    author VARCHAR(100) NOT NULL,
    editor VARCHAR(40) NOT NULL,
    price FLOAT NOT NULL,
    qty INT NOT NULL
);

INSERT INTO
    Libros (
        title,
        author,
        editor,
        price,
        qty
    )
VALUES (
        'The Art of War',
        'Sun Tzu',
        'Arthur',
        40.99,
        100
    ),
    (
        'War and Peace',
        'Leo Tolstoy',
        'Leo Tolstoy',
        22.99,
        300
    ),
    (
        'A Game of Thrones',
        'George R. R. Martin',
        'George R. R. Martin',
        52.99,
        50
    ),
    (
        'Lord of the Rings',
        'J.R.R. Tolkien',
        'J.R.R. Tolkien',
        34.99,
        75
    ),
    (
        'One Hundred Years of Solitude',
        'Gabriel Garcia Marquez',
        'Gabriel Garcia Marquez',
        41.99,
        200
    );

SELECT * FROM Libros WHERE qty > 50;

SELECT * from `Libros`;

SELECT title, author, editor, price
FROM Libros
WHERE
    author LIKE('G%');

SELECT *
FROM Libros
WHERE
    price BETWEEN 20 AND 45
ORDER BY price ASC;

SELECT * FROM Libros WHERE editor LIKE('Arthur%');