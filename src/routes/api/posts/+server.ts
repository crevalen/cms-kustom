import { db } from '$lib/server/db';
import { json } from '@sveltejs/kit';
import type { RequestHandler } from './$types';

export const GET: RequestHandler = async () => {
	const posts = await db.post.findMany({
		where: { published: true },
		// Kita perbaiki struktur 'select' di sini
		select: {
			slug: true,
			title: true,
			publishedAt: true,
			categories: {
				select: {
					slug: true,
					name: true
				},
				take: 1
			},
			// PERBAIKAN: Secara eksplisit minta 'url' dari 'featuredImage'
			featuredImage: {
				select: {
					url: true
				}
			}
		},
		orderBy: {
			createdAt: 'desc'
		}
	});
	return json(posts);
};