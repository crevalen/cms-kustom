// src/routes/admin/users/new/+page.server.ts

import { db } from '$lib/server/db';
import { fail, redirect } from '@sveltejs/kit';
import type { Actions} from './$types';
import { hashPassword } from '$lib/server/auth';
import { Role } from '@prisma/client';

export const actions: Actions = {
	default: async ({ request }) => {
		const formData = await request.formData();
		const username = formData.get('username') as string;
		const password = formData.get('password') as string;
		const role = formData.get('role') as Role;

		if (!username || username.length < 4) {
			return fail(400, { success: false, message: 'Username minimal 4 karakter.' });
		}
		if (!password || password.length < 6) {
			return fail(400, { success: false, message: 'Password minimal 6 karakter.' });
		}
		if (!role || !Object.values(Role).includes(role)) {
			return fail(400, { success: false, message: 'Role tidak valid.' });
		}

		try {
			const passwordHash = await hashPassword(password);
			await db.user.create({
				data: { username, passwordHash, role }
			});
		} catch {
			return fail(500, { success: false, message: 'Username sudah digunakan.' });
		}

		throw redirect(302, '/admin/users');
	}
};