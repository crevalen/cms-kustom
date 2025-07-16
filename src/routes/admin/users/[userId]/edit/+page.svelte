<script lang="ts">
	import type { PageData, ActionData } from './$types';
	import { CheckCircle, AlertTriangle } from 'lucide-svelte';
	import { enhance } from '$app/forms';

	export let data: PageData;
	export let form: {
  success?: boolean;
  message?: string;
} | null;

	let imagePreviewUrl: string | null = data.user.avatarUrl ?? null;
	let notification: { type: 'success' | 'error'; message: string } | null = null;

	// Logika notifikasi yang sudah diperbaiki
	$: if (form?.message) {
		notification = {
			type: form.success ? 'success' : 'error',
			message: form.message
		};
		const timer = setTimeout(() => {
			notification = null;
			form = null; // Reset form setelah notifikasi hilang
		}, 4000);
	}

	function handleImageSelect(e: Event) {
		const input = e.target as HTMLInputElement;
		if (input.files && input.files[0]) {
			imagePreviewUrl = URL.createObjectURL(input.files[0]);
		}
	}
</script>

{#if notification}
	<div
		class="fixed top-5 right-5 z-50 flex items-center gap-4 rounded-lg p-4 {notification.type ===
		'success'
			? 'bg-green-600/95'
			: 'bg-red-600/95'} border {notification.type === 'success'
			? 'border-green-500'
			: 'border-red-500'} text-white shadow-lg backdrop-blur-sm"
	>
		{#if notification.type === 'success'}<CheckCircle />{:else}<AlertTriangle />{/if}
		<p class="text-sm font-medium">{notification.message}</p>
	</div>
{/if}

<main class="w-full">
	<h1 class="mb-8 text-3xl font-bold text-slate-100">Edit Pengguna: {data.user.username}</h1>

	<form
		method="POST"
		enctype="multipart/form-data"
		use:enhance={() => {
  return ({ result }) => {
    if (result.type === 'failure' || result.type === 'success') {
      if (result.data) {
        form = result.data as { success?: boolean; message?: string };
      } else {
        form = null;
      }
    }
  };
}}
		class="flex max-w-lg flex-col gap-y-6 rounded-lg border border-slate-800 bg-slate-800/50 p-6"
	>
		<div>
			<label for="username" class="mb-2 block text-sm font-medium text-slate-300">Username</label>
			<input
				id="username"
				name="username"
				type="text"
				required
				value={data.user.username}
				class="w-full rounded-lg border-slate-700 bg-slate-900 p-3 text-slate-200 focus:border-blue-500 focus:ring-blue-500"
			/>
		</div>
		<div>
			<label for="displayName" class="mb-2 block text-sm font-medium text-slate-300"
				>Nama Tampilan</label
			>
			<input
				id="displayName"
				name="displayName"
				type="text"
				value={data.user.displayName ?? ''}
				placeholder="Nama yang akan tampil di artikel"
				class="w-full rounded-lg border-slate-700 bg-slate-900 p-3 text-slate-200 focus:border-blue-500 focus:ring-blue-500"
			/>
		</div>
		<div>
			<label for="bio" class="mb-2 block text-sm font-medium text-slate-300">Bio Singkat</label>
			<textarea
				id="bio"
				name="bio"
				rows="3"
				placeholder="Sedikit tentang diri Anda..."
				class="w-full rounded-lg border-slate-700 bg-slate-900 p-3 text-slate-200 focus:border-blue-500 focus:ring-blue-500"
			>{data.user.bio ?? ''}</textarea>
		</div>
		<div>
			<label for="avatar" class="mb-2 block text-sm font-medium text-slate-300"
				>Foto Profil</label
			>
			{#if imagePreviewUrl}
				<img
					src={imagePreviewUrl}
					alt="Pratinjau avatar"
					class="mb-4 h-24 w-24 rounded-full object-cover"
				/>
			{/if}
			<input
				id="avatar"
				name="avatar"
				type="file"
				accept="image/*"
				on:change={handleImageSelect}
				class="block w-full text-sm text-slate-400 file:mr-4 file:rounded-full file:border-0 file:bg-blue-500/10 file:px-4 file:py-2 file:text-sm file:font-semibold file:text-blue-300 hover:file:bg-blue-500/20"
			/>
		</div>
		<div>
			<label for="password" class="mb-2 block text-sm font-medium text-slate-300"
				>Password Baru</label
			>
			<input
				id="password"
				name="password"
				type="password"
				placeholder="Biarkan kosong jika tidak ingin mengubah"
				class="w-full rounded-lg border-slate-700 bg-slate-900 p-3 text-slate-200 focus:border-blue-500 focus:ring-blue-500"
			/>
		</div>
		<div>
			<label for="role" class="mb-2 block text-sm font-medium text-slate-300">Role</label>
			<select
				id="role"
				name="role"
				value={data.user.role}
				class="w-full rounded-lg border-slate-700 bg-slate-900 p-3 text-slate-200 focus:border-blue-500 focus:ring-blue-500"
			>
				<option value="AUTHOR">Author</option>
				<option value="EDITOR">Editor</option>
				<option value="ADMIN">Admin</option>
			</select>
		</div>

		<div class="mt-4 flex items-center gap-x-4 border-t border-slate-700 pt-6">
			<button
				type="submit"
				class="rounded-lg bg-gradient-to-r from-blue-600 to-purple-600 px-8 py-2.5 font-semibold text-white"
			>
				Simpan Perubahan
			</button>
			<a href="/admin/users" class="text-sm font-medium text-slate-400 hover:text-slate-200"
				>Batal</a
			>
		</div>

		{#if form?.message && !form.success}
			<p class="text-sm text-red-400">{form.message}</p>
		{/if}
	</form>
</main>