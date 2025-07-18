import { db } from '$lib/server/db';
import { json } from '@sveltejs/kit';
import type { RequestHandler } from './$types';

export const GET: RequestHandler = async ({ url }) => {
    const query = url.searchParams.get('q');

    if (!query) {
        return json({ posts: [] });
    }

    const posts = await db.post.findMany({
        where: {
            published: true,
            // PERUBAHAN: Query yang lebih sederhana dan fokus
            OR: [
                { title: { contains: query, mode: 'insensitive' } },      // 1. Cari di Judul
                { 
                    tags: {                                               // 2. Cari di Tags
                        some: { name: { contains: query, mode: 'insensitive' } } 
                    } 
                }
            ]
        },
        include: { // Kita gunakan 'include' di sini agar lebih aman
            featuredImage: true,
            categories: {
                select: { 
                    slug: true,
                    name: true
                 },
                take: 1
            }
        },
        orderBy: {
            createdAt: 'desc'
        }
    });

    return json({ posts });
};