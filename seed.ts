// seed.ts

import { PrismaClient } from '@prisma/client';
import { hashPassword } from './src/lib/server/auth';

const db = new PrismaClient();

async function main() {
	const passwordHash = await hashPassword('password123');

	// Hapus user 'admin' yang mungkin sudah ada
	await db.user.deleteMany({ where: { username: 'admin' } });

	// Buat user admin baru
	const user = await db.user.create({
		data: {
			username: 'admin',
			passwordHash: passwordHash
		}
	});
	console.log(`Berhasil membuat user: ${user.username}`);
}

main()
	.catch((e) => {
		console.error(e);
		process.exit(1);
	})
	.finally(async () => {
		await db.$disconnect();
	});