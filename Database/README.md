# ??? Scripts de Base de Datos - InvoicesDB

Este directorio contiene los scripts SQL necesarios para crear y configurar la base de datos del proyecto MVCDemoC.

## ?? Archivos Disponibles

### 1. `CreateInvoicesDB.sql` - Script Completo
**Uso:** Cuando NO tienes la base de datos InvoicesDB creada.

**Qué hace:**
- ? Elimina la base de datos InvoicesDB si existe (CUIDADO: borra todo)
- ? Crea la base de datos InvoicesDB
- ? Crea todas las tablas (customers, products, invoices, invoice_details)
- ? Inserta datos de prueba
- ? Muestra un resumen de verificación

**Cómo ejecutar:**
```sql
-- Opción 1: SQL Server Management Studio (SSMS)
1. Abre SSMS
2. Conéctate a tu servidor: HUGO\SQLEXPRESS01 (o tu servidor)
3. Abre el archivo CreateInvoicesDB.sql
4. Presiona F5 o clic en "Ejecutar"

-- Opción 2: sqlcmd (Línea de comandos)
sqlcmd -S HUGO\SQLEXPRESS01 -i "Database\CreateInvoicesDB.sql"
```

---

### 2. `CreateTablesOnly.sql` - Solo Tablas y Datos
**Uso:** Cuando la base de datos InvoicesDB YA EXISTE pero está vacía o quieres recrear las tablas.

**Qué hace:**
- ? Elimina las tablas existentes (si existen)
- ? Crea todas las tablas
- ? Inserta datos de prueba
- ? NO crea ni elimina la base de datos

**Cómo ejecutar:**
```sql
-- Opción 1: SQL Server Management Studio (SSMS)
1. Abre SSMS
2. Conéctate a tu servidor
3. Selecciona la BD InvoicesDB en el explorador
4. Abre el archivo CreateTablesOnly.sql
5. Presiona F5 o clic en "Ejecutar"

-- Opción 2: sqlcmd
sqlcmd -S HUGO\SQLEXPRESS01 -d InvoicesDB -i "Database\CreateTablesOnly.sql"
```

---

## ??? Estructura de la Base de Datos

### Tablas Creadas:

#### 1?? **customers** (Clientes)
```sql
- customer_id (INT, PK, IDENTITY)
- name (NVARCHAR(255), NOT NULL)
- address (NVARCHAR(255))
- phone (NVARCHAR(15))
- active (BIT, DEFAULT 1)
```

#### 2?? **products** (Productos)
```sql
- product_id (INT, PK, IDENTITY)
- name (NVARCHAR(255), NOT NULL)
- price (DECIMAL(10,2), NOT NULL)
- stock (INT, NOT NULL)
- active (BIT, DEFAULT 1)
```

#### 3?? **invoices** (Facturas)
```sql
- invoice_id (INT, PK, IDENTITY)
- customer_id (INT, FK -> customers)
- date (DATETIME, NOT NULL)
- total (DECIMAL(10,2), NOT NULL)
- active (BIT, DEFAULT 1)
```

#### 4?? **invoice_details** (Detalles de Factura)
```sql
- detail_id (INT, PK, IDENTITY)
- invoice_id (INT, FK -> invoices)
- product_id (INT, FK -> products)
- quantity (INT, NOT NULL)
- price (DECIMAL(10,2), NOT NULL)
- subtotal (DECIMAL(10,2), NOT NULL)
- active (BIT, DEFAULT 1)
```

---

## ?? Datos de Prueba Incluidos

Después de ejecutar cualquiera de los scripts, tendrás:

- ? **5 Clientes** (John Doe, Jane Smith, Bob Johnson, Alice Williams, Charlie Brown)
- ? **5 Productos** (Product A, B, C, D, E con diferentes precios)
- ? **5 Facturas** (con fechas de octubre 2023)
- ? **5 Detalles de Factura** (relacionados con las facturas)

---

## ?? Configuración del Proyecto

