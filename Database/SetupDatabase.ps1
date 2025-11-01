# =============================================
# Script PowerShell para Crear Base de Datos InvoicesDB
# Proyecto: MVCDemoC
# =============================================

param(
    [string]$ServerInstance = "HUGO\SQLEXPRESS01",
    [switch]$TablesOnly = $false,
    [switch]$Help = $false
)

# Mostrar ayuda
if ($Help) {
    Write-Host ""
    Write-Host "===========================================" -ForegroundColor Cyan
    Write-Host "Script de Creación de Base de Datos" -ForegroundColor Cyan
    Write-Host "===========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "USO:" -ForegroundColor Yellow
    Write-Host "  .\SetupDatabase.ps1 [-ServerInstance servidor] [-TablesOnly] [-Help]"
    Write-Host ""
    Write-Host "PARAMETROS:" -ForegroundColor Yellow
    Write-Host "  -ServerInstance   Nombre del servidor SQL (default: HUGO\SQLEXPRESS01)"
    Write-Host "  -TablesOnly       Solo crear tablas (no crear/eliminar la BD)"
    Write-Host "  -Help             Mostrar esta ayuda"
    Write-Host ""
    Write-Host "EJEMPLOS:" -ForegroundColor Yellow
    Write-Host "  .\SetupDatabase.ps1"
    Write-Host "  .\SetupDatabase.ps1 -ServerInstance localhost"
    Write-Host "  .\SetupDatabase.ps1 -ServerInstance .\SQLEXPRESS -TablesOnly"
    Write-Host ""
    exit
}

Write-Host ""
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host "Configuración de Base de Datos InvoicesDB" -ForegroundColor Cyan
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host ""

# Verificar si sqlcmd está instalado
Write-Host "Verificando sqlcmd..." -ForegroundColor Yellow
$sqlcmdPath = Get-Command sqlcmd -ErrorAction SilentlyContinue

if (-not $sqlcmdPath) {
    Write-Host "ERROR: sqlcmd no está instalado o no está en el PATH." -ForegroundColor Red
    Write-Host ""
    Write-Host "SOLUCIONES:" -ForegroundColor Yellow
    Write-Host "1. Ejecuta el script SQL manualmente desde SQL Server Management Studio (SSMS)"
    Write-Host "2. Instala SQL Server Command Line Utilities:"
    Write-Host "   https://docs.microsoft.com/en-us/sql/tools/sqlcmd-utility"
    Write-Host ""
    exit 1
}

Write-Host "? sqlcmd encontrado: $($sqlcmdPath.Source)" -ForegroundColor Green
Write-Host ""

# Determinar qué script ejecutar
if ($TablesOnly) {
    $scriptFile = "Database\CreateTablesOnly.sql"
    $scriptName = "Creación de Tablas"
} else {
    $scriptFile = "Database\CreateInvoicesDB.sql"
    $scriptName = "Creación Completa de Base de Datos"
}

# Verificar que el script existe
if (-not (Test-Path $scriptFile)) {
    Write-Host "ERROR: No se encuentra el archivo $scriptFile" -ForegroundColor Red
    Write-Host "Asegúrate de estar en la raíz del proyecto." -ForegroundColor Yellow
    Write-Host ""
    exit 1
}

Write-Host "Script a ejecutar: $scriptName" -ForegroundColor Cyan
Write-Host "Archivo: $scriptFile" -ForegroundColor Cyan
Write-Host "Servidor: $ServerInstance" -ForegroundColor Cyan
Write-Host ""

# Confirmación
Write-Host "ADVERTENCIA: " -ForegroundColor Yellow -NoNewline
if ($TablesOnly) {
    Write-Host "Se eliminarán y recrearán las tablas existentes." -ForegroundColor Yellow
} else {
    Write-Host "Se eliminará la base de datos InvoicesDB si existe." -ForegroundColor Yellow
}
Write-Host ""

$confirm = Read-Host "¿Deseas continuar? (S/N)"
if ($confirm -ne "S" -and $confirm -ne "s" -and $confirm -ne "Y" -and $confirm -ne "y") {
    Write-Host "Operación cancelada." -ForegroundColor Yellow
    exit 0
}

Write-Host ""
Write-Host "Ejecutando script SQL..." -ForegroundColor Yellow
Write-Host "===========================================" -ForegroundColor Gray

# Ejecutar el script SQL
try {
    $result = sqlcmd -S $ServerInstance -i $scriptFile -E 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "===========================================" -ForegroundColor Green
        Write-Host "? ÉXITO: Base de datos configurada correctamente" -ForegroundColor Green
        Write-Host "===========================================" -ForegroundColor Green
        Write-Host ""
        Write-Host "Próximos pasos:" -ForegroundColor Cyan
        Write-Host "1. Verifica la conexión en Web.config" -ForegroundColor White
        Write-Host "2. Ejecuta el proyecto MVCDemoC desde Visual Studio (F5)" -ForegroundColor White
        Write-Host "3. Navega a: http://localhost:puerto/products" -ForegroundColor White
        Write-Host ""
        
        # Mostrar resultado
        Write-Host "Salida del script SQL:" -ForegroundColor Gray
        Write-Host "-------------------------------------------" -ForegroundColor Gray
        $result
        Write-Host "-------------------------------------------" -ForegroundColor Gray
    } else {
        Write-Host ""
        Write-Host "===========================================" -ForegroundColor Red
        Write-Host "? ERROR: Hubo un problema al ejecutar el script" -ForegroundColor Red
        Write-Host "===========================================" -ForegroundColor Red
        Write-Host ""
        Write-Host "Detalles del error:" -ForegroundColor Yellow
        $result
        Write-Host ""
        Write-Host "Posibles soluciones:" -ForegroundColor Yellow
        Write-Host "1. Verifica que el servidor SQL esté correcto: $ServerInstance" -ForegroundColor White
        Write-Host "2. Verifica que tengas permisos para crear bases de datos" -ForegroundColor White
        Write-Host "3. Ejecuta el script manualmente desde SSMS" -ForegroundColor White
        Write-Host ""
        exit 1
    }
} catch {
    Write-Host ""
    Write-Host "===========================================" -ForegroundColor Red
    Write-Host "? ERROR FATAL" -ForegroundColor Red
    Write-Host "===========================================" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host ""
    exit 1
}

Write-Host ""
Write-Host "Configuración completada." -ForegroundColor Green
Write-Host ""
