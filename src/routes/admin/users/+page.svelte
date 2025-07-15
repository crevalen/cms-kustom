<script lang="ts">
	import type { PageData } from './$types';
	import { enhance } from '$app/forms';
	export let data: PageData;
</script>

<main class="w-full">
	<div class="mb-8 flex flex-col items-start justify-between gap-4 sm:flex-row sm:items-center">
		<div>
			<h1 class="text-2xl font-bold text-slate-100 sm:text-3xl">Manajemen Pengguna</h1>
			<p class="mt-1 text-sm text-slate-400">Buat, edit, dan kelola pengguna CMS Anda.</p>
		</div>
		<a
			href="/admin/users/new"
			class="w-full sm:w-auto flex-shrink-0 rounded-lg bg-gradient-to-r from-blue-600 to-purple-600 px-5 py-2.5 text-center text-sm font-semibold text-white shadow-lg shadow-blue-500/20 transition-transform hover:scale-105"
		>
			+ Tambah User Baru
		</a>
	</div>

	<div class="w-full overflow-hidden rounded-lg border border-slate-800">
		<div class="overflow-x-auto">
			<table class="min-w-full divide-y divide-slate-800">
				<thead class="bg-slate-800/50">
					<tr>
						<th class="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider text-slate-400">Username</th>
						<th class="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider text-slate-400">Role</th>
						<th class="relative px-6 py-3"><span class="sr-only">Aksi</span></th>
					</tr>
				</thead>
				<tbody class="divide-y divide-slate-800 bg-slate-900">
					{#each data.users as user (user.id)}
						<tr>
							<td class="whitespace-nowrap px-6 py-4 text-sm font-medium text-slate-100">{user.username}</td>
							<td class="whitespace-nowrap px-6 py-4 text-sm">
								<span class="rounded-full px-2 py-1 text-xs font-semibold
                                    {user.role === 'ADMIN' ? 'bg-green-500/10 text-green-400' : 'bg-slate-500/10 text-slate-400'}">
									{user.role}
								</span>
							</td>
							<td class="flex items-center justify-end gap-x-4 whitespace-nowrap px-6 py-4 text-right text-sm font-medium">
								<a href="/admin/users/{user.id}/edit" class="text-blue-400 transition-colors hover:text-blue-300">Edit</a>
								<form method="POST" action="?/deleteUser" use:enhance>
									<input type="hidden" name="id" value={user.id} />
									<button type="submit" class="text-red-400 transition-colors hover:text-red-300" on:click|preventDefault={(e) => {
                                        if(confirm(`Anda yakin ingin menghapus user '${user.username}'?`)) {
                                            e.currentTarget.form?.submit()
                                        }
                                    }}>Delete</button>
								</form>
							</td>
						</tr>
					{/each}
				</tbody>
			</table>
		</div>
	</div>
</main>