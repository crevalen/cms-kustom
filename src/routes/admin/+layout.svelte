<script lang="ts">
	import { page } from '$app/stores';
	import { LayoutDashboard, Newspaper, Tags, Image, Users, Settings, Bot, FileText, MessageSquare } from 'lucide-svelte';

	const navLinks = [
		{ href: '/admin', label: 'Dasbor', icon: LayoutDashboard },
		{ href: '/admin/posts', label: 'Postingan', icon: Newspaper },
		{ href: '/admin/pages', label: 'Halaman', icon: FileText },
		{ href: '/admin/comments', label: 'Komentar', icon: MessageSquare },
		{ href: '/admin/taxonomies', label: 'Kategori & Tag', icon: Tags },
		{ href: '/admin/users', label: 'Pengguna', icon: Users },
		{ href: '/admin/media', label: 'Media', icon: Image },
		{ href: '/admin/settings/seo', label: 'Pengaturan SEO', icon: Settings },
		{ href: '/admin/settings/robots', label: 'Robots.txt', icon: Bot }
	];
</script>

<div class="flex min-h-screen bg-slate-900 text-slate-300">
	<aside class="sticky top-0 h-screen w-64 flex-shrink-0 border-r border-slate-800 bg-slate-900 p-4">
		<div class="mb-8 text-center">
			<a href="/admin" class="text-2xl font-bold text-white">
				My<span class="text-transparent bg-clip-text bg-gradient-to-r from-blue-400 to-purple-500">CMS</span>
			</a>
		</div>
		<nav class="flex flex-col gap-2">
			{#each navLinks as link}
				{@const isActive = $page.url.pathname === link.href || ($page.url.pathname.startsWith(link.href) && link.href !== '/admin')}
				<a
					href={link.href}
					class="flex items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium transition-colors {isActive
						? 'bg-blue-500/10 text-white'
						: 'hover:bg-slate-800'}"
				>
					<svelte:component this={link.icon} size={18} />
					<span>{link.label}</span>
				</a>
			{/each}
		</nav>
	</aside>

	<div class="flex-grow p-4 sm:p-6 lg:p-8">
		<slot />
	</div>
</div>