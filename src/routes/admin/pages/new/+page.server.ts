import { fail, redirect } from '@sveltejs/kit';
import type { Actions, PageServerLoad } from './$types';
import { db } from '$lib/server/db';
import { Prisma } from '@prisma/client';

// Tidak ada lagi yang perlu di-load untuk halaman baru
export const load: PageServerLoad = async () => {
	return {};
};

export const actions: Actions = {
	default: async ({ request }) => {
		const formData = await request.formData();
		const data = Object.fromEntries(formData) as Record<string, string>;
		try {
			await db.page.create({
				data: {
					title: data.title,
					slug: data.slug,
					content: data.content,
					published: data.published === 'on',
					metaTitle: data.metaTitle,
					metaDescription: data.metaDescription,
					schemaType: data.schemaType
				}
			});
		} catch (e) {
			if (e instanceof Prisma.PrismaClientKnownRequestError && e.code === 'P2002') {
				return fail(400, { error: `Slug "${data.slug}" sudah digunakan.` });
			}
			return fail(500, { error: 'Gagal menyimpan halaman.' });
		}
		throw redirect(302, `/admin/pages`);
	}
};