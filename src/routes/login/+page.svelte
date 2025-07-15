<script lang="ts">
	import type { ActionData } from './$types';
	export let form: ActionData;
</script>

<div class="flex min-h-screen w-full items-center justify-center bg-gradient-to-br from-gray-900 via-slate-900 to-black p-4">
	
	<div class="w-full max-w-md rounded-2xl border border-slate-700 bg-slate-800/50 p-8 shadow-2xl shadow-blue-500/10 backdrop-blur-lg">
		
		<h1 class="mb-6 text-center text-3xl font-bold text-slate-100">
			Admin Login
		</h1>
		
		<form method="POST" class="flex flex-col gap-y-4">
			<div>
				<label for="username" class="mb-1 block text-sm font-medium text-slate-400">Username</label>
				<input
					id="username"
					name="username"
					type="text"
					required
					class="block w-full rounded-lg border border-slate-700 bg-slate-900/70 p-2.5 text-slate-200 transition-all placeholder:text-slate-500 focus:border-blue-500 focus:ring-2 focus:ring-blue-500/50 focus:outline-none"
				/>
			</div>
			
			<div>
				<label for="password" class="mb-1 block text-sm font-medium text-slate-400">Password</label>
				<input
					id="password"
					name="password"
					type="password"
					required
					class="block w-full rounded-lg border border-slate-700 bg-slate-900/70 p-2.5 text-slate-200 transition-all placeholder:text-slate-500 focus:border-blue-500 focus:ring-2 focus:ring-blue-500/50 focus:outline-none"
				/>
			</div>
			
			<button
				type="submit"
				class="mt-4 w-full rounded-lg bg-gradient-to-r from-blue-600 to-purple-600 py-3 text-base font-semibold text-white shadow-lg shadow-blue-500/20 transition-transform hover:scale-105 focus:outline-none focus:ring-2 focus:ring-purple-500 focus:ring-offset-2 focus:ring-offset-slate-900"
			>
				Login
			</button>
		</form>

		{#if form?.error}
			<div class="mt-4 rounded-lg border border-red-500/50 bg-red-500/20 p-3 text-center text-sm text-red-300">
				{form.error}
			</div>
		{/if}
	</div>
</div>