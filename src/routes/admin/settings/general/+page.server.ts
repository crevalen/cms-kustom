// src/routes/admin/settings/general/+page.server.ts

import { db } from '$lib/server/db';
import { uploadImage } from '$lib/server/r2';
import type { Actions, PageServerLoad } from './$types';

// Daftar semua kunci pengaturan yang akan kita kelola di halaman ini
const settingKeys = [
	'site_favicon_url',
	'site_logo_url',
	'publisher_logo_url',
	'gsc_verification_code',
	'bing_verification_code',
	'yandex_verification_code',
	'ga4_id',
	'custom_head_script',
	'custom_footer_script'
];

export const load: PageServerLoad = async () => {
	const settings = await db.setting.findMany({
		where: { key: { in: settingKeys } }
	});

	const settingsMap = settings.reduce(
		(acc: Record<string, string>, setting) => {
			acc[setting.key] = setting.value;
			return acc;
		},
		{}
	);

	return { settings: settingsMap };
};

export const actions: Actions = {
	default: async ({ request }) => {
		const formData = await request.formData();
		const settingOps = [];

		for (const key of settingKeys) {
			const value = formData.get(key);

			// Handle upload file untuk logo dan favicon
			if (value instanceof File && value.size > 0) {
				try {
					const newImage = await uploadImage(value);
					settingOps.push(
						db.setting.upsert({
							where: { key },
							update: { value: newImage.url },
							create: { key, value: newImage.url }
						})
					);
				} catch {
					// Abaikan jika upload gagal, jangan ubah setting yang ada
					console.error(`Gagal meng-upload file untuk ${key}`);
				}
			} else if (typeof value === 'string') {
				// Simpan pengaturan berbasis teks
				settingOps.push(
					db.setting.upsert({
						where: { key },
						update: { value },
						create: { key, value }
					})
				);
			}
		}

		try {
			await db.$transaction(settingOps);
		} catch {
			return { success: false, message: 'Gagal menyimpan pengaturan.' };
		}

		return { success: true, message: 'Pengaturan umum berhasil disimpan!' };
	}
};