import { db } from '$lib/server/db';
import { json, error } from '@sveltejs/kit';
import type { RequestHandler } from './$types';

export const POST: RequestHandler = async ({ request }) => {
	const subscription = await request.json();
	try {
		await db.pushSubscription.create({
			data: {
				endpoint: subscription.endpoint,
				p256dh: subscription.keys.p256dh,
				auth: subscription.keys.auth
			}
		});
		return json({ success: true }, { status: 201 });
	} catch (err) {
		console.error(err);
		// Abaikan error jika endpoint sudah ada (unique constraint)
		if ((err as any).code === 'P2002') {
			return json({ success: true });
		}
		throw error(500, 'Gagal menyimpan subscription.');
	}
};