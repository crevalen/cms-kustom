// src/routes/api/posts/+server.ts

import { db } from '$lib/server/db';
import { json } from '@sveltejs/kit';
import type { RequestHandler } from './$types';

export const GET: RequestHandler = async () => {
  const posts = await db.post.findMany({
    where: { published: true },
    include: {
      featuredImage: true,
      // TAMBAHKAN BARIS INI
      categories: {
        select: {
          slug: true // Kita hanya butuh slug dari kategori
        },
        take: 1 // Ambil satu kategori utama saja untuk URL
      }
    },
    orderBy: {
      createdAt: 'desc'
    }
  });
  return json(posts);
};