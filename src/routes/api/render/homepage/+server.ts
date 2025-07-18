import { db } from '$lib/server/db';
import { json } from '@sveltejs/kit';
import type { RequestHandler } from './$types';

export const GET: RequestHandler = async ({ url }) => {
	const page = Number(url.searchParams.get('page') ?? '1');
	const limit = 10; // Jumlah artikel per halaman untuk daftar utama
	const plainTextContent = featuredPost?.content.replace(/<[^>]*>/g, '') || '';
	const excerpt = plainTextContent.substring(0, 150) + (plainTextContent.length > 150 ? '...' : '');

	// Ambil semua data yang dibutuhkan secara bersamaan
	const [
		featuredPost,
		popularPosts,
		gridPostsFromTips,
		totalPosts,
		paginatedPosts
	] = await Promise.all([
		// 1. Ambil 1 artikel paling baru untuk jadi sorotan utama
		db.post.findFirst({
			where: { published: true },
			orderBy: { publishedAt: 'desc' },
			include: { categories: { take: 1 }, featuredImage: true }
		}),
		// 2. Ambil 5 artikel populer (ini sama seperti di sidebar)
		db.post.findMany({
			where: { published: true },
			orderBy: { viewCount: 'desc' },
			take: 5,
			include: { categories: { take: 1 }, featuredImage: true }
		}),
		// 3. Ambil 6 artikel berikutnya untuk layout grid
		db.post.findMany({
			where: {
				published: true,
				categories: {
					some: {
						slug: 'tips' // Filter berdasarkan slug kategori
					}
				}
			},
			orderBy: { publishedAt: 'desc' },
			take: 6,
			include: { categories: { take: 1 }, featuredImage: true }
		}),
		// 4. Hitung total semua artikel untuk pagination
		db.post.count({ where: { published: true } }),
		// 5. Ambil daftar artikel untuk list utama dengan pagination
		db.post.findMany({
			where: { published: true },
			orderBy: { publishedAt: 'desc' },
			skip: (page - 1) * limit,
			take: limit,
			include: { categories: { take: 1 }, author: true, featuredImage: true }
		})
	]);
	
	const totalPages = Math.ceil(totalPosts / limit);

	return json({
		featuredPost: featuredPost ? { ...featuredPost, excerpt } : null, 
		popularPosts,
		gridPosts: gridPostsFromTips, // Kembalikan sebagai gridPosts
		paginatedPosts,
		pagination: {
			currentPage: page,
			totalPages
		}
	});
};