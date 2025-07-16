// src/routes/admin/+page.server.ts

import { db } from '$lib/server/db';
import type { PageServerLoad } from './$types';

export const load: PageServerLoad = async ({ locals }) => {
	// Ambil semua data statistik secara paralel untuk efisiensi
	const [postStats, categoryCount, tagCount, totalComments, pendingComments, recentPosts] =
		await Promise.all([
			db.post.aggregate({
				where: { authorId: locals.user?.id },
				_count: { id: true },
				_sum: { viewCount: true }
			}),
			db.category.count(),
			db.tag.count(),
			db.comment.count(), // <-- Hitung semua komentar
			db.comment.count({ where: { isApproved: false } }), // <-- Hitung komentar pending
			db.post.findMany({
				where: { authorId: locals.user?.id },
				take: 5,
				orderBy: { createdAt: 'desc' }
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
		recentPosts
	};
};