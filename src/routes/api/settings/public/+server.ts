// src/routes/api/settings/public/+server.ts
import { db } from '$lib/server/db';
import { json } from '@sveltejs/kit';
import type { RequestHandler } from './$types';

export const GET: RequestHandler = async () => {
	const settings = await db.setting.findMany();

	const settingsMap = settings.reduce(
		(acc: Record<string, string>, setting) => {
			acc[setting.key] = setting.value;
			return acc;
		},
		{}
	);

	return json(settingsMap);
};