// src/routes/api/tags/+server.ts
import { db } from '$lib/server/db';
import { json } from '@sveltejs/kit';
import type { RequestHandler } from './$types';

export const GET: RequestHandler = async () => {
	const tags = await db.tag.findMany({
		orderBy: { name: 'asc' }
	});
	return json(tags);
};