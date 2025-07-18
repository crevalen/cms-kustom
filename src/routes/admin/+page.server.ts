// src/routes/admin/+page.server.ts

import { db } from '$lib/server/db';
import type { PageServerLoad } from './$types';

export const load: PageServerLoad = async ({ locals }) => {
	const [postStats, categoryCount, tagCount, totalComments, pendingComments, popularPosts] =
		await Promise.all([
			db.post.aggregate({
				where: { authorId: locals.user?.id },
				_count: { id: true },
				_sum: { viewCount: true }
			}),
			db.category.count(),
			db.tag.count(),
			db.comment.count(),
			db.comment.count({ where: { isApproved: false } }),
			// Ambil 5 postingan paling populer berdasarkan viewCount
			db.post.findMany({
				where: { authorId: locals.user?.id },
				orderBy: { viewCount: 'desc' },
				take: 5,
				select: {
					title: true,
					slug: true,
					viewCount: true
				}
			})
		]);

	return {
		user: locals.user,
		stats: {
			posts: postStats._count.id,
			views: postStats._sum.viewCount ?? 0,
			categories: categoryCount,
			tags: tagCount,
			comments: totalComments,
			pendingComments: pendingComments
		},
		popularPosts // Kirim data postingan populer ke halaman
	};
};