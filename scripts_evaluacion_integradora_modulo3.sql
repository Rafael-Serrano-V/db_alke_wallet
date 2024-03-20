-- DDL-SQL PARA CREAR BASE DE DATOS
CREATE DATABASE alke_wallet;

-- CAMBIAMOS EL CONTEXTO DE LA BASE DE DATOS A: alke_wallet
USE alke_wallet;

-- CREAMOS LA TABLA USUARIOS
CREATE TABLE usuarios (
user_id INT AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(100),
correo_electronico VARCHAR(100),
contrasegna VARCHAR(16),
saldo DECIMAL(10,2)
);

-- CREAMOS LA TABLA MONEDAS
CREATE TABLE monedas (
currency_id INT AUTO_INCREMENT PRIMARY KEY,
currency_name VARCHAR(50),
currency_symbol VARCHAR(10)
);

-- CREAMOS LA TABLA TRANSACCIONES
CREATE TABLE transacciones (
transaction_id INT AUTO_INCREMENT PRIMARY KEY,
sender_user_id INT,
receiver_user_id INT,
importe DECIMAL(10,2),
transaction_date DATE,
tipo_currency_id INT,
FOREIGN KEY (sender_user_id) REFERENCES usuarios(user_id),
FOREIGN KEY (receiver_user_id) REFERENCES usuarios(user_id),
FOREIGN KEY (tipo_currency_id) REFERENCES monedas(currency_id)
);

-- AGREGAMOS RESTRICCIONES DE UNICIDAD
ALTER TABLE usuarios
ADD CONSTRAINT UC_usuarios UNIQUE (correo_electronico);

ALTER TABLE monedas
ADD CONSTRAINT UC_monedas_name UNIQUE (currency_name),
ADD CONSTRAINT UC_monedas_symbol UNIQUE (currency_symbol);

-- AGREGAMOS RESTRICCIONES DE NO NULIDAD
ALTER TABLE usuarios
MODIFY nombre VARCHAR(100) NOT NULL,
MODIFY correo_electronico VARCHAR(100) NOT NULL,
MODIFY contrasegna VARCHAR(16) NOT NULL;

ALTER TABLE transacciones
MODIFY sender_user_id INT NOT NULL,
MODIFY receiver_user_id INT NOT NULL,
MODIFY importe DECIMAL(10,2) NOT NULL,
MODIFY transaction_date DATE NOT NULL,
MODIFY tipo_currency_id INT NOT NULL;

ALTER TABLE monedas
MODIFY currency_name VARCHAR(50) NOT NULL,
MODIFY currency_symbol VARCHAR(10) NOT NULL;

-- AGREGAMOS RESTRICCIONES DE VERIFICACION
ALTER TABLE usuarios
ADD CONSTRAINT CHK_saldo CHECK (saldo>=0);

ALTER TABLE transacciones
ADD CONSTRAINT CHK_importe CHECK (importe>1000);

-- AGREGAMOS RESTRICCIONES DE INTEGRIDAD REFERENCIAL
-- Usuarios - Transacciones (como emisor): Cuando un usuario es eliminado, podríamos querer eliminar todas las transacciones donde ese usuario es el emisor.
ALTER TABLE transacciones
DROP FOREIGN KEY transacciones_ibfk_1,
ADD CONSTRAINT FK_transacciones_sender
	FOREIGN KEY (sender_user_id)
    REFERENCES usuarios(user_id)
    ON DELETE CASCADE;
--  Usuarios - Transacciones (como receptor): Similarmente, cuando un usuario es eliminado, podrías querer eliminar todas las transacciones donde ese usuario es el receptor.   
ALTER TABLE transacciones
DROP FOREIGN KEY transacciones_ibfk_2,
ADD CONSTRAINT FK_transacciones_receiver
	FOREIGN KEY (receiver_user_id)
    REFERENCES usuarios(user_id)
	ON DELETE CASCADE;

