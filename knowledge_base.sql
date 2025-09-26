-- Base de conocimiento para la IA de presupuestos

-- Tabla de dispositivos
CREATE TABLE dispositivos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    marca VARCHAR(50),
    gama VARCHAR(50) -- Ej: 'Alta', 'Media', 'Baja'
);

-- Tabla de repuestos
CREATE TABLE repuestos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL, -- Ej: 'Pantalla OLED 6.1 pulgadas', 'Batería 4000mAh'
    descripcion TEXT
);

-- Tabla de reparaciones con precios
CREATE TABLE reparaciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    dispositivo_id INT,
    repuesto_id INT,
    descripcion_problema VARCHAR(255) NOT NULL, -- Ej: 'Cambio de pantalla rota', 'Reemplazo de batería'
    precio DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (dispositivo_id) REFERENCES dispositivos(id),
    FOREIGN KEY (repuesto_id) REFERENCES repuestos(id)
);

-- Inserción de datos de ejemplo

-- Dispositivos
INSERT INTO dispositivos (nombre, marca, gama) VALUES
('iPhone 14', 'Apple', 'Alta'),
('Samsung Galaxy S22', 'Samsung', 'Alta'),
('Xiaomi Redmi Note 11', 'Xiaomi', 'Media'),
('Motorola Moto G52', 'Motorola', 'Media');

-- Repuestos
INSERT INTO repuestos (nombre, descripcion) VALUES
('Pantalla OLED 6.1"', 'Repuesto de pantalla calidad original'),
('Batería 3279mAh', 'Batería de reemplazo para iPhone'),
('Puerto de Carga USB-C', 'Módulo de carga y datos'),
('Pantalla AMOLED 6.4"', 'Repuesto de pantalla para gama media'),
('Batería 5000mAh', 'Batería de alta capacidad');

-- Reparaciones y Precios
-- Precios para iPhone 14 (dispositivo_id = 1)
INSERT INTO reparaciones (dispositivo_id, repuesto_id, descripcion_problema, precio) VALUES
(1, 1, 'Cambio de pantalla rota', 280.00),
(1, 2, 'Reemplazo de batería (rendimiento bajo 80%)', 95.00),
(1, 3, 'Reparación de puerto de carga (no carga)', 110.00);

-- Precios para Samsung Galaxy S22 (dispositivo_id = 2)
INSERT INTO reparaciones (dispositivo_id, repuesto_id, descripcion_problema, precio) VALUES
(2, 1, 'Cambio de pantalla rota', 250.00),
(2, 5, 'Reemplazo de batería', 80.00);

-- Precios para Xiaomi Redmi Note 11 (dispositivo_id = 3)
INSERT INTO reparaciones (dispositivo_id, repuesto_id, descripcion_problema, precio) VALUES
(3, 4, 'Cambio de pantalla rota', 120.00),
(3, 5, 'Reemplazo de batería', 65.00),
(3, 3, 'Reparación de puerto de carga', 50.00);
