# 🚀 Guía Completa para Probar la API con Postman

## 📥 **PASO 1: Importar la Colección**

### **Opción A: Importar desde archivo**
1. Abre Postman
2. Click en **"Import"** (esquina superior izquierda)
3. Arrastra el archivo `postman_collection.json` o click en **"Upload Files"**
4. Selecciona el archivo y click **"Import"**

### **Opción B: Importar desde GitHub** (si ya hiciste push)
1. Abre Postman
2. Click en **"Import"** > **"Link"**
3. Pega la URL: `https://raw.githubusercontent.com/RodrigoGutierrezGZ/api-laravel/main/postman_collection.json`
4. Click **"Continue"** > **"Import"**

---

## 🌍 **PASO 2: Configurar el Environment**

### **Importar Environment:**
1. En Postman, click en **"Environments"** (icono de engranaje arriba a la derecha)
2. Click **"Import"**
3. Selecciona `postman_environment.json`
4. Selecciona el environment **"Laravel API - Local Environment"** del dropdown

### **O Crear Manualmente:**
1. Click en **"Environments"** > **"Create Environment"**
2. Nombre: `Laravel API Local`
3. Agrega la variable:
   - **Variable:** `base_url`
   - **Initial Value:** `http://localhost:8000`
   - **Current Value:** `http://localhost:8000`
4. Click **"Save"**
5. Selecciona el environment del dropdown

---

## ✅ **PASO 3: Verificar que Docker está Corriendo**

Antes de hacer las pruebas, asegúrate de que los contenedores estén activos:

```powershell
# Verificar estado
docker-compose ps

# Si no están corriendo, iniciar:
docker-compose up -d

# Verificar que la API responde
curl http://localhost:8000/api/products
```

---

## 🧪 **PASO 4: Ejecutar las Pruebas**

### **A. Pruebas CRUD Básicas (en orden)**

#### **1️⃣ GET All Products**
- **Request:** GET `{{base_url}}/api/products`
- **Resultado esperado:** Status `200 OK`
- **Respuesta:** Array con lista de productos
```json
[
  {
    "id": 8,
    "name": "Laptop Dell XPS 13",
    "description": "Ultrabook premium...",
    "price": 1299.99,
    "stock": 15,
    "created_at": "2025-12-08T03:21:21.000000Z",
    "updated_at": "2025-12-08T03:21:21.000000Z"
  }
]
```

#### **2️⃣ GET Product by ID**
- **Request:** GET `{{base_url}}/api/products/8`
- **Resultado esperado:** Status `200 OK`
- **Respuesta:** Objeto con el producto específico

#### **3️⃣ CREATE Product**
- **Request:** POST `{{base_url}}/api/products`
- **Headers:**
  - `Accept: application/json`
  - `Content-Type: application/json`
- **Body (raw JSON):**
```json
{
    "name": "iPhone 15 Pro",
    "description": "Smartphone Apple con chip A17 Pro",
    "price": 1199.99,
    "stock": 25
}
```
- **Resultado esperado:** Status `201 Created`
- **Nota:** Guarda el `id` del producto creado para las siguientes pruebas

#### **4️⃣ UPDATE Product (PUT)**
- **Request:** PUT `{{base_url}}/api/products/22` (usa el ID del producto creado)
- **Body (raw JSON):**
```json
{
    "name": "iPhone 15 Pro Max",
    "description": "Smartphone Apple actualizado",
    "price": 1399.99,
    "stock": 20
}
```
- **Resultado esperado:** Status `200 OK`

#### **5️⃣ UPDATE Product (PATCH)**
- **Request:** PATCH `{{base_url}}/api/products/22`
- **Body (raw JSON):** (solo campos a actualizar)
```json
{
    "price": 1299.99,
    "stock": 30
}
```
- **Resultado esperado:** Status `200 OK`

#### **6️⃣ DELETE Product**
- **Request:** DELETE `{{base_url}}/api/products/22`
- **Resultado esperado:** Status `200 OK` o `204 No Content`

---

### **B. Pruebas de Validación**

#### **7️⃣ Validación: Campo Requerido Faltante**
- **Request:** POST `{{base_url}}/api/products`
- **Body:**
```json
{
    "description": "Producto sin nombre",
    "price": 99.99,
    "stock": 10
}
```
- **Resultado esperado:** Status `422 Unprocessable Entity`
- **Respuesta esperada:**
```json
{
    "message": "The name field is required.",
    "errors": {
        "name": ["The name field is required."]
    }
}
```

#### **8️⃣ Validación: Tipo de Dato Incorrecto**
- **Request:** POST `{{base_url}}/api/products`
- **Body:**
```json
{
    "name": "Producto Test",
    "description": "Test",
    "price": "no-es-numero",
    "stock": 10
}
```
- **Resultado esperado:** Status `422`

#### **9️⃣ Validación: Precio Negativo**
- **Request:** POST `{{base_url}}/api/products`
- **Body:**
```json
{
    "name": "Producto Test",
    "description": "Test",
    "price": -50.00,
    "stock": 10
}
```
- **Resultado esperado:** Status `422`

#### **🔟 Error: Producto No Encontrado**
- **Request:** GET `{{base_url}}/api/products/99999`
- **Resultado esperado:** Status `404 Not Found`

---

## 📊 **PASO 5: Usar el Collection Runner**

