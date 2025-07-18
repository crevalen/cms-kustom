import { db } from '$lib/server/db';
import { json } from '@sveltejs/kit';
import type { RequestHandler } from './$types';

export const GET: RequestHandler = async () => {
	const popularPosts = await db.post.findMany({
		where: {
			published: true // Pastikan hanya postingan yang sudah terbit
		},
		orderBy: {
			viewCount: 'desc' // Urutkan berdasarkan viewCount
		},
		take: 7, // Ambil 5 teratas
		select: { // Ambil data yang kita butuhkan untuk sidebar
			title: true,
			slug: true,
			publishedAt: true,
			featuredImage: {
				select: { url: true }
			},
			categories: {
				select: { name: true, slug: true },
				take: 1
			}
		}
	});

	return json(popularPosts);
};