<script lang="ts">
	import type { PageData, ActionData } from './$types';
	import { enhance } from '$app/forms';
	import { CheckCircle, AlertTriangle } from 'lucide-svelte';

	export let data: PageData;
	export let form: ActionData;

	let notification: { type: 'success' | 'error'; message: string } | null = null;
	$: if (form?.message) {
		notification = {
			type: form.success ? 'success' : 'error',
			message: form.message ?? 'Terjadi kesalahan'
		};
		const timer = setTimeout(() => {
			notification = null;
		}, 4000);
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

<div class="w-full">
	<form method="POST" use:enhance enctype="multipart/form-data">
		<div class="mb-8 flex items-center justify-between">
			<div>
				<h1 class="text-2xl font-bold text-slate-100 sm:text-3xl">Pengaturan Umum</h1>
				<p class="mt-1 text-sm text-slate-400">Atur identitas situs, kode verifikasi, dan skrip kustom.</p>
			</div>
			<button
				type="submit"
				class="rounded-lg bg-gradient-to-r from-blue-600 to-purple-600 px-8 py-2.5 text-sm font-semibold text-white shadow-lg transition-transform hover:scale-105"
			>
				Simpan Semua
			</button>
		</div>

		{#if form && !form.success && form.message}
			<div class="mb-6 rounded-md bg-red-500/20 p-3 text-sm text-red-300">
				{form.message}
			</div>
		{/if}

		<div class="flex flex-col gap-y-6">
			<div class="rounded-lg border border-slate-800 bg-slate-800/50 p-6">
				<h3 class="mb-4 text-lg font-semibold text-white">Identitas Situs</h3>
				<div class="grid grid-cols-1 gap-6 md:grid-cols-2">
					<div>
						<label for="site_logo_url" class="mb-2 block text-sm font-medium text-slate-300"
							>Logo Situs</label
						>
						{#if data.settings.site_logo_url}
							<img
								src={data.settings.site_logo_url}
								alt="Logo saat ini"
								class="mb-2 h-12 w-auto rounded-md bg-white/10 p-1"
							/>
						{/if}
						<input id="site_logo_url" name="site_logo_url" type="file" class="input-file" />
					</div>
					<div>
						<label for="site_favicon_url" class="mb-2 block text-sm font-medium text-slate-300"
							>Favicon</label
						>
						{#if data.settings.site_favicon_url}
							<img
								src={data.settings.site_favicon_url}
								alt="Favicon saat ini"
								class="mb-2 h-12 w-12 rounded-md bg-white/10 p-1"
							/>
						{/if}
						<input id="site_favicon_url" name="site_favicon_url" type="file" class="input-file" />
					</div>
					<div class="md:col-span-2">
						<label for="publisher_logo_url" class="mb-2 block text-sm font-medium text-slate-300"
							>Logo Publisher (Untuk SEO)</label
						>
						{#if data.settings.publisher_logo_url}
							<img
								src={data.settings.publisher_logo_url}
								alt="Logo Publisher saat ini"
								class="mb-2 h-12 w-auto rounded-md bg-white/10 p-1"
							/>
						{/if}
						<input id="publisher_logo_url" name="publisher_logo_url" type="file" class="input-file" />
						<p class="mt-1 text-xs text-slate-500">
							Logo yang akan muncul di hasil pencarian Google. Min. 112x112px.
						</p>
					</div>
				</div>
			</div>

			<div class="rounded-lg border border-slate-800 bg-slate-800/50 p-6">
				<h3 class="mb-4 text-lg font-semibold text-white">Verifikasi Webmaster</h3>
				<div class="space-y-4">
					<div>
						<label for="gsc_verification_code" class="mb-2 block text-sm font-medium text-slate-300"
							>Google Search Console</label
						>
						<input
							name="gsc_verification_code"
							value={data.settings.gsc_verification_code ?? ''}
							placeholder="Kode verifikasi Google..."
							class="input-text"
						/>
					</div>
					<div>
						<label for="bing_verification_code" class="mb-2 block text-sm font-medium text-slate-300"
							>Bing Webmaster Tools</label
						>
						<input
							name="bing_verification_code"
							value={data.settings.bing_verification_code ?? ''}
							placeholder="Kode verifikasi Bing..."
							class="input-text"
						/>
					</div>
					<div>
						<label for="yandex_verification_code" class="mb-2 block text-sm font-medium text-slate-300"
							>Yandex Webmaster</label
						>
						<input
							name="yandex_verification_code"
							value={data.settings.yandex_verification_code ?? ''}
							placeholder="Kode verifikasi Yandex..."
							class="input-text"
						/>
					</div>
				</div>
			</div>

			<div class="rounded-lg border border-slate-800 bg-slate-800/50 p-6">
				<h3 class="mb-4 text-lg font-semibold text-white">Skrip & Analitik</h3>
				<div class="space-y-4">
					<div>
						<label for="ga4_id" class="mb-2 block text-sm font-medium text-slate-300"
							>Google Analytics 4 ID</label
						>
						<input
							name="ga4_id"
							value={data.settings.ga4_id ?? ''}
							placeholder="G-XXXXXXXXXX"
							class="input-text"
						/>
					</div>
					<div>
						<label for="custom_head_script" class="mb-2 block text-sm font-medium text-slate-300"
							>Kode Kustom di &lt;head&gt;</label
						>
						<textarea
							name="custom_head_script"
							rows="4"
							placeholder="<script>...</script> atau <style>...</style>"
							class="input-textarea"
						>{data.settings.custom_head_script ?? ''}</textarea>
					</div>
					<div>
						<label for="custom_footer_script" class="mb-2 block text-sm font-medium text-slate-300"
							>Kode Kustom sebelum &lt;/body&gt;</label
						>
						<textarea
							name="custom_footer_script"
							rows="4"
							placeholder="<script>...</script>"
							class="input-textarea"
						>{data.settings.custom_footer_script ?? ''}</textarea>
					</div>
				</div>
			</div>
		</div>
	</form>
</div>

<style>
	.input-text,
	.input-textarea {
		width: 100%;
		border-radius: 0.5rem;
		border-width: 1px;
		border-color: hsl(217.2 32.6% 17.5%);
		background-color: hsl(222.2 47.4% 11.2%);
		padding: 0.75rem;
		font-size: 0.875rem;
		line-height: 1.25rem;
		color: hsl(210 40% 98%);
	}
	.input-textarea {
		font-family: monospace;
	}
	.input-text:focus,
	.input-textarea:focus {
		border-color: hsl(221.2 83.2% 53.3%);
		--tw-ring-color: hsl(221.2 83.2% 53.3%);
		box-shadow: var(--tw-ring-inset) 0 0 0 calc(1px + var(--tw-ring-offset-width))
			var(--tw-ring-color);
	}
	.input-file {
		display: block;
		width: 100%;
		font-size: 0.875rem;
		line-height: 1.25rem;
		color: hsl(215 20.2% 65.1%);
	}
	.input-file::file-selector-button {
		margin-right: 1rem;
		border-radius: 9999px;
		border-width: 0px;
		background-color: hsl(222.2 47.4% 20%);
		padding: 0.5rem 1rem;
		font-size: 0.875rem;
		line-height: 1.25rem;
		font-weight: 600;
		color: hsl(210 40% 98%);
	}
	.input-file::file-selector-button:hover {
		background-color: hsl(222.2 47.4% 25%);
	}
</style>