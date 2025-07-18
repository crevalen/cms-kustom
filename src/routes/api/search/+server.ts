import { db } from '$lib/server/db';
import { json } from '@sveltejs/kit';
import type { RequestHandler } from './$types';

export const GET: RequestHandler = async ({ url }) => {
	const query = url.searchParams.get('q');

	if (!query) {
		return json({ posts: [] });
	}

	const posts = await db.post.findMany({
		where: {
			published: true,
			// PERUBAHAN: Mencari di 4 tempat, bukan 2
			OR: [
				{ title: { contains: query, mode: 'insensitive' } },      // 1. Cari di Judul
				{ content: { contains: query, mode: 'insensitive' } },    // 2. Cari di Konten
				{ 
					tags: {                                               // 3. Cari di Tags
						some: { name: { contains: query, mode: 'insensitive' } } 
					} 
				},
				{ 
					categories: {                                         // 4. Cari di Kategori
						some: { name: { contains: query, mode: 'insensitive' } } 
					} 
				}
			]
		},
		include: {
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