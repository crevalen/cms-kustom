import { db } from '$lib/server/db';
import type { RequestHandler } from './$types';
import { PUBLIC_SITE_URL } from '$env/static/public';

const websiteUrl = PUBLIC_SITE_URL;

export const GET: RequestHandler = async () => {
	const posts = await db.post.findMany({
		where: { published: true },
		select: { slug: true, updatedAt: true },
		orderBy: { createdAt: 'desc' }
	});

	const xml = `<?xml version="1.0" encoding="UTF-8" ?>
<urlset xmlns="https://www.sitemaps.org/schemas/sitemap/0.9">
    ${posts
		.map(
			(post) => `<url>
        <loc>${websiteUrl}/blog/${post.slug}</loc>
        <lastmod>${post.updatedAt.toISOString()}</lastmod>
        <changefreq>weekly</changefreq>
        <priority>0.8</priority>
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