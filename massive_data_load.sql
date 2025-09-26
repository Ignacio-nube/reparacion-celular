-- =====================================================================================
-- SCRIPT DE CARGA MASIVA DE DATOS - BASE DE CONOCIMIENTO PARA IA (Versión Corregida)
-- Este script elimina las tablas si existen, las vuelve a crear y luego inserta los datos.
-- Es seguro ejecutarlo múltiples veces.
-- =====================================================================================

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS reparaciones;
DROP TABLE IF EXISTS dispositivos;
DROP TABLE IF EXISTS repuestos;
SET FOREIGN_KEY_CHECKS = 1;

-- Tabla de dispositivos
CREATE TABLE `dispositivos` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `nombre` VARCHAR(100) NOT NULL,
    `marca` VARCHAR(50),
    `gama` VARCHAR(50) -- Ej: 'Alta', 'Media', 'Baja'
);

-- Tabla de repuestos
CREATE TABLE `repuestos` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `nombre` VARCHAR(100) NOT NULL, -- Ej: 'Pantalla OLED 6.1 pulgadas', 'Batería 4000mAh'
    `descripcion` TEXT
);

-- Tabla de reparaciones con precios
CREATE TABLE `reparaciones` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `dispositivo_id` INT,
    `repuesto_id` INT,
    `descripcion_problema` VARCHAR(255) NOT NULL, -- Ej: 'Cambio de pantalla rota', 'Reemplazo de batería'
    `precio` DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (`dispositivo_id`) REFERENCES `dispositivos`(`id`),
    FOREIGN KEY (`repuesto_id`) REFERENCES `repuestos`(`id`)
);

-- Inserción de datos de ejemplo

-- Repuestos
INSERT INTO `repuestos` (`id`, `nombre`, `descripcion`) VALUES
(1, 'Pantalla de Reemplazo', 'Pantalla genérica o de calidad original para el dispositivo especificado.'),
(2, 'Batería de Reemplazo', 'Batería de litio de capacidad similar a la original.'),
(3, 'Módulo de Pin de Carga', 'Componente que incluye el puerto de carga y a veces el micrófono principal.');

-- Dispositivos
INSERT INTO `dispositivos` (`id`, `nombre`, `marca`, `gama`) VALUES
(1, 'iPhone 15 Pro Max', 'Apple', 'Premium'),
(2, 'iPhone 15', 'Apple', 'Alta'),
(3, 'iPhone 14 Pro', 'Apple', 'Alta'),
(4, 'iPhone 14', 'Apple', 'Alta'),
(5, 'iPhone 13', 'Apple', 'Alta'),
(6, 'iPhone 12', 'Apple', 'Media-Alta'),
(7, 'iPhone 11', 'Apple', 'Media'),
(8, 'iPhone SE (2022)', 'Apple', 'Media'),
(9, 'Samsung Galaxy S24 Ultra', 'Samsung', 'Premium'),
(10, 'Samsung Galaxy S23 Ultra', 'Samsung', 'Premium'),
(11, 'Samsung Galaxy S23', 'Samsung', 'Alta'),
(12, 'Samsung Galaxy A54 5G', 'Samsung', 'Media-Alta'),
(13, 'Samsung Galaxy A34 5G', 'Samsung', 'Media'),
(14, 'Samsung Galaxy A24', 'Samsung', 'Media-Baja'),
(15, 'Samsung Galaxy A14', 'Samsung', 'Baja'),
(16, 'Samsung Galaxy Z Fold 5', 'Samsung', 'Premium'),
(17, 'Samsung Galaxy Z Flip 5', 'Samsung', 'Premium'),
(18, 'Xiaomi 13T Pro', 'Xiaomi', 'Alta'),
(19, 'Xiaomi Redmi Note 12 Pro+', 'Xiaomi', 'Media-Alta'),
(20, 'Xiaomi Redmi Note 12', 'Xiaomi', 'Media'),
(21, 'Xiaomi Poco X5 Pro', 'Xiaomi', 'Media'),
(22, 'Xiaomi Redmi 12C', 'Xiaomi', 'Baja'),
(23, 'Motorola Edge 40 Pro', 'Motorola', 'Alta'),
(24, 'Motorola Edge 40', 'Motorola', 'Media-Alta'),
(25, 'Motorola Moto G84', 'Motorola', 'Media'),
(26, 'Motorola Moto G54', 'Motorola', 'Media-Baja'),
(27, 'Motorola Moto G23', 'Motorola', 'Baja'),
(28, 'Google Pixel 8 Pro', 'Google', 'Premium'),
(29, 'Google Pixel 7a', 'Google', 'Media-Alta'),
(30, 'OnePlus 11', 'OnePlus', 'Alta');

