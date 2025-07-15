<script lang="ts">
	import { browser } from '$app/environment';
	import { onMount, onDestroy } from 'svelte';
	import CustomEditor from './CustomEditor.svelte';
	import { CheckCircle, AlertTriangle, X as IconX, Plus } from 'lucide-svelte';
	
	type Taxonomy = { id: string; name: string };
	type AnalysisResult = { text: string; status: 'good' | 'bad' | 'ok' };

	// Props
	export let title = '';
	export let slug = '';
	export let metaTitle = '';
	export let metaDescription = '';
	export let focusKeyword = '';
	export let ogTitle = '';
	export let ogDescription = '';
	export let canonicalUrl = '';
	export let noIndex = false;
	export let noFollow = false;
	export let schemaType = 'BlogPosting';
	// svelte-ignore export_let_unused
		export let selectedOgImage: { id: string, url: string } | null = null;
	export let content: string = '';
	export let published = false;
	export let form: { error?: string; success?: boolean; message?: string } | null = null;
	export let allCategories: Taxonomy[] = [];
	export let allTags: Taxonomy[] = [];
	export let selectedCategories: Taxonomy[] = [];
	export let selectedTags: Taxonomy[] = [];
	export let existingImageUrl: string | null | undefined = null;

	// State internal
	let imagePreviewUrl: string | null = existingImageUrl ?? null;
	let notification: { type: 'success' | 'error'; message: string } | null = null;
	let isCreatingCategory = false;
	let newCategoryName = '';
	let isCreatingTag = false;
	let newTagName = '';
	let categoryString: string;
	let tagString: string;
	let readabilityScore = 0;
	let readabilityText = '...';
	let readabilityColor = 'text-slate-400';
	let analysisResults: AnalysisResult[] = [];
	// Logika Notifikasi
	$: if (form) {
		if (form.success && form.message) {
			notification = { type: 'success', message: form.message };
		} else if (form.error) {
			notification = { type: 'error', message: form.error };
		}
		form = null;
		setTimeout(() => (notification = null), 4000);
	}
	
	// --- FUNGSI-FUNGSI BARU UNTUK READABILITY KUSTOM ---
	function countSyllables(word: string): number {
		word = word.toLowerCase();
		if (word.length <= 3) return 1;
		word = word.replace(/(?:[^laeiouy]es|ed|[^laeiouy]e)$/, '');
		word = word.replace(/^y/, '');
		const match = word.match(/[aeiouy]{1,2}/g);
		return match ? match.length : 0;
	}

	function calculateFleschKincaid(text: string): number {
		const words = text.match(/\b\w+\b/g) ?? [];
		const sentences = text.match(/[^.!?]+[.!?]+/g) ?? [];
		const totalWords = words.length;
		const totalSentences = sentences.length;
		if (totalWords === 0 || totalSentences === 0) return 0;
		
		let totalSyllables = 0;
		for (const word of words) {
			totalSyllables += countSyllables(word);
		}
		
		const score = 206.835 - 1.015 * (totalWords / totalSentences) - 84.6 * (totalSyllables / totalWords);
		return Math.max(0, Math.min(100, score)); // Pastikan skor antara 0 dan 100
	}
	
	function interpretFleschKincaid(score: number): { text: string; color: string } {
		if (score >= 90) return { text: 'Sangat Mudah Dibaca', color: 'text-green-400' };
		if (score >= 70) return { text: 'Mudah Dibaca', color: 'text-green-400' };
		if (score >= 60) return { text: 'Cukup Mudah Dibaca', color: 'text-yellow-400' };
		if (score >= 50) return { text: 'Agak Sulit Dibaca', color: 'text-yellow-400' };
		if (score >= 30) return { text: 'Sulit Dibaca', color: 'text-red-400' };
		return { text: 'Sangat Sulit Dibaca', color: 'text-red-400' };
	}
	// Blok reaktif yang memanggil fungsi kustom kita
	$: {
		if (typeof content === 'string') {
			const plainContent = content.replace(/<[^>]*>/g, ' ');

			if (plainContent.trim().length > 10) {
				readabilityScore = calculateFleschKincaid(plainContent);
				const interpretation = interpretFleschKincaid(readabilityScore);
				readabilityText = interpretation.text;
				readabilityColor = interpretation.color;
			}
            
            // Analisis SEO
            const seoResults: AnalysisResult[] = [];
            const keyword = focusKeyword.toLowerCase().trim();

            if (keyword) {
                seoResults.push({ text: 'Focus keyword di judul SEO', status: metaTitle.toLowerCase().includes(keyword) ? 'good' : 'bad' });
                seoResults.push({ text: 'Focus keyword di meta description', status: metaDescription.toLowerCase().includes(keyword) ? 'good' : 'bad' });
                seoResults.push({ text: 'Focus keyword di URL', status: slug.toLowerCase().includes(keyword.replace(/\s+/g, '-')) ? 'good' : 'bad' });
				seoResults.push({ text: 'Focus keyword di awal konten', status: plainContent.substring(0, Math.floor(plainContent.length * 0.1)).includes(keyword) ? 'good' : 'bad' });
            }
            seoResults.push({ text: 'Panjang meta description (120-160)', status: metaDescription.length >= 120 && metaDescription.length <= 160 ? 'good' : (metaDescription.length > 0 ? 'ok' : 'bad') });
            seoResults.push({ text: 'Panjang judul SEO (50-60)', status: metaTitle.length >= 50 && metaTitle.length <= 60 ? 'good' : (metaTitle.length > 0 ? 'ok' : 'bad') });
            analysisResults = seoResults;
		}
	}
	
	// Logika lain-lain
	$: categoryString = selectedCategories.map((c) => c.name).join(',');
	$: tagString = selectedTags.map((t) => t.name).join(',');
	
	function handleImageSelect(e: Event) {
		const input = e.target as HTMLInputElement;
		if (input.files && input.files[0]) {
			imagePreviewUrl = URL.createObjectURL(input.files[0]);
		}
	}
	$: availableCategories = allCategories.filter((ac) => !selectedCategories.find((sc) => sc.name === ac.name));
	function handleCategorySelect(event: Event) {
		const target = event.target as HTMLSelectElement;
		const selectedId = target.value;
		if (selectedId === 'CREATE_NEW') { isCreatingCategory = true; return; }
		const categoryToAdd = allCategories.find((c) => c.id === selectedId);
		if (categoryToAdd) selectedCategories = [...selectedCategories, categoryToAdd];
		target.value = '';
	}
	function handleAddCategory() {
		if (newCategoryName.trim()) {
			selectedCategories = [...selectedCategories, { id: newCategoryName.trim(), name: newCategoryName.trim() }];
			newCategoryName = '';
			isCreatingCategory = false;
		}
	}
	function removeCategory(name: string) {
		selectedCategories = selectedCategories.filter((c) => c.name !== name);
	}
	$: availableTags = allTags.filter((at) => !selectedTags.find((st) => st.name === at.name));
	function handleTagSelect(event: Event) {
		const target = event.target as HTMLSelectElement;
		const selectedId = target.value;
		if (selectedId === 'CREATE_NEW') { isCreatingTag = true; return; }
		const tagToAdd = allTags.find((t) => t.id === selectedId);
		if (tagToAdd) selectedTags = [...selectedTags, tagToAdd];
		target.value = '';
	}
	function handleAddTag() {
		if (newTagName.trim()) {
			selectedTags = [...selectedTags, { id: newTagName.trim(), name: newTagName.trim() }];
			newTagName = '';
			isCreatingTag = false;
		}
	}
	function removeTag(name: string) {
		selectedTags = selectedTags.filter((t) => t.name !== name);
	}
