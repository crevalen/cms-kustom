import { db } from '$lib/server/db';
import { error, json } from '@sveltejs/kit';
import type { RequestHandler } from './$types';

export const GET: RequestHandler = async ({ params }) => {
	// 1. Cari tag berdasarkan slug dari URL
	const tag = await db.tag.findUnique({
		where: { slug: params.slug },
		include: {
			// 2. Sertakan semua postingan yang terhubung dengan tag ini
			posts: {
				where: {
					published: true,
				},
				// 3. Sertakan juga data yang dibutuhkan oleh PostCard
				include: {
					featuredImage: true,
					categories: {
						select: { slug: true, name: true },
						take: 1
					}
				},
				orderBy: {
					createdAt: 'desc'
				}
			}
		}
	});

	if (!tag) {
		throw error(404, 'Tag tidak ditemukan');
	}

	return json(tag);
};