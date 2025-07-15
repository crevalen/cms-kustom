<script lang="ts">
	import { onMount, onDestroy } from 'svelte';
	import { Editor } from '@tiptap/core';
	import StarterKit from '@tiptap/starter-kit';
	import Link from '@tiptap/extension-link';
	import Image from '@tiptap/extension-image';
	import TextAlign from '@tiptap/extension-text-align';
	import Blockquote from '@tiptap/extension-blockquote';
	import HorizontalRule from '@tiptap/extension-horizontal-rule';
	import CodeBlock from '@tiptap/extension-code-block';
	import { BubbleMenu } from '@tiptap/extension-bubble-menu';
	import Youtube from '@tiptap/extension-youtube';

	import LinkEditorModal from './LinkEditorModal.svelte';

	import {
		Bold, Italic, Link2, Pilcrow, Heading2, Heading3, Heading4,
		AlignLeft, AlignCenter, AlignRight, AlignJustify, List,
		ListOrdered, Quote, Minus, Code, ImageIcon, Upload, X, Check, Youtube as YoutubeIcon
	} from 'lucide-svelte';

	export let value: string = '';

	let element: HTMLElement;
	let bubbleMenuElement: HTMLElement;
	let editor: Editor;

	// State untuk modal
	let showLinkModal = false;
	let showImageModal = false;
	let currentLinkAttrs = { href: '', target: '' };
	let imageFile: FileList;
	let imageAltText = '';
	let isUploading = false;

	onMount(() => {
		editor = new Editor({
			element: element,
			extensions: [
				StarterKit,
				Link.configure({ openOnClick: false, autolink: true, linkOnPaste: true }),
				Image,
				TextAlign.configure({ types: ['heading', 'paragraph'] }),
				Blockquote,
				HorizontalRule,
				CodeBlock,
				BubbleMenu.configure({
					element: bubbleMenuElement
				}),
				Youtube.configure({ // <-- Daftarkan dan konfigurasikan ekstensi YouTube
                    nocookie: true,
                })
			],
			content: value,
			onUpdate: () => {
				value = editor.getHTML();
			}
		});
	});

	onDestroy(() => {
		if (editor) editor.destroy();
	});

	// --- Fungsi-fungsi untuk Link ---
	function openLinkModal() {
		const { href, target } = editor.getAttributes('link');
		currentLinkAttrs = { href: href || '', target: target || '' };
		showLinkModal = true;
	}
	function handleSaveLink(event: CustomEvent<{ href: string; target: string }>) {
		const { href, target } = event.detail;
		if (href) {
			editor.chain().focus().extendMarkRange('link').setLink({ href, target }).run();
		}
		showLinkModal = false;
	}
	function handleRemoveLink() {
		editor.chain().focus().extendMarkRange('link').unsetLink().run();
		showLinkModal = false;
	}

	// --- Fungsi-fungsi untuk Gambar ---
	async function handleUploadAndInsert() {
		const file = imageFile?.[0];
		if (!file) return alert('Silakan pilih file gambar.');
		isUploading = true;
		const formData = new FormData();
		formData.append('image', file);
		formData.append('altText', imageAltText);
		try {
			const response = await fetch('/api/media/upload', { method: 'POST', body: formData });
			if (!response.ok) throw new Error('Upload gagal');
			const newImage = await response.json();
			editor.chain().focus().setImage({ src: newImage.url, alt: newImage.altText }).run();
			showImageModal = false;
			imageAltText = '';
		} catch (error) {
			alert('Terjadi kesalahan saat mengunggah gambar.');
		} finally {
			isUploading = false;
		}
	}
function addYoutubeVideo() {
		const url = prompt('Masukkan URL video YouTube:');

		if (url) {
			editor.chain().focus().setYoutubeVideo({ src: url }).run();
		}
	}
</script>

