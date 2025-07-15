// src/lib/server/db.ts
import { PrismaClient } from '@prisma/client';
import { withAccelerate } from '@prisma/extension-accelerate';

// Inisialisasi client dan langsung tambahkan ekstensi Accelerate
export const db = new PrismaClient().$extends(withAccelerate());