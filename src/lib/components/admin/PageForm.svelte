<script lang="ts">
	import CustomEditor from './CustomEditor.svelte';
	// Props
	export let title = '';
	export let slug = '';
	export let metaTitle = '';
	export let metaDescription = '';
	export let content: string = '';
	export let published = false;
	export let schemaType = 'WebPage';
	export let form: { error?: string } | null = null;
</script>

<form method="POST" enctype="multipart/form-data">
	<div class="mb-8 flex items-center justify-end gap-x-4">
		<a
			href="/admin/pages"
			class="rounded-lg px-5 py-2 text-sm font-medium text-slate-400 transition-colors hover:text-slate-200"
			>Batal</a
		>
		<button
			type="submit"
			class="rounded-lg bg-gradient-to-r from-blue-600 to-purple-600 px-8 py-2.5 text-sm font-semibold text-white shadow-lg shadow-blue-500/20 transition-transform hover:scale-105"
		>
			Simpan Halaman
		</button>
	</div>

	<div class="grid grid-cols-1 gap-8 lg:grid-cols-3">
		<div class="flex flex-col gap-y-6 lg:col-span-2">
			<div class="rounded-lg border border-slate-800 bg-slate-800/50 p-6">
				<label for="title" class="mb-2 block text-sm font-medium text-slate-400">Judul Halaman</label>
				<input
					id="title"
					name="title"
					type="text"
					required
					bind:value={title}
					class="w-full rounded-lg border-slate-700 bg-slate-900 p-3 text-lg text-slate-200 focus:border-blue-500 focus:ring-2 focus:ring-blue-500/50"
				/>
			</div>
			<div class="rounded-lg border border-slate-800 bg-slate-800/50 p-6">
				<label for="slug" class="mb-2 block text-sm font-medium text-slate-400">Slug (URL)</label>
				<input
					id="slug"
					name="slug"
					type="text"
					required
					bind:value={slug}
					class="w-full rounded-lg border-slate-700 bg-slate-900 p-3 text-slate-200 focus:border-blue-500 focus:ring-2 focus:ring-blue-500/50"
				/>
			</div>
			<div class="rounded-lg border border-slate-800 bg-slate-800/50 p-2">
				<CustomEditor bind:value={content} />
			</div>
		</div>

		<div class="flex flex-col gap-y-6 lg:col-span-1">
			<div class="rounded-lg border border-slate-800 bg-slate-800/50 p-6">
				<h3 class="mb-4 font-semibold text-slate-200">Publikasi</h3>
				<div class="flex items-center">
					<input
						id="published"
						name="published"
						type="checkbox"
						bind:checked={published}
						class="h-4 w-4 rounded border-slate-600 bg-slate-700 text-blue-600 focus:ring-blue-600"
					/>
					<label for="published" class="ms-3 text-sm font-medium text-slate-300">Publikasikan</label>
				</div>
			</div>
			<div class="rounded-lg border border-slate-800 bg-slate-800/50 p-6">
				<h3 class="mb-4 font-semibold text-slate-200">Pengaturan SEO</h3>
				<div class="space-y-4">
					<div>
						<label for="metaTitle" class="mb-2 block text-sm font-medium text-slate-400">Meta Title</label>
						<input
							id="metaTitle"
							name="metaTitle"
							type="text"
							bind:value={metaTitle}
							class="w-full rounded-lg border-slate-700 bg-slate-900 p-3 text-sm"
						/>
					</div>
					<div>
						<label for="metaDescription" class="mb-2 block text-sm font-medium text-slate-400">Meta Description</label>
						<textarea
							id="metaDescription"
							name="metaDescription"
							rows="4"
							bind:value={metaDescription}
							class="w-full rounded-lg border-slate-700 bg-slate-900 p-3 text-sm"
						></textarea>
					</div>
					<div>
						<label for="schemaType" class="mb-2 block text-sm font-medium text-slate-400">Tipe Schema</label>
						<select
							id="schemaType"
							name="schemaType"
							bind:value={schemaType}
							class="w-full rounded-lg border-slate-700 bg-slate-900 p-3 text-sm text-slate-200 focus:border-blue-500 focus:ring-blue-500"
						>
							<option value="WebPage">Web Page (Default)</option>
							<option value="AboutPage">About Page</option>
							<option value="ContactPage">Contact Page</option>
							<option value="PrivacyPolicyPage">Privacy Policy Page</option>
							<option value="TermsOfServicePage">Terms of Service Page</option>
						</select>
					</div>
				</div>
			</div>
			{#if form?.error}
				<div class="rounded-lg border border-red-500/50 bg-red-500/20 p-3 text-sm text-red-300">
					{form.error}
				</div>
			{/if}
		</div>
	</div>

	<input type="hidden" name="content" value={content} />
</form>