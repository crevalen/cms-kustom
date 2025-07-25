import { db } from '$lib/server/db';
import { json } from '@sveltejs/kit';
import type { RequestHandler } from './$types';
import he from 'he';

export const GET: RequestHandler = async ({ url }) => {
	const page = Number(url.searchParams.get('page') ?? '1');
	const limit = 10;

	const [
		featuredPost,
		popularPosts,
		gridPosts,
		storyPosts,
		totalPosts,
		paginatedPosts
	] = await Promise.all([
		db.post.findFirst({
			where: { published: true },
			orderBy: { createdAt: 'desc' },
			include: { // 'content' sudah otomatis terpanggil, jadi kita hapus dari sini
				categories: { take: 1 },
				featuredImage: true
			}
		}),
		db.post.findMany({
			where: { published: true },
			orderBy: { viewCount: 'desc' },
			take: 5,
			include: { categories: { take: 1 }, featuredImage: true }
		}),
		db.post.findMany({
			where: { published: true, categories: { some: { slug: 'tips' } } },
			orderBy: { createdAt: 'desc' },
			take: 6,
			include: { categories: { take: 1 }, featuredImage: true }
		}),

		db.post.findMany({
			where: { published: true, categories: { some: { slug: 'story' } } },
			orderBy: { createdAt: 'desc' },
			take: 4,
			include: { categories: { take: 1 }, featuredImage: true }
		}),
		db.post.count({ where: { published: true } }),
		db.post.findMany({
			where: { published: true },
			orderBy: { createdAt: 'desc' },
			skip: (page - 1) * limit,
			take: limit,
			include: { categories: { take: 1 }, author: true, featuredImage: true }
		})
	]);

	if (!featuredPost) {
		return json({
			featuredPost: null,
			popularPosts: [],
			gridPosts: [],
			paginatedPosts: [],
			pagination: { currentPage: page, totalPages: 0 }
		});
	}

	const contentForExcerpt = featuredPost.content || '';
	const plainTextContent = contentForExcerpt.replace(/<[^>]*>/g, '');
	const decodedText = he.decode(plainTextContent); 
	const excerpt = decodedText.substring(0, 150) + (decodedText.length > 150 ? '...' : '');
	
	const totalPages = Math.ceil(totalPosts / limit);

	return json({
		featuredPost: { ...featuredPost, excerpt },
		popularPosts,
		gridPosts,
		storyPosts,
		paginatedPosts,
		pagination: {
			currentPage: page,
			totalPages
		}
	});
};