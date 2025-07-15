// src/routes/api/posts/kategori/[slug]/+server.ts
import { db } from '$lib/server/db';
import { error, json } from '@sveltejs/kit';
import type { RequestHandler } from './$types';

export const GET: RequestHandler = async ({ params }) => {
	const { slug } = params;

	// Ambil detail kategori dan semua postingan di dalamnya
	const categoryWithPosts = await db.category.findUnique({
		where: { slug },
		include: {
			posts: {
				where: { published: true, publishedAt: { lte: new Date() } },
				include: { featuredImage: true },
				orderBy: { createdAt: 'desc' }
			}
		}
	});

	if (!categoryWithPosts) {
		throw error(404, 'Kategori tidak ditemukan');
	}

	return json(categoryWithPosts);
};