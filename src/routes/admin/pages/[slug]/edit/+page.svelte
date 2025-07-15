<script lang="ts">
	import PageForm from '$lib/components/admin/PageForm.svelte';
	import type { ActionData, PageData } from './$types';
	export let form: ActionData;
	export let data: PageData;
</script>

<main class="w-full">
	<h1 class="mb-8 text-3xl font-bold text-slate-100">Edit Halaman</h1>
	<PageForm
		{form}
		title={data.page.title}
		slug={data.page.slug}
		content={data.page.content}
		published={data.page.published}
		metaTitle={data.page.metaTitle ?? ''}
		metaDescription={data.page.metaDescription ?? ''}
		schemaType={data.page.schemaType ?? 'WebPage'}
	/>
</main>