-- Reparaciones y Precios
INSERT INTO `reparaciones` (`dispositivo_id`, `repuesto_id`, `descripcion_problema`, `precio`) VALUES
-- Apple iPhone
(1, 1, 'Cambio de pantalla', 450.00), (1, 2, 'Cambio de batería', 120.00), (1, 3, 'Reparación de pin de carga', 150.00),
(2, 1, 'Cambio de pantalla', 350.00), (2, 2, 'Cambio de batería', 110.00), (2, 3, 'Reparación de pin de carga', 140.00),
(3, 1, 'Cambio de pantalla', 380.00), (3, 2, 'Cambio de batería', 100.00), (3, 3, 'Reparación de pin de carga', 130.00),
(4, 1, 'Cambio de pantalla', 320.00), (4, 2, 'Cambio de batería', 95.00), (4, 3, 'Reparación de pin de carga', 125.00),
(5, 1, 'Cambio de pantalla', 280.00), (5, 2, 'Cambio de batería', 90.00), (5, 3, 'Reparación de pin de carga', 110.00),
(6, 1, 'Cambio de pantalla', 220.00), (6, 2, 'Cambio de batería', 85.00), (6, 3, 'Reparación de pin de carga', 100.00),
(7, 1, 'Cambio de pantalla', 150.00), (7, 2, 'Cambio de batería', 75.00), (7, 3, 'Reparación de pin de carga', 90.00),
(8, 1, 'Cambio de pantalla', 130.00), (8, 2, 'Cambio de batería', 70.00), (8, 3, 'Reparación de pin de carga', 85.00),
-- Samsung Galaxy
(9, 1, 'Cambio de pantalla', 480.00), (9, 2, 'Cambio de batería', 130.00), (9, 3, 'Reparación de pin de carga', 160.00),
(10, 1, 'Cambio de pantalla', 450.00), (10, 2, 'Cambio de batería', 120.00), (10, 3, 'Reparación de pin de carga', 150.00),
(11, 1, 'Cambio de pantalla', 300.00), (11, 2, 'Cambio de batería', 90.00), (11, 3, 'Reparación de pin de carga', 110.00),
(12, 1, 'Cambio de pantalla', 180.00), (12, 2, 'Cambio de batería', 70.00), (12, 3, 'Reparación de pin de carga', 80.00),
(13, 1, 'Cambio de pantalla', 150.00), (13, 2, 'Cambio de batería', 65.00), (13, 3, 'Reparación de pin de carga', 75.00),
(14, 1, 'Cambio de pantalla', 110.00), (14, 2, 'Cambio de batería', 60.00), (14, 3, 'Reparación de pin de carga', 65.00),
(15, 1, 'Cambio de pantalla', 90.00), (15, 2, 'Cambio de batería', 55.00), (15, 3, 'Reparación de pin de carga', 60.00),
(16, 1, 'Cambio de pantalla (interna)', 600.00), (16, 2, 'Cambio de batería', 150.00), (16, 3, 'Reparación de pin de carga', 180.00),
(17, 1, 'Cambio de pantalla (interna)', 450.00), (17, 2, 'Cambio de batería', 130.00), (17, 3, 'Reparación de pin de carga', 160.00),
-- Xiaomi
(18, 1, 'Cambio de pantalla', 280.00), (18, 2, 'Cambio de batería', 80.00), (18, 3, 'Reparación de pin de carga', 90.00),
(19, 1, 'Cambio de pantalla', 190.00), (19, 2, 'Cambio de batería', 70.00), (19, 3, 'Reparación de pin de carga', 75.00),
(20, 1, 'Cambio de pantalla', 140.00), (20, 2, 'Cambio de batería', 65.00), (20, 3, 'Reparación de pin de carga', 60.00),
(21, 1, 'Cambio de pantalla', 150.00), (21, 2, 'Cambio de batería', 68.00), (21, 3, 'Reparación de pin de carga', 62.00),
(22, 1, 'Cambio de pantalla', 85.00), (22, 2, 'Cambio de batería', 50.00), (22, 3, 'Reparación de pin de carga', 55.00),
-- Motorola
(23, 1, 'Cambio de pantalla', 300.00), (23, 2, 'Cambio de batería', 85.00), (23, 3, 'Reparación de pin de carga', 95.00),
(24, 1, 'Cambio de pantalla', 250.00), (24, 2, 'Cambio de batería', 75.00), (24, 3, 'Reparación de pin de carga', 85.00),
(25, 1, 'Cambio de pantalla', 160.00), (25, 2, 'Cambio de batería', 65.00), (25, 3, 'Reparación de pin de carga', 70.00),
(26, 1, 'Cambio de pantalla', 130.00), (26, 2, 'Cambio de batería', 60.00), (26, 3, 'Reparación de pin de carga', 65.00),
(27, 1, 'Cambio de pantalla', 100.00), (27, 2, 'Cambio de batería', 55.00), (27, 3, 'Reparación de pin de carga', 60.00),
-- Google & OnePlus
(28, 1, 'Cambio de pantalla', 400.00), (28, 2, 'Cambio de batería', 110.00), (28, 3, 'Reparación de pin de carga', 130.00),
(29, 1, 'Cambio de pantalla', 200.00), (29, 2, 'Cambio de batería', 80.00), (29, 3, 'Reparación de pin de carga', 90.00),
(30, 1, 'Cambio de pantalla', 320.00), (30, 2, 'Cambio de batería', 90.00), (30, 3, 'Reparación de pin de carga', 100.00);