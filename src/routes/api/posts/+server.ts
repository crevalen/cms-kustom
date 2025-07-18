import { db } from '$lib/server/db';
import { json } from '@sveltejs/kit';
import type { RequestHandler } from './$types';

export const GET: RequestHandler = async () => {
	const posts = await db.post.findMany({
		where: { published: true },
		include: {
			featuredImage: true,
			categories: {
				select: {
					slug: true,
					name: true // <-- TAMBAHKAN NAMA KATEGORI
				},
				take: 1
			}
		},
		select: { // <-- Ganti 'include' menjadi 'select' untuk performa
			slug: true,
			title: true,
			publishedAt: true, // <-- TAMBAHKAN TANGGAL PUBLIKASI
			featuredImage: true,
			categories: true
		},
		orderBy: {
			createdAt: 'desc'
		}
	});
	return json(posts);
};