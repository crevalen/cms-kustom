<script lang="ts">
	import PageForm from '$lib/components/admin/PageForm.svelte';
	import type { ActionData, PageData } from './$types';
	export let form: ActionData;
	// svelte-ignore export_let_unused
		export let data: PageData;
</script>

<main class="w-full">
	<h1 class="mb-8 text-3xl font-bold text-slate-100">Buat Halaman Baru</h1>
	<PageForm {form} />
</main>