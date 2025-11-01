# ?? CONFIGURACIÓN DE BASE DE DATOS - InvoicesDB

## ?? INSTRUCCIONES RÁPIDAS

### Opción 1??: Usar SQL Server Management Studio (SSMS) - **RECOMENDADO**

1. Abre **SQL Server Management Studio**
2. Conéctate a tu servidor SQL (por defecto: `HUGO\SQLEXPRESS01`)
3. Abre el archivo: **`Database/CreateInvoicesDB.sql`**
4. Presiona **F5** o clic en **"Ejecutar"**
5. ¡Listo! La base de datos está creada

---

### Opción 2??: Usar PowerShell (Automático)

```powershell
# Desde la raíz del proyecto, ejecuta:
.\Database\SetupDatabase.ps1

# O si usas otro servidor:
.\Database\SetupDatabase.ps1 -ServerInstance "localhost"

# Para ver ayuda:
.\Database\SetupDatabase.ps1 -Help
```

---

### Opción 3??: Línea de Comandos (sqlcmd)

```cmd
sqlcmd -S HUGO\SQLEXPRESS01 -i "Database\CreateInvoicesDB.sql"
```

---

## ?? Archivos Disponibles

| Archivo | Descripción |
|---------|-------------|
| `Database/CreateInvoicesDB.sql` | **Script completo** - Crea BD, tablas y datos |
| `Database/CreateTablesOnly.sql` | **Solo tablas** - Para BD ya existente |
| `Database/SetupDatabase.ps1` | Script PowerShell automático |
| `Database/README.md` | Documentación completa |

---

## ??? Estructura de la Base de Datos

**Nombre:** `InvoicesDB`

**Tablas:**
- ? `customers` - Clientes (5 registros de prueba)
- ? `products` - Productos (5 registros de prueba)
- ? `invoices` - Facturas (5 registros de prueba)
- ? `invoice_details` - Detalles de facturas (5 registros de prueba)

---

## ?? Configuración del Proyecto

### Servidor SQL Actual:
```
HUGO\SQLEXPRESS01
```

### ¿Usas otro servidor?

Edita `MVCDemoC/Web.config` y cambia el `data source`:

```xml
<connectionStrings>
    <add name="InvoicesDBEntities" 
         connectionString="...data source=TU_SERVIDOR_AQUI;initial catalog=InvoicesDB;..." />
</connectionStrings>
```

**Ejemplos de servidores:**
- `localhost` - SQL Server local
- `.\SQLEXPRESS` - SQL Server Express local
- `NOMBRE_PC\SQLEXPRESS` - SQL Server Express con nombre
- `192.168.1.100` - Servidor remoto

---

## ? Verificación

Después de crear la base de datos, ejecuta en SQL:

```sql
USE InvoicesDB;
SELECT * FROM products;
```

Deberías ver **5 productos**.

---

## ?? Ejecutar el Proyecto

1. ? Asegúrate de que la base de datos InvoicesDB está creada
2. ? Verifica la cadena de conexión en Web.config
3. ? Abre el proyecto MVCDemoC en Visual Studio
4. ? Presiona **F5** para ejecutar
5. ? Navega a: `http://localhost:puerto/products`

---

## ?? Problemas Comunes

### ? Error: "Cannot open database InvoicesDB"
**Solución:** Ejecuta `CreateInvoicesDB.sql`

### ? Error: "Login failed"
**Solución:** Verifica permisos en SQL Server o cambia la autenticación

### ? Error: "Invalid object name 'products'"
**Solución:** Ejecuta el script de creación de tablas

### ? El proyecto no se conecta
**Solución:** Verifica el `data source` en Web.config

---

## ?? Documentación Completa

Para más detalles, consulta: **`Database/README.md`**

---

**¡Listo para empezar!** ??
