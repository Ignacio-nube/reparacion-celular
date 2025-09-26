CREATE TABLE presupuestos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    dispositivo VARCHAR(255) NOT NULL,
    problema TEXT NOT NULL,
    presupuesto_generado TEXT NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);