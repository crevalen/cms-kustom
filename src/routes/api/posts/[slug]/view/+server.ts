// src/routes/api/posts/[slug]/view/+server.ts

import { db } from '$lib/server/db';
import { json, error } from '@sveltejs/kit';
import type { RequestHandler } from './$types';

export const POST: RequestHandler = async ({ params }) => {
	const { slug } = params;

	if (!slug) {
		throw error(400, 'Slug tidak valid.');
	}

	try {
		// Gunakan operasi 'increment' dari Prisma untuk menambah 1 secara aman
		const updatedPost = await db.post.update({
			where: { slug: slug },
			data: {
				viewCount: {
					increment: 1
				}
			},
			select: {
				viewCount: true // Hanya ambil kembali data view count yang baru
			}
		});

		if (!updatedPost) {
			throw error(404, 'Postingan tidak ditemukan.');
		}

		return json({ newViewCount: updatedPost.viewCount });
	} catch (err) {
		// Ini akan menangani jika postingan tidak ditemukan atau ada error lain
		throw error(500, 'Gagal memperbarui jumlah view.');
	}
};