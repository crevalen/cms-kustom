import webpush from 'web-push';
import { db } from '$lib/server/db';
import { PUBLIC_VAPID_KEY, PRIVATE_VAPID_KEY, VAPID_SUBJECT } from '$env/static/private';
import type { Post, Media, Category } from '@prisma/client';

// Gabungkan tipe Post dengan relasinya agar tidak error
type PostWithRelations = Post & {
    featuredImage?: Media | null;
    categories: Category[];
};

export async function sendNotificationToAll(post: PostWithRelations) {
  if (!PUBLIC_VAPID_KEY || !PRIVATE_VAPID_KEY || !VAPID_SUBJECT) {
    console.error('VAPID keys are not configured. Skipping notification.');
    return;
  }
  
  // Konfigurasi VAPID
  webpush.setVapidDetails(
    VAPID_SUBJECT,
    PUBLIC_VAPID_KEY,
    PRIVATE_VAPID_KEY
  );

  // Ambil semua subscriber dari database
  const subscriptions = await db.pushSubscription.findMany();

  // Siapkan payload notifikasi
  const payload = JSON.stringify({
    title: `Artikel Baru: ${post.title}`,
    body: 'Klik untuk membaca selengkapnya!',
    icon: post.featuredImage?.url || '/favicon.ico', // ganti dengan ikon default Anda
    badge: '/favicon.ico', // ganti dengan badge Anda
    url: `https://www.crevalen.xyz/${post.categories[0]?.slug || 'artikel'}/${post.slug}` // PENTING: ganti dengan URL frontend Anda
  });

  // Kirim notifikasi ke setiap subscriber
  for (const sub of subscriptions) {
    try {
      await webpush.sendNotification({
        endpoint: sub.endpoint,
        keys: { p256dh: sub.p256dh, auth: sub.auth }
      }, payload);
    } catch (error) {
      console.error('Gagal mengirim notifikasi ke:', sub.endpoint);
      // Jika endpoint sudah tidak valid (misal: 410 Gone), hapus dari database
      if ((error as any).statusCode === 410) {
        await db.pushSubscription.delete({ where: { id: sub.id } });
      }
    }
  }
}