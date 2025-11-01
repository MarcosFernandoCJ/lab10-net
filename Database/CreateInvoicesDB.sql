-- =============================================
-- Script de Creación de Base de Datos InvoicesDB
-- Proyecto: MVCDemoC
-- Fecha: 2025
-- =============================================

USE master;
GO

-- Eliminar la base de datos si existe (opcional, comentar si no quieres eliminar)
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'InvoicesDB')
BEGIN
    ALTER DATABASE InvoicesDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE InvoicesDB;
END
GO

-- Crear la base de datos
CREATE DATABASE InvoicesDB;
GO

-- Usar la base de datos
USE InvoicesDB;
GO

-- =============================================
-- CREACIÓN DE TABLAS
-- =============================================

-- Crear la tabla 'customers'
CREATE TABLE customers (
    customer_id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(255) NOT NULL,
    address NVARCHAR(255),
    phone NVARCHAR(15),
    active BIT NOT NULL DEFAULT 1
);
GO

-- Crear la tabla 'products'
CREATE TABLE products (
    product_id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL,
    active BIT NOT NULL DEFAULT 1
);
GO

-- Crear la tabla 'invoices'
CREATE TABLE invoices (
    invoice_id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT,
    date DATETIME NOT NULL,
    total DECIMAL(10, 2) NOT NULL,
    active BIT NOT NULL DEFAULT 1,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
GO

-- Crear la tabla 'invoice_details'
CREATE TABLE invoice_details (
    detail_id INT PRIMARY KEY IDENTITY(1,1),
    invoice_id INT,
    product_id INT,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    active BIT NOT NULL DEFAULT 1,
    FOREIGN KEY (invoice_id) REFERENCES invoices(invoice_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
GO

-- =============================================
-- INSERCIÓN DE DATOS DE PRUEBA
-- =============================================

-- Insertar datos en la tabla 'customers'
INSERT INTO customers (name, address, phone, active)
VALUES
    ('John Doe', '123 Main St', '555-1234', 1),
    ('Jane Smith', '456 Elm St', '555-5678', 1),
    ('Bob Johnson', '789 Oak St', '555-9012', 1),
    ('Alice Williams', '321 Pine St', '555-3456', 1),
    ('Charlie Brown', '654 Maple St', '555-7890', 1);
GO

-- Insertar datos en la tabla 'products'
INSERT INTO products (name, price, stock, active)
VALUES
    ('Product A', 10.99, 100, 1),
    ('Product B', 15.99, 75, 1),
    ('Product C', 7.49, 150, 1),
    ('Product D', 25.50, 50, 1),
    ('Product E', 5.99, 200, 1);
GO

-- Insertar datos en la tabla 'invoices'
INSERT INTO invoices (customer_id, date, total, active)
VALUES
    (1, '2023-10-10 10:00:00', 32.97, 1),
    (2, '2023-10-11 11:30:00', 47.97, 1),
    (3, '2023-10-12 09:15:00', 22.47, 1),
    (1, '2023-10-13 14:20:00', 51.00, 1),
    (4, '2023-10-14 16:45:00', 17.97, 1);
GO

-- Insertar datos en la tabla 'invoice_details'
INSERT INTO invoice_details (invoice_id, product_id, quantity, price, subtotal, active)
VALUES
    (1, 1, 3, 10.99, 32.97, 1),
    (2, 2, 3, 15.99, 47.97, 1),
    (3, 3, 3, 7.49, 22.47, 1),
    (4, 4, 2, 25.50, 51.00, 1),
    (5, 5, 3, 5.99, 17.97, 1);
GO

-- =============================================
-- VERIFICACIÓN DE DATOS
-- =============================================

PRINT '==========================================';
PRINT 'Base de datos InvoicesDB creada exitosamente';
PRINT '==========================================';
PRINT '';
PRINT 'Resumen de registros insertados:';

-- Usar variables para evitar errores de subconsultas en PRINT
DECLARE @CustomersCount NVARCHAR(10);
DECLARE @ProductsCount NVARCHAR(10);
DECLARE @InvoicesCount NVARCHAR(10);
DECLARE @DetailsCount NVARCHAR(10);

SELECT @CustomersCount = CAST(COUNT(*) AS NVARCHAR(10)) FROM customers;
SELECT @ProductsCount = CAST(COUNT(*) AS NVARCHAR(10)) FROM products;
SELECT @InvoicesCount = CAST(COUNT(*) AS NVARCHAR(10)) FROM invoices;
SELECT @DetailsCount = CAST(COUNT(*) AS NVARCHAR(10)) FROM invoice_details;

PRINT '- Customers: ' + @CustomersCount;
PRINT '- Products: ' + @ProductsCount;
PRINT '- Invoices: ' + @InvoicesCount;
PRINT '- Invoice Details: ' + @DetailsCount;
PRINT '';
PRINT 'Tablas creadas:';
SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;
GO

PRINT '';
PRINT '==========================================';
PRINT 'Script completado exitosamente!';
PRINT '==========================================';
GO
