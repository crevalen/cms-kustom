// src/routes/admin/users/[userId]/edit/+page.server.ts

import { db } from '$lib/server/db';
import { error, fail, redirect } from '@sveltejs/kit';
import type { Actions, PageServerLoad } from './$types';
import { Role } from '@prisma/client';
import { hashPassword } from '$lib/server/auth';

export const load: PageServerLoad = async ({ params }) => {
	const user = await db.user.findUnique({
		where: { id: params.userId }
	});
	if (!user) {
		throw error(404, 'User tidak ditemukan.');
	}
	return { user };
};

export const actions: Actions = {
	default: async ({ request, params }) => {
		const formData = await request.formData();
		const username = formData.get('username') as string;
		const password = formData.get('password') as string;
		const role = formData.get('role') as Role;

		if (!username || username.length < 4) {
			return fail(400, { error: 'Username minimal 4 karakter.' });
		}
		if (!role || !Object.values(Role).includes(role)) {
			return fail(400, { error: 'Role tidak valid.' });
		}

		try {
			const dataToUpdate: { username: string; role: Role; passwordHash?: string } = {
				username,
				role
			};

			// Hanya update password jika diisi
			if (password && password.length > 0) {
				if (password.length < 6) {
					return fail(400, { error: 'Password baru minimal 6 karakter.' });
				}
				dataToUpdate.passwordHash = await hashPassword(password);
			}

			await db.user.update({
				where: { id: params.userId },
				data: dataToUpdate
			});
		} catch {
			return fail(500, { error: 'Username mungkin sudah digunakan.' });
		}
		throw redirect(302, '/admin/users');
	}
};