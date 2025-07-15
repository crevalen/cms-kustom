<script lang="ts">
	import PostForm from '$lib/components/admin/PostForm.svelte';
	import type { ActionData, PageData } from './$types';
	export let form: ActionData;
	export let data: PageData;
</script>

<div class="min-h-screen bg-slate-900 text-slate-200">
	<main class="mx-auto max-w-7xl px-4 py-10 sm:px-6 lg:px-8">
		<h1 class="mb-8 text-3xl font-bold text-slate-100">Tulis Postingan Baru</h1>
		<PostForm
			allCategories={data.allCategories}
			allTags={data.allTags}
			apiKey={data.apiKey}
			{form}
		/>
	</main>
</div>