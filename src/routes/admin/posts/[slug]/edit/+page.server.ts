// src/routes/admin/posts/[slug]/edit/+page.server.ts

import { db } from '$lib/server/db';
import { error, fail, } from '@sveltejs/kit';
import type { Actions, PageServerLoad } from './$types';
import { Prisma } from '@prisma/client';

import { uploadImage } from '$lib/server/r2';

export const load: PageServerLoad = async ({ params, locals }) => {
	const post = await db.post.findUnique({
		where: { slug: params.slug },
		include: { categories: true, tags: true, featuredImage: true }
	});

	if (!post) throw error(404, 'Postingan tidak ditemukan');
	if (post.authorId !== locals.user?.id) throw error(403, 'Akses ditolak');

	const allCategories = await db.category.findMany({ orderBy: { name: 'asc' } });
	const allTags = await db.tag.findMany({ orderBy: { name: 'asc' } });

	return {
		// PERBAIKAN: Menggunakan 'as any' untuk melewati pemeriksaan tipe yang salah
		// dan memastikan kita bisa mengakses URL gambar yang sudah di-load.
		post: {
			...post,
			// eslint-disable-next-line @typescript-eslint/no-explicit-any
			featuredImageUrl: (post as any).featuredImage?.url
		},
		allCategories,
		allTags
		
	};
};

export const actions: Actions = {
	default: async ({ request, params, locals }) => {
		const { slug: oldSlug } = params;
		const formData = await request.formData();
		const title = formData.get('title') as string;
		const newSlug = formData.get('slug') as string;
		const content = formData.get('content') as string;
		const published = formData.get('published') === 'on';
		const metaTitle = formData.get('metaTitle') as string;
		const metaDescription = formData.get('metaDescription') as string;
		const focusKeyword = formData.get('focusKeyword') as string;
		const image = formData.get('imageUrl') as File;
		const imageAltText = formData.get('imageAltText') as string;
		const categoryNames = (formData.get('categories') as string)?.split(',').filter(Boolean).map(s => s.trim());
		const tagNames = (formData.get('tags') as string)?.split(',').filter(Boolean).map(s => s.trim());
		const schemaType = formData.get('schemaType') as string;
		const ogTitle = formData.get('ogTitle') as string;
		const ogDescription = formData.get('ogDescription') as string;
		const canonicalUrl = formData.get('canonicalUrl') as string;
		const noIndex = formData.get('noIndex') === 'on';
		const noFollow = formData.get('noFollow') === 'on';
		const ogImageFile = formData.get('ogImage') as File;


		if (!title) return fail(400, { error: 'Judul tidak valid.' });
		if (!newSlug || !/^[a-z0-9-]+$/.test(newSlug)) return fail(400, { error: 'Slug tidak valid.' });

		try {
			const categoryUpserts = categoryNames.map((name) =>
				db.category.upsert({ where: { name }, update: {}, create: { name, slug: name.toLowerCase().replace(/\s+/g, '-') } })
			);
			const tagUpserts = tagNames.map((name) =>
				db.tag.upsert({ where: { name }, update: {}, create: { name, slug: name.toLowerCase().replace(/\s+/g, '-') } })
			);
			
			const newCategories = await Promise.all(categoryUpserts);
			const newTags = await Promise.all(tagUpserts);

			const dataToUpdate: Prisma.PostUpdateInput = {
				title, slug: newSlug, content, published, metaTitle, metaDescription,focusKeyword,
				categories: { set: newCategories.map(cat => ({ id: cat.id })) },
				tags: { set: newTags.map(tag => ({ id: tag.id })) },
				ogTitle,
				ogDescription,
				canonicalUrl,
				schemaType,
				noIndex,
				noFollow,
			};

			if (image?.size > 0) {
				const newImage = await uploadImage(image, imageAltText);
				dataToUpdate.featuredImage = { connect: { id: newImage.id } };
			}

			if (ogImageFile?.size > 0) {
    const newOgImage = await uploadImage(ogImageFile);
    dataToUpdate.ogImage = { connect: { id: newOgImage.id } };
}

			await db.post.update({
				where: { slug: oldSlug, authorId: locals.user?.id },
				data: dataToUpdate
			});
		} catch (e) {
			console.error(e);
			if (e instanceof Prisma.PrismaClientKnownRequestError && e.code === 'P2002') {
				return fail(400, { error: `Slug "${newSlug}" sudah digunakan.` });
			}
			return fail(500, { error: 'Gagal memperbarui postingan.', success: false });
		}
		
		// Mengembalikan pesan sukses untuk notifikasi
		return { success: true, message: 'Postingan berhasil diperbarui!' };
	}
};