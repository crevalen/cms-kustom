<script lang="ts">
	import type { PageData, ActionData } from './$types';
	import { enhance } from '$app/forms';
	import { CheckCircle, AlertTriangle } from 'lucide-svelte';

	export let data: PageData;
	export let form: ActionData;

	let notification: { type: 'success' | 'error'; message: string } | null = null;
	$: if (form) {
		notification = {
			type: form.success ? 'success' : 'error',
			message: form.message ?? 'Terjadi kesalahan'
		};
		form = null;
		setTimeout(() => (notification = null), 4000);
	}
</script>

{#if notification}
	<div
		class="fixed top-5 right-5 z-50 flex items-center gap-4 rounded-lg p-4 {notification.type === 'success'
			? 'bg-green-600/95'
			: 'bg-red-600/95'} border {notification.type === 'success'
			? 'border-green-500'
			: 'border-red-500'} text-white shadow-lg backdrop-blur-sm"
	>
		{#if notification.type === 'success'}<CheckCircle />{:else}<AlertTriangle />{/if}
		<p class="text-sm font-medium">{notification.message}</p>
	</div>
{/if}

<div class="w-full">
	<form method="POST" use:enhance>
		<div class="mb-8 flex items-center justify-between">
			<div>
				<h1 class="text-2xl font-bold text-slate-100 sm:text-3xl">Robots.txt Editor</h1>
				<p class="mt-1 text-sm text-slate-400">Atur direktif untuk crawler mesin pencari.</p>
			</div>
			<button
				type="submit"
				class="rounded-lg bg-gradient-to-r from-blue-600 to-purple-600 px-8 py-2.5 text-sm font-semibold text-white shadow-lg transition-transform hover:scale-105"
			>
				Simpan Perubahan
			</button>
		</div>

		<div class="rounded-lg border border-slate-800 bg-slate-800/50 p-6">
			<!-- svelte-ignore element_invalid_self_closing_tag -->
			<textarea
				name="content"
				bind:value={data.content}
				class="h-96 w-full rounded-lg border-slate-700 bg-slate-900 p-4 font-mono text-sm text-slate-200 focus:border-blue-500 focus:ring-blue-500"
				placeholder={`User-agent: *
Allow: /`}
			/>
		</div>
	</form>
</div>