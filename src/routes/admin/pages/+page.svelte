<script lang="ts">
	import type { PageData } from './$types';
	import { enhance } from '$app/forms';
	export let data: PageData;
</script>

<main class="w-full">
	<div class="mb-8 flex items-center justify-between">
		<h1 class="text-3xl font-bold text-slate-100">Manajemen Halaman</h1>
		<a href="/admin/pages/new" class="rounded-lg bg-gradient-to-r from-blue-600 to-purple-600 px-5 py-2.5 text-sm font-semibold text-white shadow-lg">
			+ Buat Halaman Baru
		</a>
	</div>
	<div class="w-full overflow-hidden rounded-lg border border-slate-800">
		<table class="min-w-full divide-y divide-slate-800">
			<thead class="bg-slate-800/50">
				<tr>
					<th class="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider text-slate-400">Judul</th>
					<th class="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider text-slate-400">Slug</th>
					<th class="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider text-slate-400">Status</th>
					<th class="relative px-6 py-3"><span class="sr-only">Aksi</span></th>
				</tr>
			</thead>
			<tbody class="divide-y divide-slate-800 bg-slate-900">
				{#each data.pages as page (page.id)}
					<tr>
						<td class="whitespace-nowrap px-6 py-4 text-sm font-medium text-slate-100">{page.title}</td>
						<td class="whitespace-nowrap px-6 py-4 text-sm text-slate-400">/{page.slug}</td>
						<td class="whitespace-nowrap px-6 py-4 text-sm">
							{#if page.published}
								<span class="inline-flex rounded-full bg-green-500/10 px-2 py-1 text-xs font-medium text-green-400">Published</span>
							{:else}
								<span class="inline-flex rounded-full bg-slate-500/10 px-2 py-1 text-xs font-medium text-slate-400">Draft</span>
							{/if}
						</td>
						<td class="flex items-center justify-end gap-x-4 whitespace-nowrap px-6 py-4 text-right text-sm font-medium">
							<a href="/{page.slug}" target="_blank" class="text-green-400 hover:underline">Lihat</a>
							<a href="/admin/pages/{page.slug}/edit" class="text-blue-400 hover:underline">Edit</a>
							<form method="POST" action="?/delete" use:enhance><input type="hidden" name="id" value={page.id} /><button type="submit" class="text-red-400 hover:underline">Delete</button></form>
						</td>
					</tr>
				{/each}
			</tbody>
		</table>
	</div>
</main>