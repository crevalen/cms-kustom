// src/routes/admin/settings/robots/+page.server.ts

import { db } from '$lib/server/db';
import type { Actions, PageServerLoad } from './$types';

const SETTING_KEY = 'robots_txt_content';

export const load: PageServerLoad = async () => {
	const setting = await db.setting.findUnique({
		where: { key: SETTING_KEY }
	});
    
    // Sediakan nilai default jika belum ada di database
	const defaultContent = 
`User-agent: *
Allow: /

Sitemap: ${process.env.PUBLIC_SITE_URL}/sitemap.xml`;

	return {
		content: setting?.value ?? defaultContent
	};
};

export const actions: Actions = {
	default: async ({ request }) => {
		const formData = await request.formData();
		const content = formData.get('content') as string;

		try {
			await db.setting.upsert({
				where: { key: SETTING_KEY },
				update: { value: content },
				create: { key: SETTING_KEY, value: content }
			});
		} catch {
			return { success: false, message: 'Gagal menyimpan robots.txt.' };
		}

		return { success: true, message: 'File robots.txt berhasil disimpan!' };
	}
};