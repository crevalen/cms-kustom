import { db } from '$lib/server/db';
import { json } from '@sveltejs/kit';
import type { RequestHandler } from './$types';

export const GET: RequestHandler = async ({ url }) => {
	// Ambil kata kunci 'q' dari URL, contoh: /api/search?q=sveltekit
	const query = url.searchParams.get('q');

	if (!query) {
		return json({ posts: [] }); // Kembalikan array kosong jika tidak ada query
	}

	// Cari postingan di database
	const posts = await db.post.findMany({
		where: {
			published: true,
			OR: [ // Cari di beberapa kolom sekaligus
				{ title: { contains: query, mode: 'insensitive' } }, // Cari di judul
				{ content: { contains: query, mode: 'insensitive' } }, // Cari di konten
			]
		},
		include: { // Sertakan data yang dibutuhkan oleh PostCard
			featuredImage: true,
			categories: {
				select: { slug: true },
				take: 1
			}
		},
		orderBy: {
			createdAt: 'desc'
		}
	});

	return json({ posts });
};