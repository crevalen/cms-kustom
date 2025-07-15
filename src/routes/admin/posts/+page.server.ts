// src/routes/admin/posts/+page.server.ts

import { db } from '$lib/server/db';
import type { Actions, PageServerLoad } from './$types';
import { error, fail } from '@sveltejs/kit';

export const load: PageServerLoad = async ({ locals }) => {
	const posts = await db.post.findMany({
		where: {
			authorId: locals.user?.id
		},
		// Ambil juga data relasi untuk ditampilkan di tabel
		include: {
			author: true,
			categories: true,
			tags: true
		},
		orderBy: {
			createdAt: 'desc'
		}
	});

	return { posts };
};

export const actions: Actions = {
	delete: async ({ request, locals }) => {
		const formData = await request.formData();
		const id = formData.get('id');

		if (!id || typeof id !== 'string') {
			return fail(400, { message: 'ID tidak valid' });
		}

		const post = await db.post.findUnique({
			where: { id }
		});

		if (!post) {
			return fail(404, { message: 'Postingan tidak ditemukan' });
		}

		if (post.authorId !== locals.user?.id) {
			throw error(403, 'Anda tidak memiliki izin untuk menghapus postingan ini');
		}

		await db.post.delete({
			where: { id }
		});

		return { success: true };
	}
};