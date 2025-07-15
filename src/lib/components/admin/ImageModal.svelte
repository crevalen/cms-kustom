<script lang="ts">
	import { createEventDispatcher, onMount } from 'svelte';
	import type { Media } from '@prisma/client';

	export let media: Media[] = [];
	const dispatch = createEventDispatcher();

	let activeTab: 'gallery' | 'upload' = 'gallery';
	let fileInput: HTMLInputElement;
	let modalEl: HTMLDivElement;

	onMount(() => {
		// Fokus ke modal saat pertama kali muncul
		modalEl?.focus();
	});

	function selectImage(url: string, alt: string) {
		dispatch('insert', { src: url, alt: alt });
	}

	async function handleUpload() {
		const file = fileInput.files?.[0];
		if (!file) return;

		const formData = new FormData();
		formData.append('image', file);

		const response = await fetch('/api/media/upload', {
			method: 'POST',
			body: formData
		});

		if (response.ok) {
			const newImage = await response.json();
			selectImage(newImage.url, newImage.altText);
		} else {
			alert('Gagal mengunggah gambar.');
		}
	}
</script>

<div
	bind:this={modalEl}
	role="dialog"
	aria-modal="true"
	tabindex="-1"
	class="fixed inset-0 z-50 flex items-center justify-center bg-black/60 backdrop-blur-sm"
	on:click={() => dispatch('close')}
	on:keydown={(e) => {
		if (e.key === 'Escape') dispatch('close');
	}}
>
	<!-- svelte-ignore a11y_click_events_have_key_events -->
	<!-- svelte-ignore a11y_no_noninteractive_element_interactions -->
	<div
		role="document"
		class="w-full max-w-3xl rounded-lg bg-slate-800 shadow-xl"
		on:click|stopPropagation
	>
		<div class="border-b border-slate-700 p-4">
			<div class="flex gap-x-4">
				<button on:click={() => (activeTab = 'gallery')} class:active={activeTab === 'gallery'}
					>Pilih dari Galeri</button
				>
				<button on:click={() => (activeTab = 'upload')} class:active={activeTab === 'upload'}
					>Unggah Baru</button
				>
			</div>
		</div>

		<div class="p-4">
			{#if activeTab === 'gallery'}
				<div class="grid max-h-[60vh] grid-cols-4 gap-4 overflow-y-auto">
					{#each media as item}
						<button
							on:click={() => selectImage(item.url, item.altText ?? '')}
							class="overflow-hidden rounded-lg ring-2 ring-transparent transition-all hover:ring-blue-500 focus:ring-blue-500"
						>
							<img
								src={item.url}
								alt={item.altText ?? 'Gambar media'}
								class="aspect-square h-full w-full object-cover"
							/>
						</button>
					{:else}
						<p class="col-span-4 text-center text-slate-500">Galeri media kosong.</p>
					{/each}
				</div>
			{:else}
				<div
					class="flex flex-col items-center justify-center rounded-lg border-2 border-dashed border-slate-600 p-12"
				>
					<p class="mb-4 text-slate-400">Pilih file untuk diunggah</p>
					<input
						bind:this={fileInput}
						type="file"
						accept="image/*"
						class="mb-4 block w-full text-sm text-slate-400 file:mr-4 file:rounded-full file:border-0 file:bg-blue-500/10 file:px-4 file:py-2 file:text-sm file:font-semibold file:text-blue-300 hover:file:bg-blue-500/20"
					/>
					<button
						on:click={handleUpload}
						class="rounded-lg bg-blue-600 px-6 py-2 text-sm font-semibold text-white"
						>Unggah Sekarang</button
					>
				</div>
			{/if}
		</div>
	</div>
</div>

<style>
	button {
		padding: 0.5rem 1rem;
		border-radius: 0.5rem;
		font-weight: 500;
		color: hsl(215 20.2% 65.1%);
	}
	button.active {
		color: hsl(210 40% 98%);
		background-color: hsl(222.2 47.4% 15%);
	}
</style>