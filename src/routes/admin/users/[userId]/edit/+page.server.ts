// src/routes/admin/users/[userId]/edit/+page.server.ts

import { db } from '$lib/server/db';
import { error, fail } from '@sveltejs/kit';
import type { Actions, PageServerLoad } from './$types';
import { Role, Prisma } from '@prisma/client';
import { hashPassword } from '$lib/server/auth';
import { uploadImage } from '$lib/server/r2';

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
		const displayName = formData.get('displayName') as string;
		const bio = formData.get('bio') as string;
		const avatarFile = formData.get('avatar') as File;

		// Validasi
		if (!username || username.length < 4) {
			return fail(400, { success: false, message: 'Username minimal 4 karakter.' });
		}
		if (!role || !Object.values(Role).includes(role)) {
			return fail(400, { success: false, message: 'Role tidak valid.' });
		}

		try {
			const dataToUpdate: Prisma.UserUpdateInput = {
				username,
				role,
				displayName,
				bio
			};

			if (password && password.length > 0) {
				if (password.length < 6) {
					return fail(400, { success: false, message: 'Password baru minimal 6 karakter.' });
				}
				dataToUpdate.passwordHash = await hashPassword(password);
			}

			if (avatarFile && avatarFile.size > 0) {
				const newAvatar = await uploadImage(avatarFile);
				dataToUpdate.avatarUrl = newAvatar.url;
			}

			await db.user.update({
				where: { id: params.userId },
				data: dataToUpdate
			});
		} catch {
			return fail(500, { success: false, message: 'Username mungkin sudah digunakan.' });
		}

		return { success: true, message: 'Profil pengguna berhasil diperbarui!' };
	}
};