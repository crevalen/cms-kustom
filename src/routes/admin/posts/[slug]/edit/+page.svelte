<script lang="ts">
	import PostForm from '$lib/components/admin/PostForm.svelte';
	import type { ActionData, PageData } from './$types';
	export let data: PageData;
	export let form: ActionData;
</script>

<div class="min-h-screen bg-slate-900 text-slate-200">
	<main class="mx-auto max-w-7xl px-4 py-10 sm:px-6 lg:px-8">
		<h1 class="mb-8 text-3xl font-bold text-slate-100">Edit Postingan</h1>
		<PostForm
			title={data.post.title}
			slug={data.post.slug}
			content={data.post.content ?? ''}
			published={data.post.published}
			metaTitle={data.post.metaTitle ?? ''}
			metaDescription={data.post.metaDescription ?? ''}
			allCategories={data.allCategories}
			allTags={data.allTags}
			selectedCategories={data.post.categories}
			selectedTags={data.post.tags}
			apiKey={data.apiKey}
			existingImageUrl={data.post.featuredImageUrl}
			ogTitle={data.post.ogTitle ?? ''}
    		ogDescription={data.post.ogDescription ?? ''}
    		canonicalUrl={data.post.canonicalUrl ?? ''}
    		noIndex={data.post.noIndex}
    		noFollow={data.post.noFollow}
			{form}
		/>
	</main>
</div>