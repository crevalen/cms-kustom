// src/lib/server/auth.ts

import { db } from './db';
import { TimeSpan, createDate } from 'oslo';
import { randomBytes } from 'crypto';
import { Argon2id } from 'oslo/password';

// --- MANAJEMEN SESI ---

/**
 * Membuat sesi baru untuk pengguna di database.
 * @param userId - ID pengguna yang login.
 * @returns ID sesi yang baru dibuat.
 */
export async function createSession(userId: string) {
	// Hapus sesi lama yang mungkin sudah kadaluarsa untuk menjaga kebersihan database
	await db.session.deleteMany({
		where: {
			userId: userId,
			expiresAt: {
				lt: new Date()
			}
		}
	});

	const sessionId = randomBytes(16).toString('hex');
	const expiresAt = createDate(new TimeSpan(30, 'd')); // Sesi berlaku selama 30 hari

	await db.session.create({
		data: {
			id: sessionId,
			userId: userId,
			expiresAt: expiresAt
		}
	});

	return sessionId;
}

/**
 * Memvalidasi ID sesi dari cookie.
 * @param sessionId - ID sesi yang perlu divalidasi.
 * @returns Objek berisi user dan session jika valid, atau null jika tidak.
 */
export async function validateSession(sessionId: string) {
	const session = await db.session.findUnique({
		where: { id: sessionId },
		include: {
			user: {
				select: {
					id: true,
					username: true
				}
			}
		}
	});

	if (!session || !session.user) {
		return { user: null, session: null };
	}

	if (session.expiresAt < new Date()) {
		// Hapus sesi jika sudah kadaluarsa
		await db.session.delete({ where: { id: sessionId } });
		return { user: null, session: null };
	}

	return {
		user: session.user,
		session: {
			id: session.id,
			userId: session.userId,
			expiresAt: session.expiresAt
		}
	};
}

/**
 * Menghapus sesi dari database (untuk logout).
 * @param sessionId - ID sesi yang akan dihapus.
 */
export async function invalidateSession(sessionId: string) {
	await db.session.delete({
		where: {
			id: sessionId
		}
	});
}

// --- MANAJEMEN PASSWORD ---

const argon2id = new Argon2id();

/**
 * Meng-hash password mentah menjadi string yang aman.
 * @param password - Password yang akan di-hash.
 * @returns Hash password.
 */
export async function hashPassword(password: string) {
	return await argon2id.hash(password);
}

/**
 * Memverifikasi apakah password mentah cocok dengan hash.
 * @param passwordHash - Hash dari database.
 * @param password - Password yang dimasukkan pengguna.
 * @returns true jika cocok, false jika tidak.
 */
export async function verifyPassword(passwordHash: string, password: string) {
	return await argon2id.verify(passwordHash, password);
}