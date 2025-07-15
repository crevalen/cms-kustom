// src/routes/api/posts/tag/[slug]/+server.ts
import { db } from '$lib/server/db';
import { error, json } from '@sveltejs/kit';
import type { RequestHandler } from './$types';

export const GET: RequestHandler = async ({ params }) => {
	const { slug } = params;

	// Ambil detail tag dan semua postingan di dalamnya
	const tagWithPosts = await db.tag.findUnique({
		where: { slug },
		include: {
			posts: {
				where: { published: true, publishedAt: { lte: new Date() } },
				include: { featuredImage: true },
				orderBy: { createdAt: 'desc' }
			}
		}
	});

	if (!tagWithPosts) {
		throw error(404, 'Tag tidak ditemukan');
	}

	return json(tagWithPosts);
};