-- Monedas - Transacciones: Cuando una moneda es eliminada, podrías querer evitar que se elimine si hay transacciones asociadas a esa moneda.    
ALTER TABLE transacciones 
DROP FOREIGN KEY transacciones_ibfk_3,
ADD CONSTRAINT FK_transacciones_currency
	FOREIGN KEY (tipo_currency_id)
    REFERENCES monedas(currency_id)
    ON DELETE RESTRICT;

SHOW CREATE TABLE transacciones;


-- INSERTAMOS DATOS EN LA TABLA USUARIOS
INSERT INTO usuarios (nombre, correo_electronico, contrasegna, saldo)
VALUES
("Usuario1", "usuario1@email.com", "contraseña1", 10000),
("Usuario2", "usuario2@email.com", "contraseña2", 10000),
("Usuario3", "usuario3@email.com", "contraseña3", 10000),
("Usuario4", "usuario4@email.com", "contraseña4", 10000),
("Usuario5", "usuario5@email.com", "contraseña5", 10000),
("Usuario6", "usuario6@email.com", "contraseña6", 10000),
("Usuario7", "usuario7@email.com", "contraseña7", 10000),
("Usuario8", "usuario8@email.com", "contraseña8", 10000),
("Usuario9", "usuario9@email.com", "contraseña9", 10000),
("Usuario10", "usuario10@email.com", "contraseña10", 10000);

-- INSERTAMOS DATOS EN LA TABLA MONEDAS
INSERT INTO monedas (currency_name, currency_symbol)
VALUES
("Dólar estadounidense", "US$"),
("EURO", "€"),
("Yen japonés", "¥"),
("Libra esterlina", "£"),
("Dólar astraliano", "A$"),
("Dólar canadiense", "C$"),
("Franco suizo", "CHF"),
("Renminbi/yuan chino","元"),
("Dólar de Hong Kong","HK$"),
("Dólar de Nueva Zelanda","NZ$"),
("Corona sueca","kr"),
("Won surcoreano","₩"),
("Dólar de Singapur","S$"),
("Peso mexicano", "$"),
("Rupia india", "₹"),
("Rublo ruso", "₽"),
("Rand sudafricano", "R"),
("Lira turca", "₺"),
("Real brasileño", "R$"),
("Nuevo dólar taiwanés", "NT$"),
("Złoty polaco", "zł"),
("Baht tailandés", "฿"),
("Rupia indonesia", "Rp"),
("Florín húngaro", "Ft"),
("Corona checa", "Kč"),
("Nuevo shekel israelí", "₪"),
("Peso chileno", "CLP$"),
("Peso filipino", "₱");

-- INSERTAMOS DATOS EN LA TABLA TRANSACCIONES
INSERT INTO transacciones (sender_user_id, receiver_user_id, importe, transaction_date, tipo_currency_id)
VALUES
(1, 2, 10000, "2024-03-19", 57),
(2, 1, 25000, "2024-03-20", 57),
(6, 9, 15000, "2024-03-14", 57),
(9, 8, 8000, "2024-03-10", 57),
(3, 7, 5000, "2024-03-12", 57);


-- CONSULTAS A LA BASE DE DATOS
-- Consulta para obtener el nombre de la moneda elegida por un usuario específico
SELECT u.nombre AS nombre_usuario, m.currency_name AS nombre_moneda
FROM usuarios u
JOIN transacciones t ON u.user_id = t.sender_user_id
JOIN monedas m ON t.tipo_currency_id = m.currency_id
WHERE u.user_id = 1
ORDER BY t.transaction_date DESC
LIMIT 1;

-- Consulta para obtener todas las transacciones registradas
SELECT * FROM transacciones;

-- Consulta para obtener todas las transacciones realizadas por un usuario específico
SELECT * FROM transacciones 
WHERE sender_user_id = 1;

-- Sentencia DML para modificar el campo correo electrónico de un usuario específico
UPDATE usuarios
SET correo_electronico = "nuevo_correo2@email.com"
WHERE user_id = 2;

-- Sentencia para eliminar los datos de una transacción (eliminado de la fila completa)
DELETE FROM transacciones
WHERE transaction_id = 3;
