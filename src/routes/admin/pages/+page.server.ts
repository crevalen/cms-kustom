import { db } from '$lib/server/db';
import { fail } from '@sveltejs/kit';
import type { Actions, PageServerLoad } from './$types';

export const load: PageServerLoad = async () => {
	const pages = await db.page.findMany({ orderBy: { createdAt: 'desc' } });
	return { pages };
};

export const actions: Actions = {
	delete: async ({ request }) => {
		const formData = await request.formData();
		const id = formData.get('id') as string;
		try {
			await db.page.delete({ where: { id } });
		} catch {
			return fail(500, { message: 'Gagal menghapus halaman' });
		}
		return { success: true };
	}
};