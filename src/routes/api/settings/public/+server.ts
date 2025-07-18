// src/routes/api/settings/public/+server.ts
import { db } from '$lib/server/db';
import { json } from '@sveltejs/kit';
import type { RequestHandler } from './$types';

// Daftar kunci pengaturan yang aman untuk diekspos ke publik
const publicSettingKeys = [
	'site_title',
	'site_description',
	'site_favicon_url',
	'site_logo_url',
	'publisher_name',
	'publisher_logo_url',
	'gsc_verification_code',
	'bing_verification_code',
	'yandex_verification_code',
	'ga4_id',
	'custom_head_script',
	'custom_footer_script'
];

export const GET: RequestHandler = async () => {
	const settings = await db.setting.findMany({
		where: {
			key: { in: publicSettingKeys }
		}
	});

	// Ubah array menjadi objek agar mudah diakses di frontend
	const settingsMap = settings.reduce(
		(acc: Record<string, string>, setting) => {
			acc[setting.key] = setting.value;
			return acc;
		},
		{}
	);

	return json(settingsMap);
};