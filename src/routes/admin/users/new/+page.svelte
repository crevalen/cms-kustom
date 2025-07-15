<script lang="ts">
	import type { ActionData } from './$types';
	export let form: ActionData;
</script>

<main class="w-full">
	<h1 class="mb-8 text-3xl font-bold text-slate-100">Tambah Pengguna Baru</h1>

	<form
		method="POST"
		class="flex max-w-lg flex-col gap-y-6 rounded-lg border border-slate-800 bg-slate-800/50 p-6"
	>
		<div>
			<label for="username" class="mb-2 block text-sm font-medium text-slate-300">Username</label>
			<input
				id="username"
				name="username"
				type="text"
				required
				class="w-full rounded-lg border-slate-700 bg-slate-900 p-3 text-slate-200 focus:border-blue-500 focus:ring-blue-500"
			/>
		</div>
		<div>
			<label for="password" class="mb-2 block text-sm font-medium text-slate-300">Password</label>
			<input
				id="password"
				name="password"
				type="password"
				required
				class="w-full rounded-lg border-slate-700 bg-slate-900 p-3 text-slate-200 focus:border-blue-500 focus:ring-blue-500"
			/>
		</div>
		<div>
			<label for="role" class="mb-2 block text-sm font-medium text-slate-300">Role</label>
			<select
				id="role"
				name="role"
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
				Simpan Pengguna
			</button>
			<a href="/admin/users" class="text-sm font-medium text-slate-400 hover:text-slate-200"
				>Batal</a
			>
		</div>

		{#if form?.error}
			<p class="text-sm text-red-400">{form.error}</p>
		{/if}
	</form>
</main>