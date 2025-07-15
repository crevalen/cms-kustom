<script lang="ts">
	import { createEventDispatcher, onMount } from 'svelte';
	import { Check, Link, Trash2, X } from 'lucide-svelte';

	export let href: string = '';
	export let target: string = '';

	let urlInput: HTMLInputElement;
	let newTab: boolean = target === '_blank';
	const dispatch = createEventDispatcher();

	onMount(() => {
		// Otomatis fokus ke input URL saat modal muncul
		urlInput?.focus();
	});

	function handleSave() {
		dispatch('save', {
			href: href,
			target: newTab ? '_blank' : ''
		});
	}
</script>

<!-- svelte-ignore a11y_interactive_supports_focus -->

<div
	role="dialog"
	aria-modal="true"
	class="fixed inset-0 z-50 flex items-center justify-center bg-black/70 backdrop-blur-sm"
	on:click={() => dispatch('close')}
	on:keydown={(e) => { if (e.key === 'Escape') dispatch('close'); }}
>
	<!-- svelte-ignore a11y_click_events_have_key_events -->
	<!-- svelte-ignore a11y_no_noninteractive_element_interactions -->
	<div role="document" class="w-full max-w-md rounded-xl border border-slate-700 bg-slate-800 p-6 shadow-2xl" on:click|stopPropagation>
		<div class="mb-4 flex items-center justify-between">
			<h3 class="text-lg font-semibold text-white">Edit Link</h3>
			<button on:click={() => dispatch('close')} class="text-slate-400 hover:text-white"><X size={20} /></button>
		</div>
		<div class="space-y-4">
			<div>
				<label for="link-url" class="mb-2 block text-sm font-medium text-slate-400">URL</label>
				<div class="relative">
					<div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3">
						<Link size={16} class="text-slate-500" />
					</div>
					<input
						bind:this={urlInput}
						bind:value={href}
						on:keydown={(e) => { if (e.key === 'Enter') handleSave(); }}
						id="link-url"
						type="text"
						placeholder="https://..."
						class="w-full rounded-lg border-slate-700 bg-slate-900 p-3 pl-10 text-sm text-slate-200"
					/>
				</div>
			</div>
			<div class="flex items-center">
				<input
					id="new-tab"
					type="checkbox"
					bind:checked={newTab}
					class="h-4 w-4 rounded border-slate-600 bg-slate-700 text-blue-600 focus:ring-blue-600"
				/>
				<label for="new-tab" class="ms-3 text-sm font-medium text-slate-300"
					>Buka di tab baru</label
				>
			</div>
		</div>
		<div class="mt-6 flex justify-between border-t border-slate-700 pt-4">
			<button type="button" on:click={() => dispatch('remove')} class="inline-flex items-center gap-2 rounded-lg px-4 py-2 text-sm font-medium text-red-400 hover:bg-red-500/10">
				<Trash2 size={16}/> Hapus Link
			</button>
			<button
				type="button"
				on:click={handleSave}
				class="inline-flex items-center gap-2 rounded-lg bg-blue-600 px-4 py-2 text-sm font-semibold text-white hover:bg-blue-500"
			>
				<Check size={16}/> Simpan
			</button>
		</div>
	</div>
</div>