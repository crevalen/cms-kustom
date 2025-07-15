import { S3Client, PutObjectCommand, DeleteObjectCommand } from '@aws-sdk/client-s3';
import {
	R2_ACCOUNT_ID,
	R2_ACCESS_KEY_ID,
	R2_SECRET_ACCESS_KEY,
	R2_BUCKET_NAME
} from '$env/static/private';
import { PUBLIC_R2_URL } from '$env/static/public';
import sharp from 'sharp';
import { db } from './db';

const S3 = new S3Client({
	region: 'auto',
	endpoint: `https://${R2_ACCOUNT_ID}.r2.cloudflarestorage.com`,
	credentials: { accessKeyId: R2_ACCESS_KEY_ID, secretAccessKey: R2_SECRET_ACCESS_KEY }
});

export async function uploadImage(file: File, altText?: string) { // Tambahkan parameter altText
	const imageBuffer = Buffer.from(await file.arrayBuffer());
	const processedImage = await sharp(imageBuffer)
		.resize({ width: 1200, withoutEnlargement: true })
		.webp({ quality: 80 })
		.toBuffer();

	const originalName = file.name.substring(0, file.name.lastIndexOf('.'));
	const key = `${Date.now()}-${originalName}.webp`;

	const command = new PutObjectCommand({
		Bucket: R2_BUCKET_NAME,
		Key: key,
		Body: processedImage,
		ContentType: 'image/webp'
	});

	try {
		await S3.send(command);
		const url = `${PUBLIC_R2_URL}/${key}`;

		const newMedia = await db.media.create({
			data: {
				key,
				url,
				size: processedImage.byteLength,
				fileType: 'image/webp',
				// Gunakan altText yang diterima, atau nama file asli sebagai fallback
				altText: altText && altText.length > 0 ? altText : originalName
			}
		});

		return newMedia;
	} catch {
		throw new Error('Gagal memproses dan meng-upload gambar.');
	}
}

export async function deleteImage(key: string) {
	const command = new DeleteObjectCommand({
		Bucket: R2_BUCKET_NAME,
		Key: key
	});
	try {
		await S3.send(command);
		return { success: true };
	} catch {
		throw new Error('Gagal menghapus file.');
	}
}