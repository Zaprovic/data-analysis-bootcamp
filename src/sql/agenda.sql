CREATE DATABASE IF NOT EXISTS agenda;

USE agenda;

CREATE TABLE IF NOT EXISTS Persona (
    id INT AUTO_INCREMENT PRIMARY KEY,
    `id contacto` INT(4) NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    `last name` VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS Contact (
    `id contacto` INT(4) PRIMARY KEY AUTO_INCREMENT,
    `description` TEXT
);