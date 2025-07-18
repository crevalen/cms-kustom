// Di dalam proyek CMS: src/routes/api/render/post/[slug]/+server.ts

import { db } from '$lib/server/db';
import { error, json } from '@sveltejs/kit';
import type { RequestHandler } from './$types';
import { marked } from 'marked';
import { PUBLIC_SITE_URL } from '$env/static/public';

export const GET: RequestHandler = async ({ params }) => {
	// 1. Ambil Data Post Utama
	const post = await db.post.findFirst({
		where: {
			slug: params.slug,
			published: true,
			publishedAt: { lte: new Date() }
		},
		include: {
			author: { select: { username: true, displayName: true, avatarUrl: true } },
			featuredImage: true,
			ogImage: true,
			categories: { take: 1 },
			tags: true
		}
	});

	if (!post) {
		throw error(404, 'Postingan tidak ditemukan');
	}

	// 2. Ambil Data Tambahan (Komentar & Post Terkait)
	const [comments, relatedPosts, settings] = await Promise.all([
		db.comment.findMany({
			where: { postId: post.id, isApproved: true, parentId: null }, // Ambil komentar utama
			include: { replies: true }, // Sertakan balasan
			orderBy: { createdAt: 'asc' }
		}),
		db.post.findMany({
			where: {
				published: true,
				publishedAt: { lte: new Date() },
				id: { not: post.id },
				categories: { some: { id: post.categories[0]?.id } }
			},
			include: { featuredImage: true },
			take: 3
		}),
		db.setting.findMany({
			where: { key: { in: ['site_title', 'post_title_template', 'publisher_name', 'publisher_logo_url'] } }
		})
	]);

	// 3. Proses Semua Data (Konten, Meta, JSON-LD)
	const contentHtml = await marked.parse(post.content);
	const settingsMap = settings.reduce((acc: Record<string, string>, setting) => {
		acc[setting.key] = setting.value;
		return acc;
	}, {});
	
    const finalUrl = `${PUBLIC_SITE_URL}/${post.categories[0]?.slug || 'blog'}/${post.slug}`;
	const siteTitle = settingsMap.site_title || 'Blog';
	const titleTemplate = settingsMap.post_title_template || '%post_title% | %site_title%';
	const finalTitle = post.metaTitle || titleTemplate.replace('%post_title%', post.title).replace('%site_title%', siteTitle);
	const finalDescription = post.metaDescription || contentHtml.substring(0, 160).replace(/<[^>]*>/g, '');

	const meta = {
		title: finalTitle,
		description: finalDescription,
		ogTitle: post.ogTitle || finalTitle,
		ogDescription: post.ogDescription || finalDescription,
		ogImage: post.ogImage?.url || post.featuredImage?.url || '',
		canonical: post.canonicalUrl || finalUrl,
		robots: `${post.noIndex ? 'noindex' : 'index'},${post.noFollow ? 'nofollow' : 'follow'}`
	};

	const schemaType = post.schemaType || 'BlogPosting';
	const jsonLd: JsonLdSchema = {
		'@context': 'https://schema.org',
		'@type': schemaType,
		headline: post.metaTitle || post.title,
		description: finalDescription,
		image: post.featuredImage?.url || '',
		datePublished: post.createdAt.toISOString(),
		dateModified: post.updatedAt.toISOString(),
		author: { '@type': 'Person', name: post.author.displayName || post.author.username },
		publisher: {
			'@type': 'Organization',
			name: settingsMap.publisher_name || siteTitle,
			logo: { '@type': 'ImageObject', url: settingsMap.publisher_logo_url || '' }
		},
		mainEntityOfPage: { '@type': 'WebPage', '@id': finalUrl } // Gunakan finalUrl
	};

	if (schemaType === 'FAQPage') {
		const faqPairs = contentHtml.match(/<h2>(.*?)<\/h2>([\s\S]*?)(?=(<h2>|$))/g) || [];
		jsonLd.mainEntity = faqPairs.map((pair) => {
			const questionMatch = pair.match(/<h2>(.*?)<\/h2>/);
			const answerMatch = pair.replace(/<h2>.*?<\/h2>/, '').trim();
			return {
				'@type': 'Question',
				name: questionMatch ? questionMatch[1] : '',
				acceptedAnswer: {
					'@type': 'Answer',
					text: answerMatch.replace(/<[^>]*>/g, '')
				}
			};
		});
	}

	// 4. Gabungkan Semua dalam Satu Respons
	return json({
		post: { ...post, content: contentHtml },
		meta,
		jsonLd,
		comments,
		relatedPosts
	});
};