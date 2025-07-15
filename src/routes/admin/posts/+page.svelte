<script lang="ts">
	import type { PageData } from './$types';
	import { enhance } from '$app/forms';
	export let data: PageData;
</script>

<div class="min-h-screen bg-slate-900 text-slate-200">
	<main class="mx-auto max-w-7xl px-4 py-10 sm:px-6 lg:px-8">
		<div class="mb-8 flex flex-col items-start justify-between gap-4 sm:flex-row sm:items-center">
			<div>
				<h1 class="text-2xl font-bold text-slate-100 sm:text-3xl">Manajemen Postingan</h1>
				<p class="mt-1 text-sm text-slate-400">Buat, edit, dan hapus artikel blog Anda dari sini.</p>
			</div>
			<div class="flex w-full sm:w-auto gap-x-4">
				<a href="/admin" class="w-1/2 sm:w-auto rounded-lg px-5 py-2.5 text-center text-sm font-medium text-slate-300 ring-1 ring-slate-700 transition-colors hover:bg-slate-800 hover:text-slate-100">
					← Dasbor
				</a>
				<a href="/admin/posts/new" class="w-1/2 sm:w-auto flex-shrink-0 rounded-lg bg-gradient-to-r from-blue-600 to-purple-600 px-5 py-2.5 text-center text-sm font-semibold text-white shadow-lg shadow-blue-500/20 transition-transform hover:scale-105">
					+ Tulis Baru
				</a>
			</div>
		</div>

		<div class="w-full overflow-hidden rounded-lg border border-slate-800">
			<div class="overflow-x-auto">
				<table class="min-w-full divide-y divide-slate-800">
					<thead class="bg-slate-800/50">
						<tr>
							<th scope="col" class="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider text-slate-400">Judul</th>
							<th scope="col" class="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider text-slate-400">Author</th>
							<th scope="col" class="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider text-slate-400">Kategori & Tag</th>
							<th scope="col" class="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider text-slate-400">Status</th>
							<th scope="col" class="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider text-slate-400">Terakhir Diupdate</th>
							<th scope="col" class="relative px-6 py-3"><span class="sr-only">Aksi</span></th>
						</tr>
					</thead>
					<tbody class="divide-y divide-slate-800 bg-slate-900">
						{#each data.posts as post (post.id)}
							<tr>
								<td class="whitespace-nowrap px-6 py-4 text-sm font-medium text-slate-100">{post.title}</td>
								<td class="whitespace-nowrap px-6 py-4 text-sm text-slate-400">{post.author.username}</td>
								<td class="px-6 py-4 text-sm text-slate-400">
									<div class="flex flex-wrap gap-1">
										{#each post.categories as category}
											<span class="rounded-full bg-blue-500/10 px-2 py-0.5 text-xs text-blue-300">{category.name}</span>
										{/each}
										{#each post.tags as tag}
											<span class="rounded-full bg-purple-500/10 px-2 py-0.5 text-xs text-purple-300">{tag.name}</span>
										{/each}
									</div>
								</td>
								<td class="whitespace-nowrap px-6 py-4 text-sm">
									{#if post.published}
										<span class="inline-flex items-center rounded-full bg-green-500/10 px-2 py-1 text-xs font-medium text-green-400">Published</span>
									{:else}
										<span class="inline-flex items-center rounded-full bg-slate-500/10 px-2 py-1 text-xs font-medium text-slate-400">Draft</span>
									{/if}
								</td>
								<td class="whitespace-nowrap px-6 py-4 text-sm text-slate-500">
									{new Date(post.updatedAt).toLocaleDateString('id-ID', { day: '2-digit', month: 'short', year: 'numeric' })}
								</td>
								<td class="flex items-center justify-end gap-x-4 whitespace-nowrap px-6 py-4 text-right text-sm font-medium">
									<a href="/blog/{post.slug}" target="_blank" class="text-green-400 transition-colors hover:text-green-300">Lihat</a>
									<a href="/admin/posts/{post.slug}/edit" class="text-blue-400 transition-colors hover:text-blue-300">Edit</a>
									<form method="POST" action="?/delete" use:enhance>
										<input type="hidden" name="id" value={post.id} />
										<button type="submit" class="text-red-400 transition-colors hover:text-red-300" on:click|preventDefault={(e) => {
											if(confirm(`Anda yakin ingin menghapus postingan '${post.title}'?`)) {
												e.currentTarget.form?.submit()
											}
										}}>Delete</button>
									</form>
								</td>
							</tr>
						{:else}
							<tr>
								<td colspan="6" class="px-6 py-12 text-center text-sm text-slate-500">
									Anda belum memiliki postingan. Silakan buat yang baru.
								</td>
							</tr>
						{/each}
					</tbody>
				</table>
			</div>
		</div>
	</main>
</div>