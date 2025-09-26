# Generador de Presupuestos AI

Una aplicación web que utiliza inteligencia artificial para generar presupuestos automáticos para reparación de dispositivos electrónicos.

## 🚀 Características

- Generación automática de presupuestos usando OpenAI
- Base de datos MySQL para almacenar presupuestos
- Interfaz web intuitiva
- API RESTful

## 📋 Prerrequisitos

- Node.js (versión 14 o superior)
- MySQL
- Clave de API de OpenAI

## 🛠 Instalación

1. Clona el repositorio:
```bash
git clone https://github.com/Ignacio-nube/reparacion-celular.git
cd nacho
```

2. Instala las dependencias:
```bash
npm install
```

3. Configura las variables de entorno:
   - Crea un archivo `.env` en la raíz del proyecto
   - Agrega las siguientes variables:
```
OPENAI_API_KEY=tu_clave_de_openai
DB_HOST=localhost
DB_USER=tu_usuario_mysql
DB_PASSWORD=tu_contraseña_mysql
DB_NAME=nombre_de_tu_base_de_datos
PORT=3000
```

4. Configura la base de datos:
   - Ejecuta el script `schema.sql` para crear las tablas necesarias
   - Opcionalmente, ejecuta `data.sql` para datos de prueba

## 🚀 Uso

1. Inicia el servidor:
```bash
npm start
```

2. Abre tu navegador y ve a `http://localhost:3000`

3. Ingresa el dispositivo y el problema para generar un presupuesto

## 📁 Estructura del Proyecto

```
├── public/                 # Archivos estáticos (HTML, CSS, JS)
├── server.js              # Servidor principal
├── schema.sql            # Esquema de la base de datos
├── data.sql              # Datos de ejemplo
├── package.json          # Dependencias del proyecto
└── README.md            # Este archivo
```

## 🛡 Variables de Entorno

| Variable | Descripción |
|----------|-------------|
| `OPENAI_API_KEY` | Clave de API de OpenAI |
| `DB_HOST` | Host de la base de datos MySQL |
| `DB_USER` | Usuario de MySQL |
| `DB_PASSWORD` | Contraseña de MySQL |
| `DB_NAME` | Nombre de la base de datos |
| `PORT` | Puerto del servidor (por defecto: 3000) |

## 📝 API Endpoints

### POST /api/presupuesto
Genera un presupuesto para un dispositivo y problema específico.

**Body:**
```json
{
  "dispositivo": "iPhone 12",
  "problema": "Pantalla rota"
}
```

**Response:**
```json
{
  "presupuesto": "Presupuesto generado por AI..."
}
```

## 🤝 Contribuir

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia ISC.

## 👤 Autor

**Tu Nombre**
- GitHub: [Ignacio-nube](https://github.com/Ignacio-nube/reparacion-celular)