// src/routes/admin/taxonomies/+page.server.ts
import { db } from '$lib/server/db';
import { fail } from '@sveltejs/kit';
import type { Actions, PageServerLoad } from './$types';

export const load: PageServerLoad = async () => {
	const categories = await db.category.findMany({ orderBy: { name: 'asc' } });
	const tags = await db.tag.findMany({ orderBy: { name: 'asc' } });
	return { categories, tags };
};

export const actions: Actions = {
	createCategory: async ({ request }) => {
		const formData = await request.formData();
		const name = formData.get('name') as string;
		if (!name || name.length < 2) {
			return fail(400, { error: 'Nama kategori tidak valid.' });
		}
		const slug = name.toLowerCase().replace(/\s+/g, '-');

		try {
			await db.category.create({ data: { name, slug } });
		} catch  {
			return fail(500, { error: 'Gagal membuat kategori, mungkin sudah ada.' });
		}
		return { success: true };
	},
	createTag: async ({ request }) => {
		const formData = await request.formData();
		const name = formData.get('name') as string;
		if (!name || name.length < 2) {
			return fail(400, { error: 'Nama tag tidak valid.' });
		}
		const slug = name.toLowerCase().replace(/\s+/g, '-');

		try {
			await db.tag.create({ data: { name, slug } });
		} catch  {
			return fail(500, { error: 'Gagal membuat tag, mungkin sudah ada.' });
		}
		return { success: true };
	},


deleteCategory: async ({ request }) => {
		const formData = await request.formData();
		const id = formData.get('id') as string;
		try {
			await db.category.delete({ where: { id } });
		} catch {
			return fail(500, { message: 'Gagal menghapus kategori.' });
		}
		return { success: true };
	},
	deleteTag: async ({ request }) => {
		const formData = await request.formData();
		const id = formData.get('id') as string;
		try {
			await db.tag.delete({ where: { id } });
		} catch {
			return fail(500, { message: 'Gagal menghapus tag.' });
		}
		return { success: true };
	}
};