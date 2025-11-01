# ?? CRUDs Implementados - MVCDemoC

## ? CRUDs Completados con Eliminación Lógica

Se han implementado **3 CRUDs completos** en el proyecto MVCDemoC, todos con **eliminación lógica** usando el campo `active`:

---

## ?? 1. CRUD de Products (Productos)

### ?? Archivos:
- **Controlador:** `MVCDemoC/Controllers/productsController.cs`
- **Modelo:** `MVCDemoC/Models/products.cs`
- **Vistas:**
  - `MVCDemoC/Views/products/Index.cshtml`
  - `MVCDemoC/Views/products/Create.cshtml`
  - `MVCDemoC/Views/products/Edit.cshtml`
  - `MVCDemoC/Views/products/Details.cshtml`
  - `MVCDemoC/Views/products/Delete.cshtml`

### ?? Rutas:
- **Listar:** `/products` o `/products/Index`
- **Crear:** `/products/Create`
- **Editar:** `/products/Edit/5`
- **Detalles:** `/products/Details/5`
- **Eliminar:** `/products/Delete/5`

### ?? Campos:
- `product_id` (PK, Identity)
- `name` (string)
- `price` (decimal)
- `stock` (int)
- `active` (bool) ? **Eliminación lógica**

---

## ?? 2. CRUD de Customers (Clientes)

### ?? Archivos:
- **Controlador:** `MVCDemoC/Controllers/customersController.cs` ? **NUEVO**
- **Modelo:** `MVCDemoC/Models/customers.cs`
- **Vistas:**
  - `MVCDemoC/Views/customers/Index.cshtml` ? **NUEVO**
  - `MVCDemoC/Views/customers/Create.cshtml` ? **NUEVO**
  - `MVCDemoC/Views/customers/Edit.cshtml` ? **NUEVO**
  - `MVCDemoC/Views/customers/Details.cshtml` ? **NUEVO**
  - `MVCDemoC/Views/customers/Delete.cshtml` ? **NUEVO**

### ?? Rutas:
- **Listar:** `/customers` o `/customers/Index`
- **Crear:** `/customers/Create`
- **Editar:** `/customers/Edit/5`
- **Detalles:** `/customers/Details/5`
- **Eliminar:** `/customers/Delete/5`

### ?? Campos:
- `customer_id` (PK, Identity)
- `name` (string)
- `address` (string)
- `phone` (string)
- `active` (bool) ? **Eliminación lógica**

---

## ?? 3. CRUD de Invoices (Facturas)

### ?? Archivos:
- **Controlador:** `MVCDemoC/Controllers/invoicesController.cs` ? **NUEVO**
- **Modelo:** `MVCDemoC/Models/invoices.cs`
- **Vistas:**
  - `MVCDemoC/Views/invoices/Index.cshtml` ? **NUEVO**
  - `MVCDemoC/Views/invoices/Create.cshtml` ? **NUEVO**
  - `MVCDemoC/Views/invoices/Edit.cshtml` ? **NUEVO**
  - `MVCDemoC/Views/invoices/Details.cshtml` ? **NUEVO**
  - `MVCDemoC/Views/invoices/Delete.cshtml` ? **NUEVO**

### ?? Rutas:
- **Listar:** `/invoices` o `/invoices/Index`
- **Crear:** `/invoices/Create`
- **Editar:** `/invoices/Edit/5`
- **Detalles:** `/invoices/Details/5`
- **Eliminar:** `/invoices/Delete/5`

### ?? Campos:
- `invoice_id` (PK, Identity)
- `customer_id` (FK ? customers) ??
- `date` (DateTime)
- `total` (decimal)
- `active` (bool) ? **Eliminación lógica**

### ?? Relación:
- Cada factura está vinculada a un **Customer** (cliente)
- En los formularios de crear/editar, se muestra un **dropdown** con los clientes activos

---

## ??? Eliminación Lógica Implementada

### ¿Qué es la Eliminación Lógica?

En lugar de **borrar permanentemente** un registro de la base de datos, se marca como "inactivo" cambiando el campo `active` a `false`.

### ? Ventajas:
- ? No se pierden datos
- ? Se puede recuperar información "eliminada"
- ? Se mantiene el historial completo
- ? Integridad referencial preservada

### ?? Implementación en Código:

