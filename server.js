require('dotenv').config();
const express = require('express');
const mysql = require('mysql2/promise');
const { OpenAI } = require('openai');

const app = express();
const port = process.env.PORT || 3000;

// Middleware
app.use(express.json());
app.use(express.static('public'));

// Configuración de OpenAI
const openai = new OpenAI({
    apiKey: process.env.OPENAI_API_KEY,
});

// Configuración de la base de datos
const dbConfig = {
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME
};

async function guardarPresupuesto(dispositivo, problema, presupuestoGenerado) {
    let connection;
    try {
        connection = await mysql.createConnection(dbConfig);
        const sql = 'INSERT INTO presupuestos (dispositivo, problema, presupuesto_generado) VALUES (?, ?, ?)';
        await connection.execute(sql, [dispositivo, problema, presupuestoGenerado]);
    } catch (error) {
        console.error('Error al guardar en la base de datos:', error);
        // No lanzamos el error para no interrumpir al usuario, solo lo logueamos
    } finally {
        if (connection) await connection.end();
    }
}

// Ruta de la API para obtener presupuestos
app.post('/api/presupuesto', async (req, res) => {
    const { dispositivo, problema } = req.body;

    if (!dispositivo || !problema) {
        return res.status(400).json({ error: 'El dispositivo y el problema son requeridos.' });
    }

    let connection;
    try {
        // 1. Conectar a la base de datos
        connection = await mysql.createConnection(dbConfig);

        // 2. Obtener la lista de precios de la base de conocimiento
        const query = `
            SELECT 
                d.nombre as dispositivo, 
                rp.descripcion_problema as reparacion, 
                rp.precio
            FROM reparaciones rp
            JOIN dispositivos d ON rp.dispositivo_id = d.id
            JOIN repuestos r_part ON rp.repuesto_id = r_part.id;
        `;
        const [reparaciones] = await connection.execute(query);

        // 3. Formatear la lista de precios para la IA
        const preciosString = reparaciones.map(r => 
            `- Dispositivo: ${r.dispositivo}, Reparación: ${r.reparacion}, Precio: ${r.precio} USD`
        ).join('\n');

        // 4. Construir el nuevo prompt para la IA
        const prompt = `
            Actúa como un técnico experto en reparación de electrónica llamado 'Nacho'.
            Tu tarea es generar un presupuesto para un cliente basándote ESTRICTAMENTE en la lista de precios que te proporciono.

            **Reglas MUY Importantes:**
            1.  Usa EXCLUSIVAMENTE los precios de la siguiente lista. NO inventes precios ni rangos.
            2.  Si la reparación o el dispositivo solicitado por el cliente no aparece en la lista, indica amablemente que no tienes un precio exacto para esa reparación y que se necesita una revisión física en el taller para dar un costo.
            3.  Si encuentras una reparación que coincida, menciona el precio exacto de la lista.
            4.  Sé amable y profesional.

            **--- MI LISTA DE PRECIOS (USD) ---**
            ${preciosString}
            **--- FIN DE LA LISTA ---**

            **Datos del Cliente:**
            -   **Dispositivo:** ${dispositivo}
            -   **Problema:** ${problema}

            Genera el presupuesto a continuación.
        `;

        // 5. Llamar a la IA y devolver el resultado
        const completion = await openai.chat.completions.create({
            model: 'gpt-3.5-turbo', // Usamos un modelo más rápido y económico
            messages: [{ role: 'user', content: prompt }],
            temperature: 0.2, // Baja temperatura para respuestas más predecibles
        });

        const presupuestoGenerado = completion.choices[0].message.content.trim();

        // Guardar en la tabla de logs (sin esperar a que termine)
        guardarPresupuesto(dispositivo, problema, presupuestoGenerado);

        res.json({ presupuesto: presupuestoGenerado });

    } catch (error) {
        console.error('Error en la ruta /api/presupuesto:', error);
        res.status(500).json({ error: 'No se pudo obtener un presupuesto en este momento. Inténtalo de nuevo más tarde.' });
    } finally {
        if (connection) await connection.end();
    }
});

// Ruta para obtener la lista de dispositivos
app.get('/api/dispositivos', async (req, res) => {
    let connection;
    try {
        connection = await mysql.createConnection(dbConfig);
        const [rows] = await connection.execute('SELECT id, nombre, marca FROM dispositivos ORDER BY marca, nombre');
        res.json(rows);
    } catch (error) {
        console.error('Error al obtener dispositivos:', error);
        res.status(500).json({ error: 'No se pudo cargar la lista de dispositivos.' });
    } finally {
        if (connection) await connection.end();
    }
});

// Ruta para obtener el precio exacto de una reparación
app.get('/api/precio/:reparacion_id', async (req, res) => {
    const { reparacion_id } = req.params;
    let connection;
    try {
        connection = await mysql.createConnection(dbConfig);
        const query = 'SELECT precio FROM reparaciones WHERE id = ?';
        const [rows] = await connection.execute(query, [reparacion_id]);
        if (rows.length > 0) {
            res.json(rows[0]);
        } else {
            res.status(404).json({ error: 'Precio no encontrado.' });
        }
    } catch (error) {
        console.error('Error al obtener el precio:', error);
        res.status(500).json({ error: 'No se pudo obtener el precio.' });
    } finally {
        if (connection) await connection.end();
    }
});

// Ruta para obtener las reparaciones de un dispositivo específico
app.get('/api/reparaciones/:dispositivo_id', async (req, res) => {
    const { dispositivo_id } = req.params;
    let connection;
    try {
        connection = await mysql.createConnection(dbConfig);
        const query = 'SELECT id, descripcion_problema FROM reparaciones WHERE dispositivo_id = ? ORDER BY descripcion_problema';
        const [rows] = await connection.execute(query, [dispositivo_id]);
        res.json(rows);
    } catch (error) {
        console.error('Error al obtener reparaciones:', error);
        res.status(500).json({ error: 'No se pudo cargar la lista de reparaciones.' });
    } finally {
        if (connection) await connection.end();
    }
});

// Ruta para la información de contacto
app.get('/api/contact-info', (req, res) => {
    res.json({ whatsapp: process.env.WHATSAPP_NUMBER });
});

app.listen(port, () => {
    console.log(`Servidor escuchando en http://localhost:${port}`);
});
