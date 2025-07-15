<script lang="ts">
	import type { PageData, ActionData } from './$types';
	import { enhance } from '$app/forms';

	export let data: PageData;
	export let form: ActionData;
</script>

<main class="w-full">
	<div class="mb-8 flex items-center justify-between">
		<h1 class="text-3xl font-bold text-slate-100">Kelola Kategori & Tag</h1>
		<a
			href="/admin"
			class="rounded-lg bg-slate-800 px-5 py-2.5 text-sm font-medium text-slate-300 ring-1 ring-slate-700 transition-colors hover:bg-slate-700 hover:text-slate-100"
		>
			← Kembali ke Dasbor
		</a>
	</div>

	<div class="grid grid-cols-1 gap-8 md:grid-cols-2">
		<div class="space-y-4 rounded-xl border border-slate-800 bg-slate-900/50 p-6">
			<h2 class="text-xl font-semibold text-white">Kategori</h2>
			<form method="POST" action="?/createCategory" use:enhance class="flex gap-2">
				<input
					name="name"
					required
					placeholder="Nama kategori baru..."
					class="w-full rounded-lg border-slate-700 bg-slate-900 p-2 text-sm text-slate-200 placeholder:text-slate-500 focus:border-blue-500 focus:ring-1 focus:ring-blue-500"
				/>
				<button
					type="submit"
					class="rounded-lg bg-blue-600 px-4 py-2 text-sm font-semibold text-white transition-colors hover:bg-blue-500"
					>Tambah</button
				>
			</form>
			{#if form && 'entity' in form && form.entity === 'category' && form.error}
				<p class="text-sm text-red-400">{form.error}</p>
			{/if}
			<div class="flex max-h-60 flex-wrap gap-2 overflow-y-auto pt-2">
				{#each data.categories as category}
					<span class="rounded-full bg-blue-500/10 px-3 py-1 text-sm font-medium text-blue-300"
						>{category.name}</span
					>
				{/each}
			</div>
		</div>
		<div class="space-y-4 rounded-xl border border-slate-800 bg-slate-900/50 p-6">
			<h2 class="text-xl font-semibold text-white">Tag</h2>
			<form method="POST" action="?/createTag" use:enhance class="flex gap-2">
				<input
					name="name"
					required
					placeholder="Nama tag baru..."
					class="w-full rounded-lg border-slate-700 bg-slate-900 p-2 text-sm text-slate-200 placeholder:text-slate-500 focus:border-purple-500 focus:ring-1 focus:ring-purple-500"
				/>
				<button
					type="submit"
					class="rounded-lg bg-purple-600 px-4 py-2 text-sm font-semibold text-white transition-colors hover:bg-purple-500"
					>Tambah</button
				>
			</form>
			{#if form && 'entity' in form && form.entity === 'tag' && form.error}
				<p class="text-sm text-red-400">{form.error}</p>
			{/if}
			<div class="flex max-h-60 flex-wrap gap-2 overflow-y-auto pt-2">
				{#each data.tags as tag}
					<span
						class="rounded-full bg-purple-500/10 px-3 py-1 text-sm font-medium text-purple-300"
						>{tag.name}</span
					>
				{/each}
			</div>
		</div>
	</div>
</main>