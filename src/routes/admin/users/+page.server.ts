// src/routes/admin/users/+page.server.ts

import { db } from '$lib/server/db';
import type { PageServerLoad, Actions } from './$types';
import { fail } from '@sveltejs/kit';

export const load: PageServerLoad = async () => {
	const users = await db.user.findMany({
		orderBy: { username: 'asc' }
	});
	return { users };
};

// Kita siapkan action untuk delete, akan kita gunakan nanti
export const actions: Actions = {
	deleteUser: async ({ request }) => {
		const formData = await request.formData();
		const id = formData.get('id') as string;

		// Pengaman agar tidak bisa menghapus diri sendiri
		// Anda perlu menambahkan logika pengecekan user yang sedang login di sini nanti
		// if (id === locals.user.id) {
		// 	return fail(403, { message: 'Anda tidak bisa menghapus akun Anda sendiri.' });
		// }

		try {
			await db.user.delete({ where: { id } });
		} catch (err) {
			return fail(500, { message: `Gagal menghapus user: ${(err as Error).message}` });
		}
		return { success: true };
	}
};