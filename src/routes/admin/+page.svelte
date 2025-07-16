<script lang="ts">
	import type { PageData } from './$types';
	import { BarChart2, Eye, MessageSquare, Newspaper, AlertTriangle } from 'lucide-svelte';
	export let data: PageData;
</script>

<div class="w-full">
	<div class="mb-8">
		<h1 class="text-3xl font-bold tracking-tight text-slate-100">Dasbor Utama</h1>
		<p class="mt-1 text-lg text-slate-400">Ringkasan aktivitas blog Anda.</p>
	</div>

	<div class="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-4">
		<div class="rounded-xl border border-slate-800 bg-slate-800/50 p-6">
			<div class="flex items-center justify-between">
				<p class="text-sm font-medium text-slate-400">Total Postingan</p>
				<Newspaper class="h-5 w-5 text-slate-500" />
			</div>
			<p class="mt-2 text-3xl font-bold text-white">{data.stats.posts}</p>
		</div>
		<div class="rounded-xl border border-slate-800 bg-slate-800/50 p-6">
			<div class="flex items-center justify-between">
				<p class="text-sm font-medium text-slate-400">Total Views</p>
				<Eye class="h-5 w-5 text-slate-500" />
			</div>
			<p class="mt-2 text-3xl font-bold text-white">{data.stats.views.toLocaleString()}</p>
		</div>
		<div class="rounded-xl border border-slate-800 bg-slate-800/50 p-6">
			<div class="flex items-center justify-between">
				<p class="text-sm font-medium text-slate-400">Total Komentar</p>
				<MessageSquare class="h-5 w-5 text-slate-500" />
			</div>
			<p class="mt-2 text-3xl font-bold text-white">{data.stats.comments}</p>
		</div>
		<a href="/admin/comments" class="rounded-xl border border-slate-800 bg-slate-800/50 p-6 transition-colors hover:bg-slate-800">
			<div class="flex items-center justify-between">
				<p class="text-sm font-medium text-slate-400">Perlu Moderasi</p>
				<AlertTriangle class="h-5 w-5 {data.stats.pendingComments > 0 ? 'text-yellow-400' : 'text-slate-500'}" />
			</div>
			<p class="mt-2 text-3xl font-bold {data.stats.pendingComments > 0 ? 'text-yellow-400' : 'text-white'}">{data.stats.pendingComments}</p>
		</a>
	</div>

	<div class="mt-8 rounded-xl border border-slate-800 bg-slate-800/50">
		<h3 class="border-b border-slate-800 p-4 text-lg font-semibold text-white">Postingan Terbaru</h3>
		<div class="flex flex-col">
			{#each data.recentPosts as post}
				<a
					href="/admin/posts/{post.slug}/edit"
					class="flex items-center justify-between border-b border-slate-800 p-4 transition-colors last:border-b-0 hover:bg-slate-800"
				>
					<div>
						<span class="font-medium text-slate-100">{post.title}</span>
						<div class="mt-1 flex items-center gap-x-2 text-xs text-slate-500">
							{#if post.published}
								<span class="flex items-center gap-1 rounded-full bg-green-500/10 px-2 py-0.5 text-green-400">
									<div class="h-1.5 w-1.5 rounded-full bg-green-400"></div>
									Published
								</span>
							{:else}
								<span class="flex items-center gap-1 rounded-full bg-slate-500/10 px-2 py-0.5 text-slate-400">
									<div class="h-1.5 w-1.5 rounded-full bg-slate-400"></div>
									Draft
								</span>
							{/if}
						</div>
					</div>
					<span class="text-sm text-slate-400">
						{new Date(post.createdAt).toLocaleDateString('id-ID', {
							day: '2-digit',
							month: 'short',
							year: 'numeric'
						})}
					</span>
				</a>
			{:else}
				<p class="p-4 text-center text-slate-500">Belum ada postingan.</p>
			{/each}
		</div>
	</div>
</div>