// src/routes/api/media/upload/+server.ts
import { uploadImage } from '$lib/server/r2';
import { json, error } from '@sveltejs/kit';
import type { RequestHandler } from './$types';

export const POST: RequestHandler = async ({ request }) => {
	const formData = await request.formData();
	const imageFile = formData.get('image') as File;
	const altText = formData.get('altText') as string;

	if (!imageFile) {
		throw error(400, 'Tidak ada file gambar yang diunggah.');
	}

	try {
		// Kirim file dan alt text ke fungsi upload utama
		const newImage = await uploadImage(imageFile, altText);
		return json(newImage, { status: 201 });
	} catch  {
		throw error(500, 'Gagal memproses gambar.');
	}
};