</script>

{#if notification}
	<div class="fixed top-5 right-5 z-50 flex items-center gap-4 rounded-lg p-4 {notification.type === 'success' ? 'bg-green-600/95' : 'bg-red-600/95'} border {notification.type === 'success' ? 'border-green-500' : 'border-red-500'} text-white shadow-lg backdrop-blur-sm">
		{#if notification.type === 'success'}<CheckCircle />{:else}<AlertTriangle />{/if}
		<p class="text-sm font-medium">{notification.message}</p>
		<button on:click={() => (notification = null)} class="ml-auto opacity-70 hover:opacity-100"><IconX size={18} /></button>
	</div>
{/if}

<form method="POST" enctype="multipart/form-data">
	<div class="mb-8 flex items-center justify-end gap-x-4">
		<a href="/admin" class="rounded-lg px-5 py-2 text-sm font-medium text-slate-400 transition-colors hover:text-slate-200">Kembali ke Dasbor</a>
		<button type="submit" class="rounded-lg bg-gradient-to-r from-blue-600 to-purple-600 px-8 py-2.5 text-sm font-semibold text-white shadow-lg shadow-blue-500/20 transition-transform hover:scale-105">
			Simpan Postingan
		</button>
	</div>

	<div class="grid grid-cols-1 gap-8 lg:grid-cols-3">
		<div class="flex flex-col gap-y-6 lg:col-span-2">
			<div class="rounded-lg border border-slate-800 bg-slate-800/50 p-6">
				<label for="title" class="mb-2 block text-sm font-medium text-slate-400">Judul</label>
				<input id="title" name="title" type="text" required bind:value={title} class="w-full rounded-lg border-slate-700 bg-slate-900 p-3 text-lg text-slate-200 focus:border-blue-500 focus:ring-2 focus:ring-blue-500/50" />
			</div>
			<div class="rounded-lg border border-slate-800 bg-slate-800/50 p-6">
				<label for="slug" class="mb-2 block text-sm font-medium text-slate-400">Slug</label>
				<input id="slug" name="slug" type="text" required bind:value={slug} class="w-full rounded-lg border-slate-700 bg-slate-900 p-3 text-slate-200 focus:border-blue-500 focus:ring-2 focus:ring-blue-500/50" />
			</div>
			<div class="rounded-lg border border-slate-800 bg-slate-800/50 p-2">
				<CustomEditor bind:value={content} />
			</div>
			<div class="rounded-lg border border-slate-800 bg-slate-900/50 p-6">
                <h3 class="mb-4 text-sm font-medium text-slate-400">Pratinjau di Google</h3>
                <div class="font-sans">
                    <p class="text-sm text-slate-200">
                        <span class="font-medium">situs-anda.com</span> › blog › {slug || '...'}
                    </p>
                    <h2 class="truncate text-xl text-blue-500 hover:underline">
                        {metaTitle || title || 'Judul Postingan Anda'}
                    </h2>
                    <p class="mt-1 text-sm text-slate-400">
                        {metaDescription || content.replace(/<[^>]*>/g, ' ').substring(0, 160) || 'Deskripsi akan muncul di sini...'}
                    </p>
                </div>
            </div>
		</div>

		<div class="flex flex-col gap-y-6 lg:col-span-1">
			<div class="rounded-lg border border-slate-800 bg-slate-800/50 p-6">
				<h3 class="mb-4 font-semibold text-slate-200">Publikasi</h3>
				<div class="flex items-center">
					<input id="published" name="published" type="checkbox" bind:checked={published} class="h-4 w-4 rounded border-slate-600 bg-slate-700 text-blue-600 focus:ring-blue-600" />
					<label for="published" class="ms-3 text-sm font-medium text-slate-300">Publikasikan</label>
				</div>
			</div>
			<div class="rounded-lg border border-slate-800 bg-slate-800/50 p-6">
				<h3 class="mb-4 font-semibold text-slate-200">Featured Image</h3>
				{#if imagePreviewUrl}
				<div class="mb-4">
					<!-- svelte-ignore a11y_img_redundant_alt -->
					<img src={imagePreviewUrl} alt="Pratinjau featured image" class="h-auto w-full rounded-lg object-cover" />
				</div>
				{/if}
				<input id="imageUrl" name="imageUrl" type="file" accept="image/*" on:change={handleImageSelect} class="block w-full text-sm text-slate-400 file:mr-4 file:rounded-full file:border-0 file:bg-blue-500/10 file:px-4 file:py-2 file:text-sm file:font-semibold file:text-blue-300 hover:file:bg-blue-500/20" />
				<div class="mt-4">
					<label for="imageAltText" class="mb-2 block text-xs font-medium text-slate-400">Alt Text</label>
					<input id="imageAltText" name="imageAltText" type="text" placeholder="Deskripsi singkat gambar..." class="w-full rounded-lg border-slate-700 bg-slate-900 p-2 text-xs text-slate-200 focus:border-blue-500" />
				</div>
			</div>
			<div class="rounded-lg border border-slate-800 bg-slate-800/50 p-6">
				<h3 class="mb-4 font-semibold text-slate-200">Kategori</h3>
				<div class="flex flex-wrap gap-2">
					{#each selectedCategories as category (category.name)}
						<span class="flex items-center gap-1 rounded-full bg-blue-500/20 px-3 py-1 text-sm font-medium text-blue-300">
							{category.name}
							<button type="button" on:click={() => removeCategory(category.name)} class="text-blue-200 hover:text-white"><IconX size={14} /></button>
						</span>
					{/each}
				</div>
				<div class="mt-4">
					{#if !isCreatingCategory}
						<select on:change={handleCategorySelect} class="w-full rounded-lg border-slate-700 bg-slate-900 p-2 text-sm text-slate-200 focus:border-blue-500 focus:ring-blue-500">
							<option value="" disabled selected>Pilih kategori...</option>
							{#each availableCategories as category}
								<option value={category.id}>{category.name}</option>
							{/each}
							<option value="CREATE_NEW" class="font-bold text-blue-400">-- Tambah Baru --</option>
						</select>
					{:else}
						<div class="flex gap-2">
							<input type="text" bind:value={newCategoryName} placeholder="Nama kategori baru..." class="w-full rounded-lg border-slate-700 bg-slate-900 p-2 text-sm text-slate-200" on:keydown={(e) => {if(e.key === 'Enter') { e.preventDefault(); handleAddCategory();}}} />
							<button type="button" on:click={handleAddCategory} class="rounded-lg bg-blue-600 px-3 py-1 text-sm">Add</button>
							<button type="button" on:click={() => isCreatingCategory = false} class="rounded-lg bg-slate-600 px-3 py-1 text-sm">X</button>
						</div>
					{/if}
				</div>
			</div>
			<div class="rounded-lg border border-slate-800 bg-slate-800/50 p-6">
				<h3 class="mb-4 font-semibold text-slate-200">Tag</h3>
				<div class="flex flex-wrap gap-2">
					{#each selectedTags as tag (tag.name)}
						<span class="flex items-center gap-1 rounded-full bg-purple-500/20 px-3 py-1 text-sm font-medium text-purple-300">
							{tag.name}
							<button type="button" on:click={() => removeTag(tag.name)} class="text-purple-200 hover:text-white"><IconX size={14} /></button>
						</span>
					{/each}
				</div>
				<div class="mt-4">
					{#if !isCreatingTag}
						<select on:change={handleTagSelect} class="w-full rounded-lg border-slate-700 bg-slate-900 p-2 text-sm text-slate-200 focus:border-purple-500 focus:ring-purple-500">
							<option value="" disabled selected>Pilih tag...</option>
							{#each availableTags as tag}
								<option value={tag.id}>{tag.name}</option>
							{/each}
							<option value="CREATE_NEW" class="font-bold text-purple-400">-- Tambah Baru --</option>
						</select>
					{:else}
						<div class="flex gap-2">
							<input type="text" bind:value={newTagName} placeholder="Nama tag baru..." class="w-full rounded-lg border-slate-700 bg-slate-900 p-2 text-sm text-slate-200" on:keydown={(e) => {if(e.key === 'Enter') { e.preventDefault(); handleAddTag(); }}} />
							<button type="button" on:click={handleAddTag} class="rounded-lg bg-purple-600 px-3 py-1 text-sm">Add</button>
							<button type="button" on:click={() => isCreatingTag = false} class="rounded-lg bg-slate-600 px-3 py-1 text-sm">X</button>
						</div>
					{/if}
				</div>
			</div>
			<div class="rounded-lg border border-slate-800 bg-slate-800/50 p-6">
				<h3 class="mb-4 font-semibold text-slate-200">Pengaturan SEO</h3>
				<div class="space-y-4">
					<div>
						<label for="focusKeyword" class="mb-2 block text-sm font-medium text-slate-400">Focus Keyword</label>
						<input id="focusKeyword" name="focusKeyword" type="text" bind:value={focusKeyword} class="w-full rounded-lg border-slate-700 bg-slate-900 p-3 text-sm" />
					</div>
					<div>
						<label for="metaTitle" class="mb-2 block text-sm font-medium text-slate-400">Meta Title</label>
						<input id="metaTitle" name="metaTitle" type="text" bind:value={metaTitle} class="w-full rounded-lg border-slate-700 bg-slate-900 p-3 text-sm" />
					</div>
					<div>
						<label for="metaDescription" class="mb-2 block text-sm font-medium text-slate-400">Meta Description</label>
						<textarea id="metaDescription" name="metaDescription" rows="4" bind:value={metaDescription} class="w-full rounded-lg border-slate-700 bg-slate-900 p-3 text-sm"></textarea>
					</div>
				</div>
				<div class="mt-6 border-t border-slate-700 pt-4">
					<h4 class="mb-2 font-semibold text-slate-300">Analisis SEO Dasar</h4>
					<ul class="space-y-2">
						{#each analysisResults as result}
							<li class="flex items-center gap-2 text-sm">
								{#if result.status === 'good'}
									<CheckCircle class="h-4 w-4 flex-shrink-0 text-green-400" />
									<span class="text-slate-300">{result.text}</span>
								{:else if result.status === 'bad'}
									<IconX class="h-4 w-4 flex-shrink-0 text-red-400" />
									<span class="text-slate-400">{result.text}</span>
								{:else}
									<AlertTriangle class="h-4 w-4 flex-shrink-0 text-yellow-400" />
									<span class="text-slate-400">{result.text}</span>
								{/if}
							</li>
						{/each}
					</ul>
				</div>
			</div>
			<div class="rounded-lg border border-slate-800 bg-slate-800/50 p-6">
				<h3 class="mb-4 font-semibold text-slate-200">Analisis Keterbacaan</h3>
				<div class="flex items-center justify-between">
					<span class="text-sm text-slate-400">Skor Flesch-Kincaid:</span>
					<span class="font-bold {readabilityColor}">{readabilityScore.toFixed(1)}</span>
				</div>
				<div class="mt-2 text-center text-sm font-medium {readabilityColor}">{readabilityText}</div>
				<div class="mt-4 text-xs text-slate-500">Skor lebih tinggi (mendekati 100) lebih mudah dipahami.</div>
			</div>

			<div class="rounded-lg border border-slate-800 bg-slate-800/50 p-6">
    <h3 class="mb-4 font-semibold text-slate-200">Pengaturan Lanjutan</h3>
    <div class="space-y-4">
        <div>
            <label for="canonicalUrl" class="mb-2 block text-sm font-medium text-slate-400">Canonical URL</label>
            <input id="canonicalUrl" name="canonicalUrl" type="text" bind:value={canonicalUrl} placeholder="Biarkan kosong untuk default" class="w-full rounded-lg border-slate-700 bg-slate-900 p-3 text-sm" />
        </div>
		<div>
    <label for="schemaType" class="mb-2 block text-sm font-medium text-slate-400">Tipe Schema</label>
    <select id="schemaType" name="schemaType" bind:value={schemaType} class="w-full rounded-lg border-slate-700 bg-slate-900 p-3 text-sm text-slate-200 focus:border-blue-500 focus:ring-blue-500">
        <option value="BlogPosting">Blog Posting (Default)</option>
        <option value="Article">Article</option>
        <option value="NewsArticle">News Article</option>
        <option value="FAQPage">FAQ Page</option>
    </select>
    <p class="mt-1 text-xs text-slate-500">Pilih tipe konten yang paling sesuai untuk schema JSON-LD.</p>
</div>
        <div class="space-y-2">
             <span class="block text-sm font-medium text-slate-400">Robots Meta</span>
             <label class="flex items-center gap-x-3 text-sm text-slate-300">
                <input type="checkbox" name="noIndex" bind:checked={noIndex} class="h-4 w-4 rounded border-slate-600 bg-slate-700 text-blue-600 focus:ring-blue-600" />
                <span>Halangi mesin pencari (noindex)</span>
            </label>
            <label class="flex items-center gap-x-3 text-sm text-slate-300">
                <input type="checkbox" name="noFollow" bind:checked={noFollow} class="h-4 w-4 rounded border-slate-600 bg-slate-700 text-blue-600 focus:ring-blue-600" />
                <span>Larang mesin pencari mengikuti link (nofollow)</span>
            </label>
        </div>
    </div>
</div>

<div class="rounded-lg border border-slate-800 bg-slate-800/50 p-6">
    <h3 class="mb-4 font-semibold text-slate-200">Pratinjau Social Media (Open Graph)</h3>
    <div class="space-y-4">
        <div>
            <label for="ogTitle" class="mb-2 block text-sm font-medium text-slate-400">OG Title</label>
            <input id="ogTitle" name="ogTitle" type="text" bind:value={ogTitle} placeholder="Gunakan Judul SEO jika kosong" class="w-full rounded-lg border-slate-700 bg-slate-900 p-3 text-sm" />
        </div>
        <div>
            <label for="ogDescription" class="mb-2 block text-sm font-medium text-slate-400">OG Description</label>
            <textarea id="ogDescription" name="ogDescription" rows="3" bind:value={ogDescription} placeholder="Gunakan Meta Description jika kosong" class="w-full rounded-lg border-slate-700 bg-slate-900 p-3 text-sm"></textarea>
        </div>
        <div>
             <label for="ogImage" class="mb-2 block text-sm font-medium text-slate-400">OG Image</label>
             <input id="ogImage" name="ogImage" type="file" accept="image/*" class="block w-full text-sm text-slate-400 file:mr-4 file:rounded-full file:border-0 file:bg-purple-500/10 file:px-4 file:py-2 file:text-sm file:font-semibold file:text-purple-300 hover:file:bg-purple-500/20" />
        </div>
    </div>
</div>

			{#if form?.error}
				<div class="rounded-lg border border-red-500/50 bg-red-500/20 p-3 text-sm text-red-300">{form.error}</div>
			{/if}
		</div>
	</div>

	<input type="hidden" name="content" value={content} />
	<input type="hidden" name="categories" value={categoryString} />
	<input type="hidden" name="tags" value={tagString} />
</form>