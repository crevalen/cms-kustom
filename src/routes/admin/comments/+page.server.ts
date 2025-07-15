// src/routes/admin/comments/+page.server.ts
import { db } from '$lib/server/db';
import { fail } from '@sveltejs/kit';
import type { Actions, PageServerLoad } from './$types';

export const load: PageServerLoad = async () => {
	const comments = await db.comment.findMany({
		include: { post: { select: { title: true } } },
		orderBy: { createdAt: 'desc' }
	});
	return { comments };
};

export const actions: Actions = {
	toggleApproval: async ({ request }) => {
		const formData = await request.formData();
		const id = formData.get('id') as string;
		const currentStatus = formData.get('isApproved') === 'true';

		try {
			await db.comment.update({
				where: { id },
				data: { isApproved: !currentStatus }
			});
		} catch {
			return fail(500, { message: 'Gagal mengubah status komentar.' });
		}
		return { success: true };
	},
	deleteComment: async ({ request }) => {
		const formData = await request.formData();
		const id = formData.get('id') as string;
		try {
			await db.comment.delete({ where: { id } });
		} catch {
			return fail(500, { message: 'Gagal menghapus komentar.' });
		}
		return { success: true };
	}
};