// src/routes/api/posts/+server.ts

import { db } from '$lib/server/db';
import { json } from '@sveltejs/kit';
import type { RequestHandler } from './$types';

export const GET: RequestHandler = async () => {
	// Ambil semua postingan yang sudah di-publish
	const posts = await db.post.findMany({
		where: {
			published: true
		},
		include: {
			featuredImage: true // Sertakan data gambar
		},
		orderBy: {
			createdAt: 'desc'
		}
	});

	// Kirim data sebagai respons JSON
	return json(posts);
};