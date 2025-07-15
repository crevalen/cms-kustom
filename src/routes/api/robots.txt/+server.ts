// src/routes/api/robots.txt/+server.ts

import { db } from '$lib/server/db';
import type { RequestHandler } from './$types';

export const GET: RequestHandler = async () => {
	const setting = await db.setting.findUnique({
		where: { key: 'robots_txt_content' }
	});
	
	const defaultContent = 
`User-agent: *
Allow: /

Sitemap: ${process.env.PUBLIC_SITE_URL}/sitemap.xml`;

	const content = setting?.value ?? defaultContent;

	return new Response(content, {
		headers: {
			'Content-Type': 'text/plain'
		}
	});
};