{#if showLinkModal}
	<LinkEditorModal
		href={currentLinkAttrs.href}
		target={currentLinkAttrs.target}
		on:close={() => (showLinkModal = false)}
		on:save={handleSaveLink}
		on:remove={handleRemoveLink}
	/>
{/if}

{#if showImageModal}
	<!-- svelte-ignore a11y_interactive_supports_focus -->
	<!-- svelte-ignore a11y_click_events_have_key_events -->
	<div role="dialog" aria-modal="true" class="fixed inset-0 z-50 flex items-center justify-center bg-black/70 backdrop-blur-sm" on:click={() => showImageModal = false}>
		<!-- svelte-ignore a11y_no_noninteractive_element_interactions -->
		<div role="document" class="w-full max-w-lg rounded-xl border border-slate-700 bg-slate-800 p-6 shadow-2xl" on:click|stopPropagation>
			<div class="mb-4 flex items-center justify-between">
				<h3 class="text-lg font-semibold text-white">Sisipkan Gambar</h3>
				<button on:click={() => showImageModal = false} class="text-slate-400 hover:text-white"><X size={20} /></button>
			</div>
			<div class="space-y-4">
				<div>
					<label for="modal-image-upload" class="mb-2 block text-sm font-medium text-slate-400">File Gambar</label>
					<input id="modal-image-upload" bind:files={imageFile} type="file" accept="image/*" class="block w-full text-sm text-slate-400 file:mr-4 file:rounded-full file:border-0 file:bg-blue-500/10 file:px-4 file:py-2 file:text-sm file:font-semibold file:text-blue-300 hover:file:bg-blue-500/20" />
				</div>
				<div>
					<label for="modal-alt-text" class="mb-2 block text-sm font-medium text-slate-400">Alt Text (Deskripsi Gambar)</label>
					<input id="modal-alt-text" bind:value={imageAltText} type="text" placeholder="Deskripsi singkat gambar..." class="w-full rounded-lg border-slate-700 bg-slate-900 p-3 text-sm text-slate-200" />
				</div>
				<div class="mt-4 flex justify-end gap-3 border-t border-slate-700 pt-4">
					<button type="button" on:click={() => showImageModal = false} class="rounded-lg px-4 py-2 text-sm font-medium text-slate-300 hover:bg-slate-700">Batal</button>
					<button type="button" on:click={handleUploadAndInsert} disabled={isUploading} class="inline-flex items-center gap-2 rounded-lg bg-blue-600 px-4 py-2 text-sm font-semibold text-white hover:bg-blue-500 disabled:opacity-50">
						{#if isUploading}
							<div class="h-4 w-4 animate-spin rounded-full border-2 border-white/50 border-t-white"></div> Memproses...
						{:else}
							<Upload size={16}/> Unggah & Sisipkan
						{/if}
					</button>
				</div>
			</div>
		</div>
	</div>
{/if}

<div bind:this={bubbleMenuElement}>
	{#if editor && editor.isActive('link')}
		<div class="flex items-center gap-2 rounded-lg border border-slate-700 bg-slate-900 p-2 shadow-xl">
			<a href={editor.getAttributes('link').href} target="_blank" rel="noopener noreferrer" class="text-sm text-blue-400 hover:underline">
				Buka Link
			</a>
			<div class="h-4 w-px bg-slate-700"></div>
			<button on:click={openLinkModal} class="text-sm text-slate-300 hover:text-white">Edit</button>
		</div>
	{/if}
</div>


<div class="rounded-lg border border-slate-700 bg-slate-900">
	{#if editor}
		<div class="flex flex-wrap items-center gap-1 border-b border-slate-700 p-2">
			<div class="flex items-center gap-1">
				<button type="button" on:click={() => editor.chain().focus().toggleBold().run()} class:is-active={editor.isActive('bold')}><Bold size={18} /></button>
				<button type="button" on:click={() => editor.chain().focus().toggleItalic().run()} class:is-active={editor.isActive('italic')}><Italic size={18} /></button>
			</div>
			<div class="divider"></div>
			<div class="flex items-center gap-1">
				<button type="button" on:click={() => editor.chain().focus().toggleHeading({ level: 2 }).run()} class:is-active={editor.isActive('heading', { level: 2 })}><Heading2 size={18} /></button>
				<button type="button" on:click={() => editor.chain().focus().toggleHeading({ level: 3 }).run()} class:is-active={editor.isActive('heading', { level: 3 })}><Heading3 size={18} /></button>
				<button type="button" on:click={() => editor.chain().focus().toggleHeading({ level: 4 }).run()} class:is-active={editor.isActive('heading', { level: 4 })}><Heading4 size={18} /></button>
			</div>
			<div class="divider"></div>
			<div class="flex items-center gap-1">
				<button type="button" on:click={() => editor.chain().focus().setParagraph().run()} class:is-active={editor.isActive('paragraph')}><Pilcrow size={18} /></button>
				<button type="button" on:click={() => editor.chain().focus().toggleBlockquote().run()} class:is-active={editor.isActive('blockquote')}><Quote size={18} /></button>
			</div>
			<div class="divider"></div>
			<div class="flex items-center gap-1">
				<button type="button" on:click={() => editor.chain().focus().toggleBulletList().run()} class:is-active={editor.isActive('bulletList')}><List size={18} /></button>
				<button type="button" on:click={() => editor.chain().focus().toggleOrderedList().run()} class:is-active={editor.isActive('orderedList')}><ListOrdered size={18} /></button>
			</div>
			<div class="divider"></div>
			<div class="flex items-center gap-1">
				<button type="button" on:click={() => editor.chain().focus().setTextAlign('left').run()} class:is-active={editor.isActive({ textAlign: 'left' })}><AlignLeft size={18} /></button>
				<button type="button" on:click={() => editor.chain().focus().setTextAlign('center').run()} class:is-active={editor.isActive({ textAlign: 'center' })}><AlignCenter size={18} /></button>
				<button type="button" on:click={() => editor.chain().focus().setTextAlign('right').run()} class:is-active={editor.isActive({ textAlign: 'right' })}><AlignRight size={18} /></button>
				<button type="button" on:click={() => editor.chain().focus().setTextAlign('justify').run()} class:is-active={editor.isActive({ textAlign: 'justify' })}><AlignJustify size={18} /></button>
			</div>
			<div class="divider"></div>
			<div class="flex items-center gap-1">
				<button type="button" on:click={openLinkModal} class:is-active={editor.isActive('link')}><Link2 size={18} /></button>
				<button type="button" on:click={() => showImageModal = true}><ImageIcon size={18} /></button>
				<button type="button" on:click={() => editor.chain().focus().setHorizontalRule().run()}><Minus size={18} /></button>
				<button type="button" on:click={() => editor.chain().focus().toggleCodeBlock().run()} class:is-active={editor.isActive('codeBlock')}><Code size={18} /></button>
			</div>
		</div>
	{/if}
	<div bind:this={element} class="editor-content"></div>
</div>

<style>

	/* Styling baru untuk iframe agar responsif */
	.editor-content :global(iframe) {
		width: 100%;
		aspect-ratio: 16 / 9;
		border-radius: 0.5rem;
		border: none;
	}
	.editor-content :global(.ProseMirror) {
		min-height: 400px;
		padding: 0.75rem;
		color: hsl(215 20.2% 65.1%);
		transition: all 0.2s;
	}
	.editor-content :global(.ProseMirror:focus) {
		outline: none;
	}
	/* Styling untuk elemen-elemen di dalam editor */
	.editor-content :global(.ProseMirror > * + *) { margin-top: 0.75em; }
	.editor-content :global(.ProseMirror h2) { font-size: 1.5em; font-weight: 700; color: hsl(210 40% 98%); }
	.editor-content :global(.ProseMirror h3) { font-size: 1.25em; font-weight: 700; color: hsl(210 40% 98%); }
	.editor-content :global(.ProseMirror h4) { font-size: 1.125em; font-weight: 700; color: hsl(210 40% 98%); }
    .editor-content :global(.ProseMirror blockquote) { padding-left: 1rem; border-left: 3px solid hsl(217.2 32.6% 30%); color: hsl(215 20.2% 80%); }
    .editor-content :global(.ProseMirror code) { background-color: hsl(222.2 47.4% 15%); color: hsl(210 40% 98%); padding: 0.2rem 0.4rem; border-radius: 0.25rem; }
    .editor-content :global(.ProseMirror pre) { background: hsl(222.2 47.4% 10%); color: hsl(210 40% 98%); font-family: 'JetBrains Mono', monospace; padding: 0.75rem 1rem; border-radius: 0.5rem; }
	.editor-content :global(.ProseMirror ul), .editor-content :global(.ProseMirror ol) { padding-left: 1.75rem; }
	.editor-content :global(.ProseMirror ul) { list-style-type: disc; }
	.editor-content :global(.ProseMirror ol) { list-style-type: decimal; }
	
	/* Styling untuk toolbar */
	button { padding: 0.375rem; border-radius: 0.25rem; color: hsl(215 20.2% 65.1%); transition: all 150ms; min-width: 34px; }
	button:hover { background-color: hsl(222.2 47.4% 15%); color: hsl(210 40% 98%); }
	.is-active { background-color: hsl(222.2 47.4% 25%); color: hsl(210 40% 98%); }
	.divider { width: 1px; height: 1.25rem; background-color: hsl(217.2 32.6% 25%); margin-left: 0.25rem; margin-right: 0.25rem; }
</style>