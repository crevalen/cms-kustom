// src/routes/api/pages/[slug]/+server.ts

import { db } from '$lib/server/db';
import { error, json } from '@sveltejs/kit';
import type { RequestHandler } from './$types';
import { marked } from 'marked';

export const GET: RequestHandler = async ({ params }) => {
	const page = await db.page.findFirst({
		where: {
			slug: params.slug,
			published: true
		}
	});

	if (!page) {
		throw error(404, 'Halaman tidak ditemukan');
	}

	const contentHtml = await marked.parse(page.content);

	return json({
		...page,
		content: contentHtml
	});
};