// src/routes/api/comments/[postSlug]/+server.ts
import { db } from '$lib/server/db';
import { json, error } from '@sveltejs/kit';
import type { RequestHandler } from './$types';

export const POST: RequestHandler = async ({ request, params }) => {
	const { postSlug } = params;
	const { content, authorName, authorEmail, parentId } = await request.json();

	if (!content || !authorName || !authorEmail) {
		throw error(400, 'Mohon isi semua field yang wajib.');
	}

	try {
		const post = await db.post.findUnique({ where: { slug: postSlug } });
		if (!post) throw error(404, 'Postingan tidak ditemukan.');

		const newComment = await db.comment.create({
			data: {
				content,
				authorName,
				authorEmail,
				postId: post.id,
				parentId: parentId || null // Simpan parentId jika ini adalah balasan
			}
		});
		return json({ message: 'Komentar Anda telah dikirim dan sedang menunggu moderasi.', comment: newComment }, { status: 201 });
	} catch  {
		throw error(500, 'Gagal mengirim komentar.');
	}
};
// Tambahkan fungsi GET ini di dalam file yang sama (src/routes/api/comments/[postSlug]/+server.ts)

export const GET: RequestHandler = async ({ params }) => {
	const { postSlug } = params;

	try {
		const comments = await db.comment.findMany({
			where: {
				post: { slug: postSlug },
				isApproved: true
			},
			orderBy: { createdAt: 'asc' }
		});

		// Strukturkan komentar menjadi nested (dengan balasan)
		const nestedComments = [];
		const commentMap = new Map();
		for (const comment of comments) {
			commentMap.set(comment.id, { ...comment, replies: [] });
		}
		for (const comment of commentMap.values()) {
			if (comment.parentId && commentMap.has(comment.parentId)) {
				commentMap.get(comment.parentId).replies.push(comment);
			} else {
				nestedComments.push(comment);
			}
		}

		return json(nestedComments);
	} catch  {
		throw error(500, 'Gagal mengambil komentar.');
	}
};