document.addEventListener('DOMContentLoaded', () => {

    // --- Elementos del DOM ---
    const dispositivoSelect = document.getElementById('dispositivo-select');
    const reparacionListaSelect = document.getElementById('reparacion-lista');
    const presupuestoForm = document.getElementById('presupuesto-form');
    
    const fieldsLista = document.getElementById('fields-lista');
    const fieldsIa = document.getElementById('fields-ia');
    
    const btnModeLista = document.getElementById('btn-mode-lista');
    const btnModeIa = document.getElementById('btn-mode-ia');

    const resultadoDiv = document.getElementById('resultado');
    const spinner = document.getElementById('spinner');
    const presupuestoTexto = document.getElementById('presupuesto-texto');

    // --- Lógica Principal ---

    // 1. Lógica del Control de Segmentos
    btnModeLista.addEventListener('click', () => {
        btnModeIa.classList.remove('active');
        btnModeLista.classList.add('active');
        fieldsIa.classList.add('d-none');
        fieldsLista.classList.remove('d-none');
        resultadoDiv.classList.add('d-none');
    });

    btnModeIa.addEventListener('click', () => {
        btnModeLista.classList.remove('active');
        btnModeIa.classList.add('active');
        fieldsLista.classList.add('d-none');
        fieldsIa.classList.remove('d-none');
        resultadoDiv.classList.add('d-none');
    });

    // 2. Cargar dispositivos al iniciar
    async function cargarDispositivos() {
        try {
            const response = await fetch('/api/dispositivos');
            if (!response.ok) throw new Error('Error al cargar');
            const dispositivos = await response.json();
            dispositivoSelect.innerHTML = '<option selected disabled value="">Selecciona un dispositivo...</option>';
            dispositivos.forEach(d => {
                const option = document.createElement('option');
                option.value = d.id;
                option.textContent = `${d.marca} ${d.nombre}`;
                dispositivoSelect.appendChild(option);
            });
        } catch (error) {
            console.error(error);
            dispositivoSelect.innerHTML = '<option selected disabled value="">Error al cargar</option>';
        }
    }
    cargarDispositivos();

    // 3. Lógica al cambiar el Dispositivo
    dispositivoSelect.addEventListener('change', async (e) => {
        const dispositivoId = e.target.value;
        if (!dispositivoId) return;
        resultadoDiv.classList.add('d-none');
        reparacionListaSelect.disabled = false;
        reparacionListaSelect.innerHTML = '<option selected disabled value="">Cargando...</option>';
        try {
            const response = await fetch(`/api/reparaciones/${dispositivoId}`);
            if (!response.ok) throw new Error('Error al cargar');
            const reparaciones = await response.json();
            reparacionListaSelect.innerHTML = '<option selected disabled value="">Selecciona una reparación...</option>';
            reparaciones.forEach(r => {
                const option = document.createElement('option');
                option.value = r.id;
                option.textContent = r.descripcion_problema;
                reparacionListaSelect.appendChild(option);
            });
        } catch (error) {
            console.error(error);
            reparacionListaSelect.innerHTML = '<option selected disabled value="">Error al cargar</option>';
        }
    });

    // 4. Lógica al seleccionar una Reparación de la lista (Modo Lista)
    reparacionListaSelect.addEventListener('change', async (e) => {
        const reparacionId = e.target.value;
        if (!reparacionId) return;
        resultadoDiv.classList.remove('d-none');
        presupuestoTexto.innerHTML = '';
        spinner.classList.remove('d-none');
        try {
            const response = await fetch(`/api/precio/${reparacionId}`);
            if (!response.ok) throw new Error('Precio no encontrado');
            const data = await response.json();
            presupuestoTexto.innerHTML = `<h5>Precio Exacto:</h5><p class="display-6">${data.precio} USD</p>`;
        } catch (error) {
            presupuestoTexto.innerHTML = `<div class="alert alert-warning">No se pudo obtener el precio.</div>`;
        } finally {
            spinner.classList.add('d-none');
        }
    });

    // 5. Lógica al enviar el formulario (Modo IA)
    presupuestoForm.addEventListener('submit', async (e) => {
        e.preventDefault();
        if (!btnModeIa.classList.contains('active')) return; // Solo actuar en modo IA

        const selectedDeviceOption = dispositivoSelect.options[dispositivoSelect.selectedIndex];
        const dispositivo = selectedDeviceOption.textContent;
        const problema = document.getElementById('problema-ia').value;
        const submitButton = e.submitter;

        if (!dispositivoSelect.value || !problema) {
            alert('Por favor, selecciona un dispositivo y describe el problema.');
            return;
        }

        submitButton.disabled = true;
        resultadoDiv.classList.remove('d-none');
        spinner.classList.remove('d-none');
        presupuestoTexto.innerHTML = '';

        try {
            const response = await fetch('/api/presupuesto', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ dispositivo, problema })
            });
            if (!response.ok) {
                const errorData = await response.json();
                throw new Error(errorData.error || 'Hubo un problema');
            }
            const data = await response.json();
            presupuestoTexto.innerHTML = data.presupuesto.replace(/\n/g, '<br>');
        } catch (error) {
            presupuestoTexto.innerHTML = `<div class="alert alert-danger">${error.message}</div>`;
        } finally {
            spinner.classList.add('d-none');
            submitButton.disabled = false;
        }
    });

    // --- Lógica General de la Página (Scroll, WhatsApp, etc.) ---
    document.querySelectorAll('a.nav-link[href^="#"], a.btn[href^="#presupuesto-section"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            document.querySelector(this.getAttribute('href')).scrollIntoView({ behavior: 'smooth' });
        });
    });

    fetch('/api/contact-info').then(r => r.json()).then(d => {
        const fab = document.getElementById('whatsapp-fab');
        const hero = document.getElementById('whatsapp-hero-button');
        if (d.whatsapp) {
            const link = `https://wa.me/${d.whatsapp}`;
            if (fab) { fab.href = link; fab.classList.remove('d-none'); }
            if (hero) { hero.href = link; }
        }
    });
});