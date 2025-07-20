import { db } from '$lib/server/db';
import type { RequestHandler } from './$types';
import { PUBLIC_SITE_URL } from '$env/static/public';

export const GET: RequestHandler = async () => {
	// Optimisasi: Ambil semua data secara bersamaan, bukan satu per satu
	const [latestPost, latestCategory, latestTag] = await Promise.all([
		db.post.findFirst({ orderBy: { updatedAt: 'desc' } }),
		db.category.findFirst({ orderBy: { updatedAt: 'desc' } }),
		db.tag.findFirst({ orderBy: { updatedAt: 'desc' } })
	]);

	// PERBAIKAN: Semua spasi inden di sini adalah spasi standar
	const xml = `<?xml version="1.0" encoding="UTF-8"?>
<sitemapindex xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
    <sitemap>
        <loc>${PUBLIC_SITE_URL}/sitemaps/posts.xml</loc>
        <lastmod>${latestPost?.updatedAt.toISOString() ?? new Date().toISOString()}</lastmod>
    </sitemap>
    <sitemap>
        <loc>${PUBLIC_SITE_URL}/sitemaps/categories.xml</loc>
        <lastmod>${latestCategory?.updatedAt.toISOString() ?? new Date().toISOString()}</lastmod>
    </sitemap>
    <sitemap>
        <loc>${PUBLIC_SITE_URL}/sitemaps/tags.xml</loc>
        <lastmod>${latestTag?.updatedAt.toISOString() ?? new Date().toISOString()}</lastmod>
    </sitemap>
</sitemapindex>`;

	return new Response(xml.trim(), { // Gunakan .trim() untuk kebersihan ekstra
		headers: {
			'Content-Type': 'application/xml',
			'Cache-Control': 'max-age=0, s-maxage=3600'
		}
	});
};