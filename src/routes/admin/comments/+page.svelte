<script lang="ts">
	import type { PageData } from './$types';
	import { enhance } from '$app/forms';
	import { CheckCircle, XCircle, Trash2 } from 'lucide-svelte';
	export let data: PageData;
</script>

<main class="w-full">
	<div class="mb-8">
		<h1 class="text-2xl font-bold text-slate-100 sm:text-3xl">Manajemen Komentar</h1>
		<p class="mt-1 text-sm text-slate-400">Moderasi semua interaksi dari pembaca Anda.</p>
	</div>

	<div class="w-full overflow-hidden rounded-lg border border-slate-800">
		<div class="overflow-x-auto">
			<table class="min-w-full divide-y divide-slate-800">
				<thead class="bg-slate-800/50">
					<tr>
						<th class="w-2/5 px-6 py-3 text-left text-xs font-medium uppercase tracking-wider text-slate-400">Komentar</th>
						<th class="w-1/5 px-6 py-3 text-left text-xs font-medium uppercase tracking-wider text-slate-400">Penulis</th>
						<th class="w-1/5 px-6 py-3 text-left text-xs font-medium uppercase tracking-wider text-slate-400">Pada Postingan</th>
						<th class="w-1/5 px-6 py-3 text-left text-xs font-medium uppercase tracking-wider text-slate-400">Aksi</th>
					</tr>
				</thead>
				<tbody class="divide-y divide-slate-800 bg-slate-900">
					{#each data.comments as comment (comment.id)}
						<tr class:opacity-50={!comment.isApproved}>
							<td class="px-6 py-4 align-top">
								<p class="text-sm text-slate-200">{comment.content}</p>
								<p class="mt-2 text-xs text-slate-500">{new Date(comment.createdAt).toLocaleString('id-ID')}</p>
							</td>
							<td class="whitespace-nowrap px-6 py-4 align-top text-sm text-slate-300">
								<p class="font-semibold">{comment.authorName}</p>
								<p class="text-xs text-slate-500">{comment.authorEmail}</p>
							</td>
							<td class="whitespace-nowrap px-6 py-4 align-top text-sm text-slate-400">{comment.post.title}</td>
							<td class="whitespace-nowrap px-6 py-4 align-top text-sm">
								<div class="flex items-center gap-x-4">
									<form method="POST" action="?/toggleApproval" use:enhance>
										<input type="hidden" name="id" value={comment.id} />
										<input type="hidden" name="isApproved" value={comment.isApproved.toString()} />
										{#if comment.isApproved}
											<button type="submit" class="flex items-center gap-1 text-yellow-400 hover:text-yellow-300"><XCircle size={14} /> Batalkan</button>
										{:else}
											<button type="submit" class="flex items-center gap-1 text-green-400 hover:text-green-300"><CheckCircle size={14} /> Setujui</button>
										{/if}
									</form>
									<form method="POST" action="?/deleteComment" use:enhance>
										<input type="hidden" name="id" value={comment.id} />
										<button type="submit" class="flex items-center gap-1 text-red-400 hover:text-red-300"><Trash2 size={14} /> Hapus</button>
									</form>
								</div>
							</td>
						</tr>
					{:else}
						<tr>
							<td colspan="4" class="px-6 py-12 text-center text-sm text-slate-500">Belum ada komentar.</td>
						</tr>
					{/each}
				</tbody>
			</table>
		</div>
	</div>
</main>