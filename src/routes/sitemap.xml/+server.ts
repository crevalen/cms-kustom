import { db } from '$lib/server/db';
import type { RequestHandler } from './$types';
import { PUBLIC_SITE_URL } from '$env/static/public';

const websiteUrl = PUBLIC_SITE_URL; // Ganti dengan URL Anda

export const GET: RequestHandler = async () => {
	// Ambil tanggal update terakhir dari setiap tipe konten
	const post = await db.post.findFirst({ orderBy: { updatedAt: 'desc' } });
	const category = await db.category.findFirst({ orderBy: { updatedAt: 'desc' } });
	const tag = await db.tag.findFirst({ orderBy: { updatedAt: 'desc' } });

	const xml = `<?xml version="1.0" encoding="UTF-8"?>
<sitemapindex xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
    <sitemap>
        <loc>${websiteUrl}/sitemaps/posts.xml</loc>
        <lastmod>${post?.updatedAt.toISOString() ?? new Date().toISOString()}</lastmod>
    </sitemap>
    <sitemap>
        <loc>${websiteUrl}/sitemaps/categories.xml</loc>
        <lastmod>${category?.updatedAt.toISOString() ?? new Date().toISOString()}</lastmod>
    </sitemap>
    <sitemap>
        <loc>${websiteUrl}/sitemaps/tags.xml</loc>
        <lastmod>${tag?.updatedAt.toISOString() ?? new Date().toISOString()}</lastmod>
    </sitemap>
</sitemapindex>`;

	return new Response(xml, {
		headers: {
			'Content-Type': 'application/xml',
			'Cache-Control': 'max-age=0, s-maxage=3600'
		}
	});
};