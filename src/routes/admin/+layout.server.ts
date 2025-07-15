// src/routes/admin/+layout.server.ts

import { redirect } from '@sveltejs/kit';
import type { LayoutServerLoad } from './$types';

// Fungsi 'load' di file layout ini akan berjalan
// untuk SEMUA halaman di dalam folder /admin.
export const load: LayoutServerLoad = async ({ locals }) => {
	// Jika data user tidak ada di locals (artinya belum login),
	if (!locals.user) {
		// paksa arahkan (redirect) ke halaman login.
		throw redirect(302, '/login');
	}
};