// src/app.d.ts

declare global {
	namespace App {
		// interface Error {}
		interface Locals {
			user: {
				id: string;
				username: string;
			} | null;
			// Tambahkan tipe data untuk session di sini
			session: {
				id: string;
				userId: string;
				expiresAt: Date;
			} | null;
		}
		// interface PageData {}
		// interface PageState {}
		// interface Platform {}
	}
}

export {};