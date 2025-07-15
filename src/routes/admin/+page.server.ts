// src/routes/admin/+page.server.ts

import { db } from '$lib/server/db';
import type { PageServerLoad } from './$types';

export const load: PageServerLoad = async ({ locals }) => {
	const [postCount, categoryCount, tagCount, recentPosts] = await Promise.all([
		db.post.count({ where: { authorId: locals.user?.id } }),
		db.category.count(),
		db.tag.count(),
		db.post.findMany({
			where: { authorId: locals.user?.id },
			take: 5,
			orderBy: { createdAt: 'desc' }
		})
	]);

	return {
		user: locals.user,
		stats: {
			posts: postCount,
			categories: categoryCount,
			tags: tagCount
		},
		recentPosts
	};
};