### Cadena de Conexión Actual (Web.config):
```
Servidor: HUGO\SQLEXPRESS01
Base de Datos: InvoicesDB
Autenticación: Windows (Integrated Security)
```

### ?? Si usas otro servidor SQL Server:

Edita el archivo `MVCDemoC\Web.config` y cambia:

```xml
<connectionStrings>
    <add name="InvoicesDBEntities" 
         connectionString="metadata=res://*/Models.Model1.csdl|res://*/Models.Model1.ssdl|res://*/Models.Model1.msl;
         provider=System.Data.SqlClient;
         provider connection string=&quot;
            data source=TU_SERVIDOR_AQUI;
            initial catalog=InvoicesDB;
            integrated security=True;
            trustservercertificate=True;
            MultipleActiveResultSets=True;
            App=EntityFramework&quot;" 
         providerName="System.Data.EntityClient" />
</connectionStrings>
```

Reemplaza `TU_SERVIDOR_AQUI` por:
- `localhost` - Si SQL Server está en tu máquina local
- `.\SQLEXPRESS` - Si usas SQL Server Express local
- `NOMBRE_PC\SQLEXPRESS` - Si usas SQL Server Express con nombre de PC
- `servidor,puerto` - Si es un servidor remoto

---

## ?? Pasos Rápidos para Empezar

### Método Rápido (Recomendado):

1. **Abre SQL Server Management Studio (SSMS)**
2. **Conéctate a tu servidor SQL**
3. **Ejecuta `CreateInvoicesDB.sql`** (si no tienes la BD)
   O ejecuta `CreateTablesOnly.sql` (si ya tienes la BD)
4. **Verifica que las tablas se crearon:**
   ```sql
   USE InvoicesDB;
   SELECT * FROM products;  -- Deberías ver 5 productos
   ```
5. **Ejecuta el proyecto MVCDemoC desde Visual Studio (F5)**
6. **Navega a:** `http://localhost:puerto/products`

---

## ? Verificación

Para verificar que todo está correcto, ejecuta en SQL:

```sql
USE InvoicesDB;

-- Ver todos los registros
SELECT 'Customers' AS Tabla, COUNT(*) AS Total FROM customers
UNION ALL
SELECT 'Products', COUNT(*) FROM products
UNION ALL
SELECT 'Invoices', COUNT(*) FROM invoices
UNION ALL
SELECT 'Invoice_Details', COUNT(*) FROM invoice_details;

-- Resultado esperado:
-- Customers: 5
-- Products: 5
-- Invoices: 5
-- Invoice_Details: 5
```

---

## ?? Notas Importantes

- ?? **CreateInvoicesDB.sql** ELIMINA la base de datos si existe. ¡Ten cuidado si ya tienes datos!
- ?? **CreateTablesOnly.sql** es más seguro, solo elimina y recrea las tablas.
- ?? Todos los scripts usan `GO` para separar lotes de comandos.
- ?? El campo `active` en todas las tablas permite "soft delete" (eliminación lógica).

---

## ??? Solución de Problemas

### Error: "Cannot open database InvoicesDB"
**Solución:** Ejecuta `CreateInvoicesDB.sql` primero.

### Error: "Login failed for user"
**Solución:** Verifica que tienes permisos en SQL Server o usa autenticación SQL.

### Error: "Invalid object name 'products'"
**Solución:** Ejecuta el script de creación de tablas.

### El proyecto no se conecta a la BD
**Solución:** Verifica la cadena de conexión en `Web.config` y que el servidor SQL esté correcto.

---

## ?? Resumen

| Escenario | Script a Usar |
|-----------|---------------|
| No tengo la BD InvoicesDB | `CreateInvoicesDB.sql` |
| Ya tengo la BD pero sin tablas | `CreateTablesOnly.sql` |
| Quiero empezar de cero | `CreateInvoicesDB.sql` |
| Solo quiero datos de prueba | Ejecuta solo las secciones INSERT de cualquier script |

---

**¡Listo! Ahora tu base de datos InvoicesDB está configurada y lista para usar con el proyecto MVCDemoC.** ??
