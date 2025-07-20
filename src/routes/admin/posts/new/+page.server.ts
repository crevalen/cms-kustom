import { fail, redirect } from '@sveltejs/kit';
import type { Actions, PageServerLoad } from './$types';
import { db } from '$lib/server/db';
import { uploadImage } from '$lib/server/r2';
import { Prisma } from '@prisma/client';
import { sendNotificationToAll } from '$lib/server/notifications';

export const load: PageServerLoad = async () => {
	const allCategories = await db.category.findMany({ orderBy: { name: 'asc' } });
	const allTags = await db.tag.findMany({ orderBy: { name: 'asc' } });
	return { allCategories, allTags };
};

export const actions: Actions = {
	default: async ({ request, locals }) => {
		if (!locals.user) throw redirect(302, '/login');

		const formData = await request.formData();
		const title = formData.get('title') as string;
		const slug = formData.get('slug') as string;
		const content = formData.get('content') as string;
		const published = formData.get('published') === 'on'; // <-- PERBAIKAN DI SINI
		const publishedAtString = formData.get('publishedAt') as string;
		const metaTitle = formData.get('metaTitle') as string;
		const metaDescription = formData.get('metaDescription') as string;
		const focusKeyword = formData.get('focusKeyword') as string;
		const image = formData.get('imageUrl') as File;
		const imageAltText = formData.get('imageAltText') as string;
		const categoryNames = (formData.get('categories') as string)?.split(',').filter(Boolean).map((s) => s.trim());
		const tagNames = (formData.get('tags') as string)?.split(',').filter(Boolean).map((s) => s.trim());
		
		let featuredImageId: string | undefined = undefined;
		if (image?.size > 0) {
			try {
				const newImage = await uploadImage(image, imageAltText);
				featuredImageId = newImage.id;
			} catch {
				return fail(500, { error: 'Gagal meng-upload gambar.' });
			}
		}

		if (!title || title.length < 3) return fail(400, { error: 'Judul tidak valid.' });
		if (!slug || !/^[a-z0-9-]+$/.test(slug)) return fail(400, { error: 'Slug tidak valid.' });

		try {
			const categoryConnectOrCreate = categoryNames.map((name) => ({ where: { name }, create: { name, slug: name.toLowerCase().replace(/\s+/g, '-') } }));
			const tagConnectOrCreate = tagNames.map((name) => ({ where: { name }, create: { name, slug: name.toLowerCase().replace(/\s+/g, '-') } }));

			const newPost = await db.post.create({
				data: {
					title, slug, content, metaTitle, metaDescription, focusKeyword,
					published,
					publishedAt: publishedAtString ? new Date(publishedAtString) : new Date(),
					authorId: locals.user.id,
					featuredImageId: featuredImageId,
					categories: { connectOrCreate: categoryConnectOrCreate },
					tags: { connectOrCreate: tagConnectOrCreate }
				},
				// Sertakan data relasi yang dibutuhkan oleh fungsi notifikasi
				include: {
					featuredImage: true,
					categories: true
				}
			});

			// 3. Panggil fungsi untuk mengirim notifikasi jika post di-publish
			if (newPost.published) {
				await sendNotificationToAll(newPost);
			}

		} catch (e) {
			if (e instanceof Prisma.PrismaClientKnownRequestError && e.code === 'P2002') {
				return fail(400, { error: `Slug "${slug}" sudah digunakan.` });
			}
			return fail(500, { error: 'Gagal menyimpan postingan.' });
		}
		throw redirect(302, `/admin/posts`);
	}
};