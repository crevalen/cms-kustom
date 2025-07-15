// src/routes/admin/media/+page.server.ts

import { deleteImage, uploadImage } from '$lib/server/r2';
import { fail } from '@sveltejs/kit';
import type { PageServerLoad, Actions } from './$types';
import { db } from '$lib/server/db';

export const load: PageServerLoad = async () => {
	const media = await db.media.findMany({
		orderBy: { createdAt: 'desc' }
	});
	return { media };
};

export const actions: Actions = {
	uploadFile: async ({ request }) => {
		const formData = await request.formData();
		const image = formData.get('image') as File;

		if (!image || image.size === 0) {
			return fail(400, { success: false, message: 'Silakan pilih file untuk di-upload.' });
		}
		try {
			await uploadImage(image);
		} catch {
			return fail(500, { success: false, message: 'Gagal meng-upload gambar.' });
		}
		return { success: true, message: 'Upload berhasil!' };
	},

	editFile: async ({ request }) => {
		const formData = await request.formData();
		const id = formData.get('id') as string;
		const altText = formData.get('altText') as string;

		if (!id) return fail(400, { success: false, message: 'ID file tidak valid.' });
		try {
			await db.media.update({ where: { id }, data: { altText } });
		} catch {
			return fail(500, { success: false, message: 'Gagal memperbarui alt text.' });
		}
		return { success: true, message: 'Alt text disimpan.' };
	},

	deleteFile: async ({ request }) => {
		const formData = await request.formData();
		const id = formData.get('id') as string;
		const key = formData.get('key') as string;

		if (!id || !key) return fail(400, { success: false, message: 'ID atau Key file tidak valid.' });
		try {
			await Promise.all([deleteImage(key), db.media.delete({ where: { id } })]);
		} catch {
			return fail(500, { success: false, message: 'Gagal menghapus file.' });
		}
		return { success: true, message: 'File dihapus.' };
	}
};