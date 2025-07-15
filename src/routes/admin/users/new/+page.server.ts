// src/routes/admin/users/new/+page.server.ts

import { db } from '$lib/server/db';
import { fail, redirect } from '@sveltejs/kit';
import type { Actions, PageServerLoad } from './$types';
import { hashPassword } from '$lib/server/auth';
import { Role } from '@prisma/client';

// Kita tidak perlu load data apa pun untuk halaman baru
export const load: PageServerLoad = async () => {
	return {};
};

export const actions: Actions = {
	default: async ({ request }) => {
		const formData = await request.formData();
		const username = formData.get('username') as string;
		const password = formData.get('password') as string;
		const role = formData.get('role') as Role;

		// Validasi input
		if (!username || username.length < 4) {
			return fail(400, { error: 'Username minimal 4 karakter.' });
		}
		if (!password || password.length < 6) {
			return fail(400, { error: 'Password minimal 6 karakter.' });
		}
		if (!role || !Object.values(Role).includes(role)) {
			return fail(400, { error: 'Role tidak valid.' });
		}

		try {
			// Hash password sebelum disimpan
			const passwordHash = await hashPassword(password);

			await db.user.create({
				data: {
					username,
					passwordHash,
					role
				}
			});
		} catch {
			// Menangani jika username sudah ada
			return fail(500, { error: 'Username sudah digunakan.' });
		}

		// Arahkan kembali ke daftar pengguna setelah berhasil
		throw redirect(302, '/admin/users');
	}
};