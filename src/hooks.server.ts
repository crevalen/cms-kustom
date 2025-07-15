// src/hooks.server.ts

import { validateSession } from '$lib/server/auth';
import type { Handle } from '@sveltejs/kit';

// Daftar domain yang diizinkan untuk mengakses API kita
// Untuk development, kita izinkan localhost. Nanti kita ganti dengan domain frontend Anda.
const allowedOrigins = ['http://localhost:5174']; // Anggap saja frontend jalan di port 5174

export const handle: Handle = async ({ event, resolve }) => {
	// Logika Autentikasi yang sudah ada
	const sessionId = event.cookies.get('session_id');
	if (!sessionId) {
		event.locals.user = null;
		event.locals.session = null;
	} else {
		const { user, session } = await validateSession(sessionId);
		if (user && session) {
			event.locals.user = user;
			event.locals.session = session;
		} else {
			event.locals.user = null;
			event.locals.session = null;
		}
	}

	// Logika CORS untuk request API
	if (event.request.method === 'OPTIONS' && event.url.pathname.startsWith('/api')) {
		const origin = event.request.headers.get('Origin');
		if (origin && allowedOrigins.includes(origin)) {
			return new Response(null, {
				headers: {
					'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, PATCH, OPTIONS',
					'Access-Control-Allow-Origin': origin,
					'Access-Control-Allow-Headers': 'Content-Type'
				}
			});
		}
		return new Response(null);
	}

	const response = await resolve(event);

	// Tambahkan header CORS ke semua respons dari API
	if (event.url.pathname.startsWith('/api')) {
		const origin = event.request.headers.get('Origin');
		if (origin && allowedOrigins.includes(origin)) {
			response.headers.set('Access-Control-Allow-Origin', origin);
		}
	}

	return response;
};