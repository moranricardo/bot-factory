/**
 * Módulo de Comentarios - Automatización Local
 * Entorno: Node.js ESM
 */

export const registrarComentario = (mensaje) => {
    const fecha = new Date().toISOString();
    console.log([`[${fecha}] Comentario registrado: ${mensaje}`]);
};

export const obtenerEstado = () => {
    return { activo: true, timestamp: Date.now() };
};
