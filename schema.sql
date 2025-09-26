-- =====================================================================================
-- SCRIPT DE ESTRUCTURA DE BASE DE DATOS - Nacho Electronics
-- Este script elimina las tablas si existen y las vuelve a crear.
-- Es seguro ejecutarlo múltiples veces para reiniciar el esquema.
-- =====================================================================================

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS `reparaciones`;
DROP TABLE IF EXISTS `dispositivos`;
DROP TABLE IF EXISTS `repuestos`;
DROP TABLE IF EXISTS `presupuestos`;
SET FOREIGN_KEY_CHECKS = 1;

-- Tabla de dispositivos (Base de conocimiento)
CREATE TABLE `dispositivos` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `nombre` VARCHAR(100) NOT NULL,
    `marca` VARCHAR(50),
    `gama` VARCHAR(50) -- Ej: 'Alta', 'Media', 'Baja'
);

-- Tabla de repuestos (Base de conocimiento)
CREATE TABLE `repuestos` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `nombre` VARCHAR(100) NOT NULL, -- Ej: 'Pantalla OLED 6.1 pulgadas', 'Batería 4000mAh'
    `descripcion` TEXT
);

-- Tabla de reparaciones con precios (Base de conocimiento)
CREATE TABLE `reparaciones` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `dispositivo_id` INT,
    `repuesto_id` INT,
    `descripcion_problema` VARCHAR(255) NOT NULL, -- Ej: 'Cambio de pantalla rota', 'Reemplazo de batería'
    `precio` DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (`dispositivo_id`) REFERENCES `dispositivos`(`id`),
    FOREIGN KEY (`repuesto_id`) REFERENCES `repuestos`(`id`)
);

-- Tabla para guardar los presupuestos generados por la IA (Log)
CREATE TABLE `presupuestos` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `dispositivo` VARCHAR(255) NOT NULL,
    `problema` TEXT NOT NULL,
    `presupuesto_generado` TEXT NOT NULL,
    `fecha` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);