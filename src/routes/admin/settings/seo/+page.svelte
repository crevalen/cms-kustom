<script lang="ts">
	import type { PageData, ActionData } from './$types';
	import { enhance } from '$app/forms';

	export let data: PageData;
	export let form: ActionData;

    // Set nilai default jika pengaturan belum ada di database
	let siteTitle = data.settings.site_title ?? 'Nama Blog Keren';
	let siteDescription = data.settings.site_description ?? 'Deskripsi singkat tentang blog Anda.';
	let postTitleTemplate = data.settings.post_title_template ?? '%post_title% | %site_title%';
</script>

<div class="w-full">
	<form method="POST" use:enhance>
		<div class="mb-8 flex items-center justify-between">
			<div>
				<h1 class="text-2xl font-bold text-slate-100 sm:text-3xl">Pengaturan SEO Global</h1>
				<p class="mt-1 text-sm text-slate-400">
					Atur bagaimana mesin pencari melihat situs Anda secara keseluruhan.
				</p>
			</div>
			<button
				type="submit"
				class="rounded-lg bg-gradient-to-r from-blue-600 to-purple-600 px-8 py-2.5 text-sm font-semibold text-white shadow-lg transition-transform hover:scale-105"
			>
				Simpan Pengaturan
			</button>
		</div>

		{#if form?.message}
			<div class="mb-6 rounded-md {form.success ? 'bg-green-500/20 text-green-300' : 'bg-red-500/20 text-red-300'} p-3 text-sm" >
				{form.message}
			</div>
		{/if}

		<div class="flex flex-col gap-y-6 rounded-lg border border-slate-800 bg-slate-800/50 p-6">
			<div>
				<label for="site_title" class="mb-2 block text-sm font-medium text-slate-300">Judul Situs</label>
				<input
					id="site_title"
					name="site_title"
					bind:value={siteTitle}
					class="w-full rounded-lg border-slate-700 bg-slate-900 p-3 text-slate-200 focus:border-blue-500 focus:ring-blue-500"
				/>
				<p class="mt-1 text-xs text-slate-500">Judul utama yang muncul di tab browser dan hasil pencarian.</p>
			</div>


			<div>
    <label for="publisher_name" class="mb-2 block text-sm font-medium text-slate-300">Nama Publisher</label>
    <input
        id="publisher_name"
        name="publisher_name"
        bind:value={data.settings.publisher_name}
        class="w-full rounded-lg border-slate-700 bg-slate-900 p-3 text-slate-200 focus:border-blue-500 focus:ring-blue-500"
    />
    <p class="mt-1 text-xs text-slate-500">Nama Anda, perusahaan, atau brand blog Anda.</p>
</div>
<div>
    <label for="publisher_logo_url" class="mb-2 block text-sm font-medium text-slate-300">URL Logo Publisher</label>
    <input
        id="publisher_logo_url"
        name="publisher_logo_url"
        bind:value={data.settings.publisher_logo_url}
        class="w-full rounded-lg border-slate-700 bg-slate-900 p-3 text-slate-200 focus:border-blue-500 focus:ring-blue-500"
    />
    <p class="mt-1 text-xs text-slate-500">URL lengkap ke file logo Anda (sebaiknya dari galeri media). Logo harus berukuran minimal 112x112px.</p>
</div>

			<div>
				<label for="site_description" class="mb-2 block text-sm font-medium text-slate-300">Deskripsi Situs</label>
				<textarea
					id="site_description"
					name="site_description"
					rows="3"
					bind:value={siteDescription}
					class="w-full rounded-lg border-slate-700 bg-slate-900 p-3 text-slate-200 focus:border-blue-500 focus:ring-blue-500"
				></textarea>
				<p class="mt-1 text-xs text-slate-500">Deskripsi default untuk halaman utama dan meta tag.</p>
			</div>
			<div>
				<label for="post_title_template" class="mb-2 block text-sm font-medium text-slate-300">Template Judul Postingan</label>
				<input
					id="post_title_template"
					name="post_title_template"
					bind:value={postTitleTemplate}
					class="w-full rounded-lg border-slate-700 bg-slate-900 p-3 text-slate-200 focus:border-blue-500 focus:ring-blue-500"
				/>
				<p class="mt-1 text-xs text-slate-500">
					Gunakan <code class="rounded bg-slate-700 px-1 text-xs">%post_title%</code> dan <code class="rounded bg-slate-700 px-1 text-xs">%site_title%</code> sebagai variabel.
				</p>
			</div>
		</div>
	</form>
</div>