Para ejecutar todas las pruebas automáticamente:

1. Click derecho en la colección **"Laravel API - Products CRUD"**
2. Click **"Run collection"**
3. En la ventana del Runner:
   - Asegúrate de que el environment esté seleccionado
   - Deja todas las requests marcadas
   - Click **"Run Laravel API - Products CRUD"**
4. Observa los resultados:
   - Verde ✅ = Test pasó
   - Rojo ❌ = Test falló

---

## 🎯 **Resultados Esperados**

| Request | Method | Status | Descripción |
|---------|--------|--------|-------------|
| Get All Products | GET | 200 | Lista todos los productos |
| Get Product by ID | GET | 200 | Muestra un producto específico |
| Create Product | POST | 201 | Crea nuevo producto |
| Update Product (PUT) | PUT | 200 | Actualiza producto completo |
| Update Product (PATCH) | PATCH | 200 | Actualiza campos específicos |
| Delete Product | DELETE | 200/204 | Elimina producto |
| Missing Name | POST | 422 | Validación: campo requerido |
| Invalid Price | POST | 422 | Validación: tipo de dato |
| Negative Price | POST | 422 | Validación: valor mínimo |
| Not Found | GET | 404 | Recurso inexistente |

---

## 🔧 **Troubleshooting**

### **Error: "Could not get any response"**
```powershell
# Verificar que Docker esté corriendo
docker-compose ps

# Reiniciar contenedores si es necesario
docker-compose restart

# Verificar que el puerto 8000 esté abierto
netstat -ano | findstr :8000
```

### **Error: 404 en todas las rutas**
```powershell
# Verificar rutas de la API
docker-compose exec app php artisan route:list --path=api

# Limpiar cache
docker-compose exec app php artisan route:clear
docker-compose exec app php artisan cache:clear
```

### **Error: 500 Internal Server Error**
```powershell
# Ver logs del contenedor
docker-compose logs app --tail=50

# Ver logs de Laravel
docker-compose exec app tail -f storage/logs/laravel.log
```

### **Base de datos vacía**
```powershell
# Ejecutar migraciones y seeder
docker-compose exec app php artisan migrate:fresh --seed
```

---

## 📸 **Screenshots Esperados**

### **GET All Products (200 OK)**
```json
[
  {
    "id": 8,
    "name": "Laptop Dell XPS 13",
    "description": "Ultrabook premium...",
    "price": 1299.99,
    "stock": 15,
    "created_at": "2025-12-08T03:21:21.000000Z",
    "updated_at": "2025-12-08T03:21:21.000000Z"
  },
  ...
]
```

### **POST Create Product (201 Created)**
```json
{
  "id": 22,
  "name": "iPhone 15 Pro",
  "description": "Smartphone Apple...",
  "price": 1199.99,
  "stock": 25,
  "created_at": "2025-12-08T10:30:45.000000Z",
  "updated_at": "2025-12-08T10:30:45.000000Z"
}
```

### **Validation Error (422 Unprocessable)**
```json
{
  "message": "The name field is required.",
  "errors": {
    "name": ["The name field is required."]
  }
}
```

---

## ✨ **Tips Avanzados**

### **Usar Variables en Postman**
Después de crear un producto, puedes guardar su ID automáticamente:

1. En el tab **"Tests"** del request "Create Product", agrega:
```javascript
// Guardar el ID del producto creado
pm.test("Product created successfully", function () {
    var jsonData = pm.response.json();
    pm.environment.set("product_id", jsonData.id);
});
```

2. Luego usa `{{product_id}}` en las URLs de Update/Delete

### **Tests Automáticos**
Agrega en el tab **"Tests"** de cada request:

```javascript
// Verificar status code
pm.test("Status code is 200", function () {
    pm.response.to.have.status(200);
});

// Verificar estructura de respuesta
pm.test("Response has required fields", function () {
    var jsonData = pm.response.json();
    pm.expect(jsonData).to.have.property('id');
    pm.expect(jsonData).to.have.property('name');
    pm.expect(jsonData).to.have.property('price');
});

// Verificar tipo de datos
pm.test("Price is a number", function () {
    var jsonData = pm.response.json();
    pm.expect(jsonData.price).to.be.a('number');
});
```

---

## 🎓 **Para la Demostración en Vivo**

1. **Orden recomendado:**
   - Mostrar GET All Products (lista inicial)
   - Crear un producto nuevo (POST)
   - Actualizar el producto creado (PATCH)
   - Eliminar el producto (DELETE)
   - Mostrar validación fallida (campo faltante)

2. **Preparación:**
   - Tener Postman abierto con la colección cargada
   - Environment seleccionado
   - Docker corriendo
   - Base de datos con datos del seeder

3. **Puntos clave a destacar:**
   - Status codes correctos (200, 201, 422, 404)
   - Validaciones funcionando
   - Estructura JSON consistente
   - Tiempo de respuesta rápido

---

## ✅ **Checklist Pre-Demo**

- [ ] Postman instalado y colección importada
- [ ] Environment configurado con `http://localhost:8000`
- [ ] Docker contenedores corriendo (`docker-compose ps`)
- [ ] Base de datos con productos (`GET /api/products` devuelve datos)
- [ ] Probado al menos un request de cada tipo exitosamente

**¡Listo para la demostración! 🚀**