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
		<a
			href="/admin/comments"
			class="rounded-xl border border-slate-800 bg-slate-800/50 p-6 transition-colors hover:bg-slate-800"
		>
			<div class="flex items-center justify-between">
				<p class="text-sm font-medium text-slate-400">Perlu Moderasi</p>
				<AlertTriangle
					class="h-5 w-5 {data.stats.pendingComments > 0 ? 'text-yellow-400' : 'text-slate-500'}"
				/>
			</div>
			<p
				class="mt-2 text-3xl font-bold {data.stats.pendingComments > 0
					? 'text-yellow-400'
					: 'text-white'}"
			>
				{data.stats.pendingComments}
			</p>
		</a>
	</div>

	<div class="mt-8 rounded-xl border border-slate-800 bg-slate-800/50">
		<h3 class="border-b border-slate-800 p-4 text-lg font-semibold text-white">
			Postingan Terpopuler
		</h3>
		<div class="flex flex-col">
			{#each data.popularPosts as post, i}
				<a
					href="/admin/posts/{post.slug}/edit"
					class="flex items-center justify-between border-b border-slate-800 p-4 transition-colors last:border-b-0 hover:bg-slate-800"
				>
					<div class="flex items-center gap-4">
						<span class="text-xl font-bold text-slate-600">{i + 1}</span>
						<div>
							<p class="font-medium text-slate-100">{post.title}</p>
						</div>
					</div>
					<div class="flex items-center gap-2 text-sm font-semibold text-slate-300">
						<Eye size={16} class="text-slate-500" />
						{post.viewCount.toLocaleString()}
					</div>
				</a>
			{:else}
				<p class="p-4 text-center text-slate-500">Belum ada data view.</p>
			{/each}
		</div>
	</div>
</div>