// src/routes/login/+page.server.ts

import { fail, redirect } from '@sveltejs/kit';
import type { Actions, PageServerLoad } from './$types';
import { db } from '$lib/server/db';
import { verifyPassword, createSession } from '$lib/server/auth';

// Fungsi 'load' ini berjalan sebelum halaman ditampilkan.
// Jika user sudah login, kita langsung arahkan (redirect) ke halaman admin.
export const load: PageServerLoad = async ({ locals }) => {
	if (locals.user) {
		throw redirect(302, '/admin');
	}
};

export const actions: Actions = {
	// Ini adalah action 'default' yang akan dijalankan oleh form kita
	default: async (event) => {
		const formData = await event.request.formData();
		const username = formData.get('username');
		const password = formData.get('password');

		// Validasi dasar
		if (typeof username !== 'string' || username.length < 3) {
			return fail(400, { error: 'Username tidak valid' });
		}
		if (typeof password !== 'string' || password.length < 6) {
			return fail(400, { error: 'Password tidak valid' });
		}

		// Cari user di database
		const user = await db.user.findUnique({
			where: { username: username }
		});

		if (!user) {
			return fail(400, { error: 'Username atau password salah' });
		}

		// Verifikasi password
		const validPassword = await verifyPassword(user.passwordHash, password);
		if (!validPassword) {
			return fail(400, { error: 'Username atau password salah' });
		}

		// Jika berhasil, buat sesi
		const sessionId = await createSession(user.id);
		event.cookies.set('session_id', sessionId, {
			path: '/', // Cookie berlaku untuk seluruh situs
			httpOnly: true, // Cookie hanya bisa diakses oleh server
			sameSite: 'strict',
			secure: process.env.NODE_ENV === 'production', // 'true' jika HTTPS
			maxAge: 60 * 60 * 24 * 30 // Cookie berlaku selama 30 hari
		});

		// Arahkan ke halaman admin setelah login berhasil
		throw redirect(302, '/admin');
	}
};