#### Antes (Eliminación Física - ? NO USAR):
```csharp
public ActionResult DeleteConfirmed(int id)
{
    products products = db.products.Find(id);
    db.products.Remove(products);  // ? Borra permanentemente
    db.SaveChanges();
    return RedirectToAction("Index");
}
```

#### Después (Eliminación Lógica - ? IMPLEMENTADO):
```csharp
public ActionResult DeleteConfirmed(int id)
{
    products products = db.products.Find(id);
    products.active = false;  // ? Solo marca como inactivo
    db.Entry(products).State = EntityState.Modified;
    db.SaveChanges();
    return RedirectToAction("Index");
}
```

### ?? Filtrado en Index:

Todos los métodos `Index` filtran solo registros activos:

```csharp
public ActionResult Index()
{
    return View(db.products.Where(x => x.active == true).ToList());
}
```

Esto asegura que **solo se muestren registros activos** (no eliminados lógicamente).

---

## ?? Funcionalidades Completas

### Para los 3 CRUDs (Products, Customers, Invoices):

| Funcionalidad | Implementada |
|---------------|--------------|
| ? Listar (Index) | Sí - Solo activos |
| ? Crear (Create) | Sí - Con active=true |
| ? Editar (Edit) | Sí |
| ? Ver Detalles (Details) | Sí |
| ? Eliminar (Delete) | Sí - Lógica (active=false) |
| ? Validaciones | Sí - AntiForgeryToken |
| ? Bootstrap Styling | Sí |

---

## ?? Cómo Usar los CRUDs

### 1. Ejecutar el Proyecto:
```
F5 en Visual Studio
```

### 2. Navegar a las URLs:

#### Products:
```
http://localhost:puerto/products
```

#### Customers:
```
http://localhost:puerto/customers
```

#### Invoices:
```
http://localhost:puerto/invoices
```

---

## ?? Estructura Consistente

Todos los CRUDs siguen **exactamente la misma estructura**:

```
?? Controllers/
   ??? productsController.cs
   ??? customersController.cs
   ??? invoicesController.cs

?? Models/
   ??? products.cs
   ??? customers.cs
   ??? invoices.cs

?? Views/
   ??? ?? products/
   ?   ??? Index.cshtml
   ?   ??? Create.cshtml
   ?   ??? Edit.cshtml
   ?   ??? Details.cshtml
   ?   ??? Delete.cshtml
   ??? ?? customers/
   ?   ??? Index.cshtml
   ?   ??? Create.cshtml
   ?   ??? Edit.cshtml
   ?   ??? Details.cshtml
   ?   ??? Delete.cshtml
   ??? ?? invoices/
       ??? Index.cshtml
       ??? Create.cshtml
       ??? Edit.cshtml
       ??? Details.cshtml
       ??? Delete.cshtml
```

---

## ?? Relaciones entre Entidades

```
customers (Clientes)
    ?
    1 : N (Uno a Muchos)
    ?
invoices (Facturas)
    ?
    1 : N (Uno a Muchos)
    ?
invoice_details (Detalles de Factura)
    ?
    N : 1 (Muchos a Uno)
    ?
products (Productos)
```

### Características de las Relaciones:
- ? **Invoices** muestra el nombre del cliente en el listado
- ? Al crear/editar facturas, se selecciona el cliente de un **dropdown**
- ? Solo se muestran clientes **activos** en los dropdowns
- ? Las relaciones se mantienen intactas con la eliminación lógica

---

## ? Estado del Proyecto

| Componente | Estado |
|------------|--------|
| ??? Base de Datos | ? Creada |
| ?? Modelo de Datos | ? Generado |
| ?? Controladores | ? 3/3 Completos |
| ?? Vistas | ? 15/15 Creadas |
| ?? Eliminación Lógica | ? Implementada |
| ?? Relaciones FK | ? Funcionando |
| ??? Compilación | ? Sin Errores |

---

## ?? Resumen

Se han creado **exitosamente**:

? **15 archivos de vistas** (5 por cada CRUD)
? **2 controladores nuevos** (customers, invoices)
? **1 controlador actualizado** (products con eliminación lógica)
? **Eliminación lógica** implementada en los 3 CRUDs
? **Filtrado automático** de registros inactivos
? **Relaciones FK** funcionando correctamente

---

**¡Todos los CRUDs están listos para usar!** ??

Navega a:
- `/products` - Gestionar productos
- `/customers` - Gestionar clientes
- `/invoices` - Gestionar facturas
