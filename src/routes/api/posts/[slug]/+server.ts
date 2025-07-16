// src/routes/api/posts/[slug]/+server.ts

import { db } from '$lib/server/db';
import { error, json } from '@sveltejs/kit';
import type { RequestHandler } from './$types';
import { marked } from 'marked';
import { PUBLIC_SITE_URL } from '$env/static/public';

interface JsonLdSchema {
	'@context': string;
	'@type': string;
	headline: string;
	description: string;
	image?: string;
	datePublished: string;
	dateModified: string;
	author: { '@type': 'Person'; name: string };
	publisher: { '@type': 'Organization'; name: string; logo: { '@type': 'ImageObject'; url: string } };
	mainEntityOfPage: { '@type': 'WebPage'; '@id': string };
	mainEntity?: {
		'@type': 'Question';
		name: string;
		acceptedAnswer: {
			'@type': 'Answer';
			text: string;
		};
	}[];
}

export const GET: RequestHandler = async ({ params }) => {
	const post = await db.post.findFirst({
		where: {
			slug: params.slug,
			published: true,
			publishedAt: { lte: new Date() } // <-- Sekarang ini valid
		},
		include: {
			author: {
				select: {
					username: true,
					displayName: true,
					avatarUrl: true
				}
			},
			featuredImage: true,
			ogImage: true, // <-- Sertakan juga ogImage
			categories: true,
			tags: true
		}
	});

	if (!post) {
		throw error(404, 'Postingan tidak ditemukan');
	}

	const settings = await db.setting.findMany({
		where: { key: { in: ['site_title', 'post_title_template', 'publisher_name', 'publisher_logo_url'] } }
	});
	const settingsMap = settings.reduce(
		(acc: Record<string, string>, setting) => {
			acc[setting.key] = setting.value;
			return acc;
		},
		{}
	);

	const contentHtml = await marked.parse(post.content);

	const siteTitle = settingsMap.site_title || 'Blog Keren';
	const titleTemplate = settingsMap.post_title_template || '%post_title% | %site_title%';
	const finalTitle =
		post.metaTitle || titleTemplate.replace('%post_title%', post.title).replace('%site_title%', siteTitle);
	const finalDescription =
		post.metaDescription || contentHtml.substring(0, 160).replace(/<[^>]*>/g, '');

	const meta = {
		title: finalTitle,
		description: finalDescription,
		ogTitle: post.ogTitle || finalTitle,
		ogDescription: post.ogDescription || finalDescription,
		// PERBAIKAN: Gunakan relasi ogImage, bukan ogImageUrl
		ogImage: post.ogImage?.url || post.featuredImage?.url || '',
		canonical: post.canonicalUrl || `${PUBLIC_SITE_URL}/blog/${post.slug}`,
		robots: `${post.noIndex ? 'noindex' : 'index'},${post.noFollow ? 'nofollow' : 'follow'}`
	};

	const schemaType = post.schemaType || 'BlogPosting';
	const jsonLd: JsonLdSchema = {
		'@context': 'https://schema.org',
		'@type': schemaType,
		headline: post.metaTitle || post.title,
		description: finalDescription,
		// PERBAIKAN: Akses relasi featuredImage
		image: post.featuredImage?.url || '',
		datePublished: post.createdAt.toISOString(),
		dateModified: post.updatedAt.toISOString(),
		// PERBAIKAN: Akses relasi author
		author: { '@type': 'Person', name: post.author.displayName || post.author.username
		},
		publisher: {
			'@type': 'Organization',
			name: settingsMap.publisher_name || siteTitle,
			logo: { '@type': 'ImageObject', url: settingsMap.publisher_logo_url || '' }
		},
		mainEntityOfPage: { '@type': 'WebPage', '@id': `${PUBLIC_SITE_URL}/blog/${post.slug}` }
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

	return json({
		post: { ...post, content: contentHtml },
		meta,
		jsonLd
	});
};