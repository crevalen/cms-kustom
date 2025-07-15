import { db } from '$lib/server/db';
import type { RequestHandler } from './$types';
import { PUBLIC_SITE_URL } from '$env/static/public';

const websiteUrl = PUBLIC_SITE_URL;

export const GET: RequestHandler = async () => {
	const categories = await db.category.findMany({
		select: { slug: true, updatedAt: true },
		orderBy: { name: 'asc' }
	});

	const xml = `<?xml version="1.0" encoding="UTF-8" ?>
<urlset xmlns="https://www.sitemaps.org/schemas/sitemap/0.9">
    ${categories
		.map(
			(category) => `<url>
        <loc>${websiteUrl}/kategori/${category.slug}</loc>
        <lastmod>${category.updatedAt.toISOString()}</lastmod>
        <changefreq>weekly</changefreq>
        <priority>0.6</priority>
    </url>`
		)
		.join('')}
</urlset>`;

	return new Response(xml, {
		headers: {
			'Content-Type': 'application/xml'
		}
	});
};