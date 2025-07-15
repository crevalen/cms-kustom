// src/routes/api/categories/+server.ts
import { db } from '$lib/server/db';
import { json } from '@sveltejs/kit';
import type { RequestHandler } from './$types';

export const GET: RequestHandler = async () => {
	const categories = await db.category.findMany({
		orderBy: { name: 'asc' }
	});
	return json(categories);
};