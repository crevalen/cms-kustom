import { db } from '$lib/server/db';
import { json } from '@sveltejs/kit';
import type { RequestHandler } from './$types';

export const GET: RequestHandler = async () => {
	const pages = await db.page.findMany({
		where: {
			published: true
		},
		select: {
			title: true, 
			slug: true
		},
		orderBy: {
			createdAt: 'asc'
		}
	});

	return json(pages);
};