<script lang="ts">
	import type { PageData, ActionData } from './$types';
	import { Image, UploadCloud, Trash2, Pencil, X, HardDrive } from 'lucide-svelte';
	import { enhance } from '$app/forms';
	import { PUBLIC_R2_URL } from '$env/static/public';

	export let data: PageData;
	export let form: ActionData;

	let editingMedia: { id: string; altText: string | null } | null = null;
	let modalEl: HTMLDivElement;

	// Fokus ke modal saat muncul untuk aksesibilitas keyboard
	$: if (editingMedia && modalEl) {
		modalEl.focus();
	}

	function formatBytes(bytes: number, decimals = 2) {
		if (bytes === 0) return '0 Bytes';
		const k = 1024;
		const dm = decimals < 0 ? 0 : decimals;
		const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
		const i = Math.floor(Math.log(bytes) / Math.log(k));
		return parseFloat((bytes / Math.pow(k, i)).toFixed(dm)) + ' ' + sizes[i];
	}
</script>

{#if editingMedia}
	<div
		role="dialog"
		aria-modal="true"
		bind:this={modalEl}
		tabindex="-1"
		class="fixed inset-0 z-50 flex items-center justify-center bg-black/70 backdrop-blur-sm"
		on:click={() => (editingMedia = null)}
		on:keydown={(e) => {
			if (e.key === 'Escape') editingMedia = null;
		}}
	>
		<div
    role="document"
    class="w-full max-w-md rounded-xl border border-slate-700 bg-slate-800 p-6 shadow-2xl"
>
			<div class="mb-4 flex items-center justify-between">
				<h3 class="text-lg font-semibold text-white">Edit Alt Text</h3>
				<button on:click={() => (editingMedia = null)} class="text-slate-400 hover:text-white">
					<X size={20} />
				</button>
			</div>
			<form
				method="POST"
				action="?/editFile"
				use:enhance={() => {
					editingMedia = null;
					return async ({ update }) => {
						await update({ reset: false });
					};
				}}
			>
				<input type="hidden" name="id" value={editingMedia.id} />
				<textarea
					name="altText"
					rows="3"
					class="w-full rounded-lg border-slate-700 bg-slate-900 p-3 text-sm text-slate-200 focus:border-blue-500 focus:ring-blue-500"
					placeholder="Deskripsi singkat gambar..."
				>{editingMedia.altText ?? ''}</textarea>
				<div class="mt-4 flex justify-end gap-3">
					<button
						type="button"
						on:click={() => (editingMedia = null)}
						class="rounded-lg px-4 py-2 text-sm font-medium text-slate-300 hover:bg-slate-700"
						>Batal</button
					>
					<button
						type="submit"
						class="rounded-lg bg-blue-600 px-4 py-2 text-sm font-semibold text-white hover:bg-blue-500"
						>Simpan</button
					>
				</div>
			</form>
		</div>
	</div>
{/if}

<div class="min-h-screen bg-slate-900 text-slate-200">
	<main class="mx-auto max-w-7xl px-4 py-10 sm:px-6 lg:px-8">
		<div class="mb-8 flex flex-col items-start justify-between gap-4 sm:flex-row sm:items-center">
			<div>
				<h1 class="text-2xl font-bold text-slate-100 sm:text-3xl">Galeri Media</h1>
				<p class="mt-1 text-sm text-slate-400">Upload, kelola, dan hapus aset gambar Anda.</p>
			</div>
			<a
				href="/admin"
				class="rounded-lg px-5 py-2 text-sm font-medium text-slate-400 transition-colors hover:text-slate-200"
				>← Kembali ke Dasbor</a
			>
		</div>

		<div class="mb-8 rounded-lg border-2 border-dashed border-slate-700 p-6 hover:border-blue-500">
			<form method="POST" action="?/uploadFile" enctype="multipart/form-data" use:enhance>
				<div class="flex flex-col items-center justify-center">
					<UploadCloud size={32} class="text-slate-500" />
					<label
						for="image-upload"
						class="relative mt-4 cursor-pointer rounded-md font-semibold text-blue-400 hover:text-blue-300"
					>
						<span>Upload sebuah file</span>
						<input
							id="image-upload"
							name="image"
							type="file"
							class="sr-only"
							accept="image/*"
							on:change={(e) => e.currentTarget.form?.requestSubmit()}
						/>
					</label>
					<p class="text-xs text-slate-500">PNG, JPG, dll akan diubah ke WebP.</p>
				</div>
			</form>
			{#if form?.message}
				<p class="mt-2 text-center text-sm {form.success ? 'text-green-400' : 'text-red-400'}">
					{form.message}
				</p>
			{/if}
		</div>

		{#if data.media.length > 0}
			<div
				class="grid grid-cols-1 gap-5 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5"
			>
				{#each data.media as medium (medium.id)}
					<div
						class="group relative overflow-hidden rounded-lg border border-slate-800 bg-slate-800/50"
					>
						<img
							src={medium.url}
							alt={medium.altText ?? 'Gambar'}
							class="h-40 w-full object-cover transition-transform group-hover:scale-105"
						/>
						<div class="p-3">
							<p class="truncate text-xs font-medium text-slate-300" title={medium.key}>{medium.key}</p>
							<div class="mt-2 flex items-center justify-between text-xs text-slate-500">
								<span class="flex items-center gap-1"
									><HardDrive size={12} /> {formatBytes(medium.size)}</span
								>
								<div class="flex items-center gap-2">
									<button
										on:click={() => (editingMedia = { id: medium.id, altText: medium.altText })}
										class="flex items-center gap-1 hover:text-white"><Pencil size={12} /> Edit</button
									>
									<form method="POST" action="?/deleteFile" use:enhance>
										<input type="hidden" name="id" value={medium.id} />
										<input type="hidden" name="key" value={medium.key} />
										<button type="submit" class="flex items-center gap-1 text-red-400 hover:text-red-300"
											><Trash2 size={12} /> Hapus</button
										>
									</form>
								</div>
							</div>
						</div>
					</div>
				{/each}
			</div>
		{:else}
			<div
				class="flex flex-col items-center justify-center rounded-lg border-2 border-dashed border-slate-700 py-24 text-center"
			>
				<Image size={48} class="text-slate-600" />
				<h3 class="mt-4 text-lg font-semibold text-slate-300">Galeri Kosong</h3>
				<p class="mt-1 text-sm text-slate-500">
					Upload gambar pertama Anda menggunakan form di atas.
				</p>
			</div>
		{/if}
	</main>
</div>