import { fail, redirect } from '@sveltejs/kit';
import type { Actions, PageServerLoad } from './$types';
import { db } from '$lib/server/db';
import { uploadImage } from '$lib/server/r2';
import { Prisma } from '@prisma/client';

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
		const metaTitle = formData.get('metaTitle') as string;
		const metaDescription = formData.get('metaDescription') as string;
		const focusKeyword = formData.get('focusKeyword') as string;
		const image = formData.get('imageUrl') as File;
		const imageAltText = formData.get('imageAltText') as string;
		const categoryNames = (formData.get('categories') as string)?.split(',').filter(Boolean) || [];
		const tagNames = (formData.get('tags') as string)?.split(',').filter(Boolean) || [];
		const ogTitle = formData.get('ogTitle') as string;
	    const ogDescription = formData.get('ogDescription') as string;
	    const canonicalUrl = formData.get('canonicalUrl') as string;
	    const noIndex = formData.get('noIndex') === 'on';
	    const noFollow = formData.get('noFollow') === 'on';
		const ogImageFile = formData.get('ogImage') as File;
		const schemaType = formData.get('schemaType') as string;

		let ogImageId: string | undefined = undefined;
		let featuredImageId: string | undefined = undefined;


// Handle upload OG Image
if (ogImageFile?.size > 0) {
    try {
        const newOgImage = await uploadImage(ogImageFile);
        ogImageId = newOgImage.id;
    } catch {
        // Gagal upload OG Image, bisa diabaikan atau beri error
    }
}

if (image?.size > 0) {
    const newImage = await uploadImage(image, imageAltText);
    featuredImageId = newImage.id; // Simpan ID dari media baru
}

		if (!title || title.length < 3) {
			return fail(400, { error: 'Judul tidak valid.' });
		}
		if (!slug || !/^[a-z0-9-]+$/.test(slug)) {
			return fail(400, { error: 'Slug tidak valid.' });
		}

		try {
			const categoryConnectOrCreate = categoryNames.map((name) => ({
				where: { name: name.trim() },
				create: { name: name.trim(), slug: name.trim().toLowerCase().replace(/\s+/g, '-') }
			}));
			const tagConnectOrCreate = tagNames.map((name) => ({
				where: { name: name.trim() },
				create: { name: name.trim(), slug: name.trim().toLowerCase().replace(/\s+/g, '-') }
			}));

			await db.post.create({
				data: {
					title, slug, content, metaTitle, metaDescription,focusKeyword,
					featuredImageId: featuredImageId,
					authorId: locals.user.id,
					categories: { connectOrCreate: categoryConnectOrCreate },
					tags: { connectOrCreate: tagConnectOrCreate },
					ogTitle,
                    ogDescription,
					canonicalUrl,
					noIndex,
					noFollow,
					schemaType,
					ogImageId,
					
				}
			});
		} catch (e) {
			if (e instanceof Prisma.PrismaClientKnownRequestError && e.code === 'P2002') {
				return fail(400, { error: `Slug "${slug}" sudah digunakan.` });
			}
			return fail(500, { error: 'Gagal menyimpan postingan.' });
		}

		throw redirect(302, `/admin/posts`);
	}
};