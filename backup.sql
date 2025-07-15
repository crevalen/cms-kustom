--
-- PostgreSQL database dump
--

-- Dumped from database version 16.9 (Debian 16.9-1.pgdg120+1)
-- Dumped by pg_dump version 16.9 (Debian 16.9-1.pgdg120+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: Role; Type: TYPE; Schema: public; Owner: user_dev
--

CREATE TYPE public."Role" AS ENUM (
    'ADMIN',
    'EDITOR',
    'AUTHOR'
);


ALTER TYPE public."Role" OWNER TO user_dev;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Category; Type: TABLE; Schema: public; Owner: user_dev
--

CREATE TABLE public."Category" (
    id text NOT NULL,
    slug text NOT NULL,
    name text NOT NULL,
    "updatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."Category" OWNER TO user_dev;

--
-- Name: Comment; Type: TABLE; Schema: public; Owner: user_dev
--

CREATE TABLE public."Comment" (
    id text NOT NULL,
    content text NOT NULL,
    "authorName" text NOT NULL,
    "authorEmail" text NOT NULL,
    "isApproved" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "postId" text NOT NULL,
    "parentId" text
);


ALTER TABLE public."Comment" OWNER TO user_dev;

--
-- Name: Media; Type: TABLE; Schema: public; Owner: user_dev
--

CREATE TABLE public."Media" (
    id text NOT NULL,
    key text NOT NULL,
    url text NOT NULL,
    "altText" text,
    "fileType" text NOT NULL,
    size integer NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."Media" OWNER TO user_dev;

--
-- Name: Page; Type: TABLE; Schema: public; Owner: user_dev
--

CREATE TABLE public."Page" (
    id text NOT NULL,
    slug text NOT NULL,
    title text NOT NULL,
    content text NOT NULL,
    published boolean DEFAULT false NOT NULL,
    "metaTitle" text,
    "metaDescription" text,
    "schemaType" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Page" OWNER TO user_dev;

--
-- Name: Post; Type: TABLE; Schema: public; Owner: user_dev
--

CREATE TABLE public."Post" (
    id text NOT NULL,
    slug text NOT NULL,
    title text NOT NULL,
    content text NOT NULL,
    published boolean DEFAULT false NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "authorId" text NOT NULL,
    "metaDescription" text,
    "metaTitle" text,
    "featuredImageId" text,
    "focusKeyword" text,
    "canonicalUrl" text,
    "noFollow" boolean DEFAULT false NOT NULL,
    "noIndex" boolean DEFAULT false NOT NULL,
    "ogDescription" text,
    "ogImageId" text,
    "ogTitle" text,
    "schemaType" text,
    "publishedAt" timestamp(3) without time zone
);


ALTER TABLE public."Post" OWNER TO user_dev;

--
-- Name: Session; Type: TABLE; Schema: public; Owner: user_dev
--

CREATE TABLE public."Session" (
    id text NOT NULL,
    "expiresAt" timestamp(3) without time zone NOT NULL,
    "userId" text NOT NULL
);


ALTER TABLE public."Session" OWNER TO user_dev;

--
-- Name: Setting; Type: TABLE; Schema: public; Owner: user_dev
--

CREATE TABLE public."Setting" (
    key text NOT NULL,
    value text NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Setting" OWNER TO user_dev;

--
-- Name: Tag; Type: TABLE; Schema: public; Owner: user_dev
--

CREATE TABLE public."Tag" (
    id text NOT NULL,
    slug text NOT NULL,
    name text NOT NULL,
    "updatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."Tag" OWNER TO user_dev;

--
-- Name: User; Type: TABLE; Schema: public; Owner: user_dev
--

CREATE TABLE public."User" (
    id text NOT NULL,
    username text NOT NULL,
    "passwordHash" text NOT NULL,
    role public."Role" DEFAULT 'AUTHOR'::public."Role" NOT NULL
);


ALTER TABLE public."User" OWNER TO user_dev;

--
-- Name: _CategoryToPost; Type: TABLE; Schema: public; Owner: user_dev
--

CREATE TABLE public."_CategoryToPost" (
    "A" text NOT NULL,
    "B" text NOT NULL
);


ALTER TABLE public."_CategoryToPost" OWNER TO user_dev;

--
-- Name: _PostToTag; Type: TABLE; Schema: public; Owner: user_dev
--

CREATE TABLE public."_PostToTag" (
    "A" text NOT NULL,
    "B" text NOT NULL
);


ALTER TABLE public."_PostToTag" OWNER TO user_dev;

--
-- Data for Name: Category; Type: TABLE DATA; Schema: public; Owner: user_dev
--

COPY public."Category" (id, slug, name, "updatedAt") FROM stdin;
cmcs4orvv0000uli0hmfge9q2	tips	Tips	2025-07-07 12:19:21.27
cmcsaivpf0000ulloavrwsvsz	testing	Testing	2025-07-07 12:19:21.27
cmcsc3b4m0002ullojg863on0	tes-2	Tes 2	2025-07-07 12:19:21.27
cmct4dnk60000ulds1m9r7kht	testing-3	Testing 3	2025-07-07 13:11:12.742
cmd38j5qy0005ulfogkav1p6v	investasi	Investasi	2025-07-14 15:05:09.85
cmd38jb4i0006ulfoufh5attb	kripto	Kripto	2025-07-14 15:05:16.819
cmd38jews0007ulfoq1n85akb	story	Story	2025-07-14 15:05:21.724
\.


--
-- Data for Name: Comment; Type: TABLE DATA; Schema: public; Owner: user_dev
--

COPY public."Comment" (id, content, "authorName", "authorEmail", "isApproved", "createdAt", "postId", "parentId") FROM stdin;
\.


--
-- Data for Name: Media; Type: TABLE DATA; Schema: public; Owner: user_dev
--

COPY public."Media" (id, key, url, "altText", "fileType", size, "createdAt") FROM stdin;
cmcs76kd20000ul1o09kij4mt	1751838112343-Cara-Investasi-Emas.webp	https://pub-1ee64496e6a94c8c9eaac0bbf8f2d2d2.r2.dev/1751838112343-Cara-Investasi-Emas.webp	Cara-Investasi-Emas	image/webp	76680	2025-07-06 21:41:54.678
cmcs77qto0001ul1od5uduhqt	1751838169456-best-copy-trading-platforms-750x536.jpg (1).webp	https://pub-1ee64496e6a94c8c9eaac0bbf8f2d2d2.r2.dev/1751838169456-best-copy-trading-platforms-750x536.jpg (1).webp	best-copy-trading-platforms-750x536.jpg (1)	image/webp	46674	2025-07-06 21:42:49.74
cmcs78ax60002ul1onqnw4msa	1751838195430-open-banking-750x536.jpeg (2).webp	https://pub-1ee64496e6a94c8c9eaac0bbf8f2d2d2.r2.dev/1751838195430-open-banking-750x536.jpeg (2).webp	open-banking-750x536.jpeg (2)	image/webp	21988	2025-07-06 21:43:15.786
cmcs78kjq0003ul1oer81r2xj	1751838207898-Gemini_Generated_Image_ywcmpxywcmpxywcm-750x536.png.webp	https://pub-1ee64496e6a94c8c9eaac0bbf8f2d2d2.r2.dev/1751838207898-Gemini_Generated_Image_ywcmpxywcmpxywcm-750x536.png.webp	Gemini_Generated_Image_ywcmpxywcmpxywcm-750x536.png	image/webp	48056	2025-07-06 21:43:28.262
cmcs78smy0004ul1oywvx55av	1751838218489-obligasi-750x536.jpg (1).webp	https://pub-1ee64496e6a94c8c9eaac0bbf8f2d2d2.r2.dev/1751838218489-obligasi-750x536.jpg (1).webp	obligasi-750x536.jpg (1)	image/webp	34446	2025-07-06 21:43:38.746
cmcs78z9t0005ul1o4rswp68f	1751838227040-Cryptocurrency_logos-750x536.jpg.webp	https://pub-1ee64496e6a94c8c9eaac0bbf8f2d2d2.r2.dev/1751838227040-Cryptocurrency_logos-750x536.jpg.webp	Cryptocurrency_logos-750x536.jpg	image/webp	38200	2025-07-06 21:43:47.345
cmcs7980y0006ul1o62iemd9y	1751838238331-Blog_rupiah_digital-1-750x536.jpg.webp	https://pub-1ee64496e6a94c8c9eaac0bbf8f2d2d2.r2.dev/1751838238331-Blog_rupiah_digital-1-750x536.jpg.webp	Blog_rupiah_digital-1-750x536.jpg	image/webp	17508	2025-07-06 21:43:58.69
cmcs7b13t0007ul1o4m849b01	1751838322595-best-copy-trading-platforms-750x536.jpg (1).webp	https://pub-1ee64496e6a94c8c9eaac0bbf8f2d2d2.r2.dev/1751838322595-best-copy-trading-platforms-750x536.jpg (1).webp	best-copy-trading-platforms-750x536.jpg (1)	image/webp	46674	2025-07-06 21:45:23.034
cmcs7bqjp0008ul1oemvv8p7y	1751838355704-How-to-Write-a-Blog-Post.webp	https://pub-1ee64496e6a94c8c9eaac0bbf8f2d2d2.r2.dev/1751838355704-How-to-Write-a-Blog-Post.webp	How-to-Write-a-Blog-Post	image/webp	21458	2025-07-06 21:45:56.006
cmd38q0s60008ulfon1izy3bz	1752505815409-1_H8EEZ6r_y2u1HgtKNaMKfQ.webp	https://pub-1ee64496e6a94c8c9eaac0bbf8f2d2d2.r2.dev/1752505815409-1_H8EEZ6r_y2u1HgtKNaMKfQ.webp	zero sum game	image/webp	21758	2025-07-14 15:10:30.003
cmd4o4y7c0000ulagdd90t8we	1752592185259-5908a22c-eed1-47f2-b271-99387ac7df2b (1).webp	https://pub-1ee64496e6a94c8c9eaac0bbf8f2d2d2.r2.dev/1752592185259-5908a22c-eed1-47f2-b271-99387ac7df2b (1).webp	Freelancer	image/webp	48056	2025-07-15 15:09:46.866
\.


--
-- Data for Name: Page; Type: TABLE DATA; Schema: public; Owner: user_dev
--

COPY public."Page" (id, slug, title, content, published, "metaTitle", "metaDescription", "schemaType", "createdAt", "updatedAt") FROM stdin;
cmd382qzh0000ulfokv5zjrrw	tentang	Tentang Kami	<p class="ai-optimize-7 ai-optimize-introduction">Selamat datang di Crevalen, platform edukasi finansial yang hadir untuk membimbing Anda memahami dunia keuangan dan investasi secara cerdas dan realistis.</p>\r\n<p class="ai-optimize-8">Kami percaya bahwa setiap orang berhak mendapatkan akses terhadap pengetahuan finansial yang praktis, aplikatif, dan bebas dari jargon rumit. Melalui Crevalen, kami menyajikan konten berkualitas seputar investasi, trading, pengelolaan uang, serta strategi membangun aset sejak dini.</p>\r\n<h2 class="ai-optimize-9">&nbsp;</h2>\r\n<h2 class="ai-optimize-9"><strong>Siapa Kami?</strong></h2>\r\n<p class="ai-optimize-10">Crevalen dikelola oleh tim penulis, analis, dan praktisi keuangan independen yang telah berkecimpung dalam dunia digital dan finansial lebih dari 5 tahun. Kami menulis berdasarkan pengalaman, riset, dan wawasan praktis bukan sekadar teori.</p>\r\n<p class="ai-optimize-11">Kami bukan penasihat keuangan bersertifikat, tapi kami tahu betul bagaimana membuat informasi finansial menjadi mudah dipahami dan relevan untuk kehidupan sehari-hari.</p>\r\n<h2 class="ai-optimize-12">&nbsp;</h2>\r\n<h2 class="ai-optimize-12"><strong>Misi Kami</strong></h2>\r\n<p class="ai-optimize-13">Misi kami sederhana: Membantu Anda membuat keputusan finansial yang lebih cerdas, satu artikel dalam satu waktu.</p>\r\n<p class="ai-optimize-14">Kami ingin menjadi teman belajar finansial yang jujur, logis, dan tidak menjual janji instan.</p>\r\n<h2 class="ai-optimize-15">&nbsp;</h2>\r\n<h2 class="ai-optimize-15"><strong>Mengapa Crevalen?</strong></h2>\r\n<p class="ai-optimize-16">Nama Crevalen berasal dari gabungan kata &ldquo;creative&rdquo; dan &ldquo;value elevation&rdquo; mencerminkan semangat kami untuk terus menciptakan konten bernilai dan berdampak.</p>\r\n<p>&nbsp;</p>\r\n<p class="ai-optimize-17">Terima kasih telah menjadi bagian dari perjalanan ini.<br>Silakan jelajahi artikel kami, dan semoga setiap informasi yang Anda temukan di sini menjadi langkah awal menuju kehidupan finansial yang lebih terarah.</p>\r\n<p class="ai-optimize-18">Salam hangat,<br><strong>Tim Crevalen</strong></p>	t	Tentang Kami	Selamat datang di Crevalen, platform edukasi finansial yang hadir untuk membimbing Anda memahami dunia keuangan dan investasi secara cerdas dan realistis.	AboutPage	2025-07-14 14:52:24.203	2025-07-14 14:52:24.203
cmd387jpb0001ulfo92i1zjye	kebijakan-privasi	Kebijakan Privasi	<p class="ai-optimize-7 ai-optimize-introduction">Privasi Anda sangat penting bagi kami. Di Crevalen, kami berkomitmen untuk melindungi informasi pribadi pengunjung dengan sebaik-baiknya. Halaman ini menjelaskan jenis informasi apa saja yang kami kumpulkan dan bagaimana kami menggunakannya.</p>\r\n<h2 class="ai-optimize-8"><strong>Informasi yang Kami Kumpulkan</strong></h2>\r\n<p class="ai-optimize-28">Kami dapat mengumpulkan informasi berikut ketika Anda mengakses situs ini:</p>\r\n<ul>\r\n<li class="ai-optimize-10">Informasi pribadi, seperti nama dan email, jika Anda menghubungi kami secara langsung atau berlangganan newsletter.</li>\r\n<li class="ai-optimize-10">Data penggunaan, termasuk alamat IP, jenis browser, waktu akses, dan halaman yang dikunjungi.</li>\r\n<li class="ai-optimize-10">Cookies, untuk menyimpan preferensi pengguna dan membantu meningkatkan pengalaman browsing Anda.</li>\r\n</ul>\r\n<h2 class="ai-optimize-11"><strong>Penggunaan Informasi</strong></h2>\r\n<p class="ai-optimize-12">Informasi yang dikumpulkan dapat digunakan untuk:</p>\r\n<ul>\r\n<li class="ai-optimize-13">Menyediakan, mengelola, dan meningkatkan konten dan layanan kami.</li>\r\n<li class="ai-optimize-13">Menganalisis perilaku pengunjung agar kami dapat memberikan konten yang lebih relevan.</li>\r\n<li class="ai-optimize-13">Menghubungi Anda, bila Anda mengisi formulir kontak atau berlangganan konten kami.</li>\r\n</ul>\r\n<h2 class="ai-optimize-14"><strong>Iklan Pihak Ketiga</strong></h2>\r\n<p class="ai-optimize-15">Kami menggunakan layanan Google AdSense dan mungkin penyedia iklan lainnya. Mereka dapat menggunakan cookies DART yang memungkinkan penayangan iklan berdasarkan kunjungan Anda ke situs ini dan situs lain di internet.</p>\r\n<p class="ai-optimize-16">Anda dapat menonaktifkan penggunaan cookie DART dengan mengunjungi halaman [Google Ads Settings](https://adssettings.google.com).</p>\r\n<h2 class="ai-optimize-17"><strong>Penggunaan Cookies</strong></h2>\r\n<p class="ai-optimize-18">Cookies adalah file kecil yang disimpan di perangkat Anda untuk membantu situs bekerja lebih efisien. Anda dapat menonaktifkan cookies melalui pengaturan browser, tetapi hal ini dapat mempengaruhi fungsi situs secara keseluruhan.</p>\r\n<h2 class="ai-optimize-19"><strong>Tautan Eksternal</strong></h2>\r\n<p class="ai-optimize-20">Situs ini mungkin mengandung tautan ke situs pihak ketiga. Kami tidak bertanggung jawab atas konten atau kebijakan privasi situs eksternal tersebut.</p>\r\n<h2 class="ai-optimize-21"><strong>Persetujuan</strong></h2>\r\n<p class="ai-optimize-22">Dengan menggunakan situs Crevalen, Anda menyetujui kebijakan privasi kami dan menyetujui ketentuan yang tercantum di dalamnya.</p>\r\n<h2 class="ai-optimize-23"><strong>Perubahan Kebijakan</strong></h2>\r\n<p class="ai-optimize-24">Kami dapat memperbarui kebijakan privasi ini dari waktu ke waktu. Perubahan akan diumumkan di halaman ini, dan tanggal revisi akan diperbarui di bagian bawah.</p>\r\n<p class="ai-optimize-25">Tanggal pembaruan terakhir: 8 Juni 2025</p>\r\n<p class="ai-optimize-26">&mdash;</p>\r\n<p class="ai-optimize-27">Untuk pertanyaan atau klarifikasi, silakan hubungi kami melalui halaman&nbsp;<a href="https://www.crevalen.xyz/kontak">Kontak.</a></p>	t	Kebijakan Privasi	Privasi Anda sangat penting bagi kami. Di Crevalen, kami berkomitmen untuk melindungi informasi pribadi pengunjung dengan sebaik-baiknya.	PrivacyPolicyPage	2025-07-14 14:56:08.063	2025-07-14 14:56:08.063
cmd38a7kf0002ulfod59ohmjl	syarat-dan-ketentuan	Syarat & Ketentuan	<p class="ai-optimize-7 ai-optimize-introduction" style="text-align: justify;">Dengan mengakses dan menggunakan situs Crevalen (crevalen.xyz), Anda setuju untuk mematuhi dan terikat oleh syarat dan ketentuan penggunaan yang dijabarkan di bawah ini. Jika Anda tidak setuju dengan sebagian atau seluruh ketentuan ini, mohon untuk tidak melanjutkan penggunaan situs.</p>\r\n<p class="ai-optimize-8" style="text-align: justify;"><strong>1. Penggunaan Situs</strong></p>\r\n<p class="ai-optimize-10" style="text-align: justify;">Situs ini disediakan hanya untuk tujuan informasi dan edukasi. Anda tidak diperkenankan menggunakan konten dari situs ini untuk tujuan ilegal, penipuan, atau aktivitas yang dapat merugikan pihak lain.</p>\r\n<p class="ai-optimize-11" style="text-align: justify;"><strong>&nbsp;2. Hak Kekayaan Intelektual</strong></p>\r\n<p class="ai-optimize-13" style="text-align: justify;">Seluruh konten yang dimuat di situs ini, termasuk namun tidak terbatas pada artikel, gambar, desain, logo, dan elemen visual lainnya adalah milik Crevalen dan dilindungi oleh undang-undang hak cipta.</p>\r\n<p class="ai-optimize-14" style="text-align: justify;">Anda tidak diperkenankan menggandakan, menyebarkan, atau menggunakan ulang konten tanpa izin tertulis dari kami.</p>\r\n<p class="ai-optimize-15" style="text-align: justify;"><strong>&nbsp;3. Tanggung Jawab</strong></p>\r\n<p class="ai-optimize-17" style="text-align: justify;">Kami tidak bertanggung jawab atas:</p>\r\n<ul style="text-align: justify;">\r\n<li class="ai-optimize-27">Ketidakakuratan informasi akibat perubahan kebijakan, data, atau pasar.</li>\r\n<li class="ai-optimize-27">Kerugian atau kerusakan langsung maupun tidak langsung akibat penggunaan informasi dari situs ini.</li>\r\n<li class="ai-optimize-27">Ketersediaan situs dan konten pihak ketiga yang ditautkan.</li>\r\n</ul>\r\n<p class="ai-optimize-20" style="text-align: justify;"><strong>&nbsp;4. Perubahan Ketentuan</strong></p>\r\n<p class="ai-optimize-21" style="text-align: justify;">Kami berhak untuk mengubah, memperbarui, atau mengganti bagian dari syarat dan ketentuan ini kapan saja tanpa pemberitahuan sebelumnya. Anda disarankan untuk memeriksa halaman ini secara berkala.</p>\r\n<p class="ai-optimize-22" style="text-align: justify;"><strong>5. Hukum yang Berlaku</strong></p>\r\n<p class="ai-optimize-24" style="text-align: justify;">Syarat dan ketentuan ini tunduk dan diinterpretasikan sesuai dengan hukum yang berlaku di wilayah Republik Indonesia.</p>\r\n<p class="ai-optimize-26" style="text-align: justify;">Jika Anda memiliki pertanyaan mengenai syarat dan ketentuan ini, silakan hubungi kami melalui halaman&nbsp;<a href="https://www.crevalen.xyz/kontak">Kontak</a></p>	t	Syarat dan Ketentuan	Dengan mengakses dan menggunakan situs Crevalen (crevalen.xyz), Anda setuju untuk mematuhi dan terikat oleh syarat dan ketentuan penggunaan yang dijabarkan di bawah ini	TermsOfServicePage	2025-07-14 14:58:12.303	2025-07-14 14:58:12.303
cmd38coeq0003ulfojzfo6972	disclaimer	Disclaimer	<p class="ai-optimize-7 ai-optimize-introduction" style="text-align: justify;">Selamat datang di Crevalen.<br>Seluruh informasi yang tersedia di situs ini disajikan dengan itikad baik dan untuk tujuan edukasi umum semata.</p>\r\n<h2 class="ai-optimize-8" style="text-align: justify;"><strong>Bukan Nasihat Profesional</strong></h2>\r\n<p class="ai-optimize-9" style="text-align: justify;">Informasi yang terdapat dalam artikel di Crevalen bukan merupakan nasihat keuangan, investasi, hukum, pajak, atau nasihat profesional lainnya. Kami tidak memiliki lisensi sebagai penasihat keuangan atau lembaga resmi keuangan. Segala keputusan yang Anda ambil berdasarkan konten dari situs ini adalah sepenuhnya tanggung jawab Anda sendiri.</p>\r\n<h2 class="ai-optimize-10" style="text-align: justify;"><strong>Akurasi Konten</strong></h2>\r\n<p class="ai-optimize-11" style="text-align: justify;">Kami berusaha semaksimal mungkin untuk menyajikan data dan informasi yang akurat dan terkini. Namun, kami tidak menjamin kelengkapan, keandalan, atau keakuratan dari setiap konten. Situasi pasar dan keuangan bisa berubah sewaktu-waktu tanpa pemberitahuan, dan kami tidak bertanggung jawab atas kerugian yang timbul akibat penggunaan informasi dari situs ini.</p>\r\n<h2 class="ai-optimize-12" style="text-align: justify;"><strong>Tanggung Jawab Pengguna</strong></h2>\r\n<p class="ai-optimize-13" style="text-align: justify;">Penggunaan atas informasi yang tersedia di situs ini sepenuhnya merupakan risiko pengguna. Kami tidak bertanggung jawab atas kerugian langsung maupun tidak langsung, kerusakan, atau konsekuensi lain yang timbul akibat keputusan Anda.</p>\r\n<h2 class="ai-optimize-14" style="text-align: justify;"><strong>Hak Cipta &amp; Kepemilikan Konten</strong></h2>\r\n<p class="ai-optimize-15" style="text-align: justify;">Seluruh konten di Crevalen adalah milik kami dan dilindungi hak cipta. Dilarang mengutip, menyalin, atau mendistribusikan ulang konten dari situs ini tanpa izin tertulis dari kami.</p>\r\n<p class="ai-optimize-16" style="text-align: justify;">Jika Anda ingin mengutip konten dari Crevalen untuk keperluan media, riset, atau publikasi, silakan hubungi kami terlebih dahulu.</p>\r\n<p class="ai-optimize-17" style="text-align: justify;">&mdash;</p>\r\n<p class="ai-optimize-18" style="text-align: justify;">Untuk pertanyaan lebih lanjut, hubungi kami melalui halaman&nbsp;<a href="https://www.crevalen.xyz/kontak">Kontak</a>.</p>	t	Disclaimer	Seluruh informasi yang tersedia di situs ini disajikan dengan itikad baik dan untuk tujuan edukasi umum semata.	WebPage	2025-07-14 15:00:07.442	2025-07-14 15:00:07.442
cmd38f8hq0004ulfo6ggzm2b3	kontak	Kontak	<p class="ai-optimize-7 ai-optimize-introduction">Kami sangat terbuka untuk pertanyaan, kritik, saran, maupun ajakan kerja sama. Jika Anda ingin menghubungi kami, silakan gunakan salah satu metode berikut:</p>\r\n<p class="ai-optimize-8"><strong>Email</strong> Hubungi kami langsung melalui email resmi:</p>\r\n<p class="ai-optimize-8"><a href="mailto:admin@crevalen.xyz">admin@crevalen.xyz</a>&nbsp;</p>\r\n<p class="ai-optimize-8"><a href="mailto:bolaportal@gmail.com">bolaportal@gmail.com</a></p>\r\n<p class="ai-optimize-25">&nbsp;</p>\r\n<p class="ai-optimize-25"><strong>Whatsapp</strong></p>\r\n<p class="ai-optimize-26">+6285119042467</p>\r\n<p class="ai-optimize-10">Kami akan merespons pesan Anda secepat mungkin, biasanya dalam waktu 1&ndash;3 hari kerja.</p>\r\n<p class="ai-optimize-21">Jam Operasional</p>\r\n<p class="ai-optimize-22">Senin &ndash; Jumat: 09.00 &ndash; 17.00 WIB Sabtu &ndash; Minggu &amp; Libur Nasional: Respon terbatas</p>\r\n<p class="ai-optimize-24">Kami menghargai setiap pesan yang masuk. Terima kasih atas kepercayaan Anda kepada Crevalen.</p>	t	Kontak	Kami sangat terbuka untuk pertanyaan, kritik, saran, maupun ajakan kerja sama. Jika Anda ingin menghubungi kami, silakan gunakan salah satu metode berikut:	ContactPage	2025-07-14 15:02:06.782	2025-07-14 15:02:06.782
\.


--
-- Data for Name: Post; Type: TABLE DATA; Schema: public; Owner: user_dev
--

COPY public."Post" (id, slug, title, content, published, "createdAt", "updatedAt", "authorId", "metaDescription", "metaTitle", "featuredImageId", "focusKeyword", "canonicalUrl", "noFollow", "noIndex", "ogDescription", "ogImageId", "ogTitle", "schemaType", "publishedAt") FROM stdin;
cmcqsf5550001ul3kjbyf0kaj	testing-artikel	Financial Freedom di Umur 30 Tahun?	<p class="ai-optimize-6 ai-optimize-introduction" data-start="239" data-end="713">Pernah gak sih kamu bayangin bebas finansial&nbsp;<em data-start="283" data-end="292">sebelum</em>&nbsp;umur 30? Zaman sekarang&nbsp;<em data-start="317" data-end="336">financial freedom</em>&nbsp;bukan cuma mimpi sepi, tapi tujuan nyata buat banyak orang muda. Kita, generasi Z, tumbuh di dunia yang serba cepat dan penuh godaan (conten viral, belanja online, promo&nbsp;<em data-start="507" data-end="517">cashback</em>). Kalau gak hati-hati, gaya hidup konsumtif bisa bikin kantong bolong. Daripada bingung, mending kita bahas strategi&nbsp;<em data-start="635" data-end="640">fun</em>&nbsp;dan langkah nyata supaya kita punya&nbsp;<strong data-start="677" data-end="698">financial freedom</strong>&nbsp;di usia 30-an.</p>\r\n<h2 class="ai-optimize-7" data-start="715" data-end="764"><strong>Kenapa Generasi Z Butuh Financial Freedom?</strong></h2>\r\n<p class="ai-optimize-8" data-start="766" data-end="1709">Kita hidup di era inflasi tinggi dan biaya hidup makin naik. Masih ngutang sekolah atau gaji pas-pasan? Wah, makin susah merasa aman. Sebabnya sederhana:&nbsp;<em data-start="920" data-end="941">kebebasan finansial</em>&nbsp;itu terkait erat dengan stabilitas hidup. Menurut&nbsp;<a href="https://www.treasury.id/">Treasury.id</a>&nbsp;(2025),&nbsp;<em data-start="1012" data-end="1031">financial freedom</em>&nbsp;adalah kondisi di mana kita punya aset dan sumber pendapatan pasif cukup untuk hidup tanpa tergantung kerja aktif. Artinya, kita bisa menikmati hidup tanpa stres soal uang. Banyak Gen Z malah sudah terjebak gaya hidup boros karena belum punya rencana yang jelas.</p>\r\n<p class="ai-optimize-8" data-start="766" data-end="1709">Data OJK terbaru juga menekankan bahwa edukasi finansial bagi generasi muda penting sekali, supaya kita bisa mengelola uang dengan bijak dan punya&nbsp;<em data-start="1516" data-end="1524">buffer</em>&nbsp;ketika krisis.&nbsp;Jadi, kenapa harus peduli? Karena merencanakan&nbsp;<em data-start="1624" data-end="1643">financial freedom</em>&nbsp;sejak dini membuat kita bebas dari tekanan ekonomi di masa depan.</p>\r\n<h2 class="ai-optimize-9" data-start="1711" data-end="1760"><strong>Menetapkan Tujuan: Rencana Keuangan Masa Depan</strong></h2>\r\n<p class="ai-optimize-10" data-start="1762" data-end="2017">Langkah pertama menuju&nbsp;<strong data-start="1785" data-end="1806">financial freedom</strong>&nbsp;adalah tentukan tujuan finansial yang&nbsp;<em data-start="1845" data-end="1852">clear</em>. Misalnya, kita mau punya rumah, buka usaha sendiri, atau&nbsp;<em data-start="1911" data-end="1925">pensiun dini</em>&nbsp;di usia 40. Tanpa tujuan, anggaran seperti kapal tanpa kompas. Yuk, mulailah dari sekarang:</p>\r\n<p class="ai-optimize-12" data-start="2021" data-end="2208"><strong data-start="2021" data-end="2059">1. Tetapkan tujuan jangka panjang:</strong>&nbsp;Ayo tentukan apa yang ingin dicapai. Contoh: punya tabungan Rp 200 juta untuk DP rumah di umur 30, atau punya pendapatan pasif Rp 10 juta per bulan.</p>\r\n<div class="jnews_inline_related_post_wrapper left">\r\n<div class="jnews_inline_related_post">\r\n<div class="jeg_postblock_28 jeg_postblock jeg_module_hook jeg_pagination_disable jeg_col_2o3 jnews_module_30766_0_6864f35c876f2   " data-unique="jnews_module_30766_0_6864f35c876f2">\r\n<div class="jeg_block_heading jeg_block_heading_9 jeg_subcat_right">\r\n<h3 class="jeg_block_title">Baca Juga</h3>\r\n</div>\r\n<div class="jeg_block_container">\r\n<div class="jeg_posts ">\r\n<div class="jeg_postsmall jeg_load_more_flag">\r\n<article class="jeg_post jeg_pl_xs_4 format-standard">\r\n<div class="jeg_postblock_content">\r\n<h3 class="jeg_post_title"><a href="https://www.crevalen.xyz/tips/kakeibo-metode-cerdas-menghemat-uang-dari-jepang/">Gaji Sering Habis? Coba Kakeibo, Metode Cerdas Menghemat Uang dari Jepang</a></h3>\r\n</div>\r\n</article>\r\n<article class="jeg_post jeg_pl_xs_4 format-standard">\r\n<div class="jeg_postblock_content">\r\n<h3 class="jeg_post_title"><a href="https://www.crevalen.xyz/tips/7-ide-passive-income-paling-realistis-di-2025/">7 Ide Passive Income Paling Realistis di 2025</a></h3>\r\n</div>\r\n</article>\r\n<article class="jeg_post jeg_pl_xs_4 format-standard">\r\n<div class="jeg_postblock_content">\r\n<h3 class="jeg_post_title"><a href="https://www.crevalen.xyz/tips/open-banking-indonesia/">Mengenal Open Banking dan Aplikasi PFM Berbasis Open API di Indonesia 2025</a></h3>\r\n</div>\r\n</article>\r\n</div>\r\n</div>\r\n</div>\r\n<div class="jeg_block_navigation">&nbsp;</div>\r\n</div>\r\n</div>\r\n</div>\r\n<p class="ai-optimize-14" data-start="2211" data-end="2444"><strong data-start="2211" data-end="2243">2. Susun anggaran realistis:</strong>&nbsp;Catat semua pemasukan (gaji, uang saku, penghasilan sampingan) dan pengeluaran rutin (kos, makan, transport). Bedakan antara kebutuhan dan keinginan. Jangan sampai tergoda beli gadget baru tiap promo.</p>\r\n<p class="ai-optimize-16" data-start="2447" data-end="2676"><strong data-start="2447" data-end="2475">3. Siapkan dana darurat:</strong>&nbsp;Sisihkan minimal 3&ndash;6 bulan pengeluaran di rekening terpisah. Ini simpanan&nbsp;<em data-start="2550" data-end="2557">wajib</em>&nbsp;agar jika ada krisis (pemecatan, sakit, bencana), kita gak perlu makan mie instan setiap hari atau pinjam ke rentenir.</p>\r\n<p class="ai-optimize-16" data-start="2447" data-end="2676">Dengan perencanaan ini, kita punya peta jalan menuju&nbsp;<em data-start="2731" data-end="2752">kebebasan finansial</em>. Seperti Generali Indonesia (2022) sebut, salah satu syarat&nbsp;<em data-start="2813" data-end="2834">kebebasan finansial</em>&nbsp;adalah punya tabungan dan penghasilan cukup untuk menanggung hidup tanpa utang.&nbsp;Jadi, mulai dari sekarang, catat rencana keuanganmu dan patuhi!</p>\r\n<h2 class="ai-optimize-18" data-start="3017" data-end="3056"><strong>Kelola Utang agar Bisa Bebas Utang</strong></h2>\r\n<p class="ai-optimize-19" data-start="3058" data-end="3548"><em data-start="3096" data-end="3177">Financial freedom concept: tangan terbuka membebaskan diri dari belenggu utang.</em>&nbsp;Utang memang kadang perlu (misal KTA kuliah atau kredit rumah), tapi jadi masalah kalau menumpuk. Lakuemas (2024) bahkan menyebut&nbsp;<em data-start="3308" data-end="3321">bebas utang</em>&nbsp;sebagai tahap penting sebelum mencapai pendapatan pasif stabil. Kalau masih banyak cicilan kartu kredit atau pinjol, susah deh mengejar&nbsp;<em data-start="3495" data-end="3516">kebebasan finansial</em>. Yuk, hindari dan kelola utang:</p>\r\n<ul data-start="3550" data-end="4007">\r\n<li class="ai-optimize-20" data-start="3550" data-end="3703">\r\n<p class="ai-optimize-21" data-start="3552" data-end="3703"><strong data-start="3552" data-end="3578">Utang berbunga tinggi:</strong>&nbsp;Prioritaskan lunasi utang kartu kredit atau pinjaman online yang bunga-nya nyesek. Bayar minimal lebih dari tagihan minimum.</p>\r\n</li>\r\n<li class="ai-optimize-22" data-start="3704" data-end="3853">\r\n<p class="ai-optimize-23" data-start="3706" data-end="3853"><strong data-start="3706" data-end="3735">Jangan tambah utang baru:</strong>&nbsp;Stop tarik paylater, kredit barang tanpa perhitungan. Sebelum beli, tanya ke diri sendiri, &ldquo;Sedia dana cadangan kah?&rdquo;</p>\r\n</li>\r\n<li class="ai-optimize-24" data-start="3854" data-end="4007">\r\n<p class="ai-optimize-25" data-start="3856" data-end="4007"><strong data-start="3856" data-end="3887">Refinance atau konsolidasi:</strong>&nbsp;Kalau bisa, pilih cicilan bunga rendah (bunga KPR atau KTA bank), atau kumpulkan utang ke 1 tempat supaya lebih ringan.</p>\r\n</li>\r\n</ul>\r\n<h2 class="ai-optimize-26" data-start="4104" data-end="4147"><strong>Membangun Penghasilan Pasif sejak Dini</strong></h2>\r\n<p class="ai-optimize-27" data-start="4149" data-end="4465"><em data-start="4187" data-end="4280">Financial freedom concept: seorang pria melompat keluar dari kapal, simbol bebas finansial.</em>&nbsp;Penghasilan pasif adalah kunci menjaga&nbsp;<em data-start="4320" data-end="4331">cash flow</em>&nbsp;terus bergerak meski kita lagi liburan. Contohnya: sewa kamar kost, bagi hasil usaha kecil, atau hasil dividen saham. Mulai gali ide:</p>\r\n<ul data-start="4467" data-end="5069">\r\n<li class="ai-optimize-28" data-start="4467" data-end="4611">\r\n<p class="ai-optimize-29" data-start="4469" data-end="4611"><strong data-start="4469" data-end="4496">Usaha sampingan/online:</strong>&nbsp;Jualan kaos custom, jadi reseller produk, atau buka toko di marketplace. Hasilnya bisa dipakai tambahan&nbsp;<a href="https://www.crevalen.xyz/trading/modal-trading/">investasi</a>.</p>\r\n</li>\r\n<li class="ai-optimize-30" data-start="4612" data-end="4732">\r\n<p class="ai-optimize-31" data-start="4614" data-end="4732"><strong data-start="4614" data-end="4633">Konten kreatif:</strong>&nbsp;Jika hobi menulis, bikin blog atau e-book; suka video, coba YouTube atau TikTok, dan pasang iklan.</p>\r\n</li>\r\n<li class="ai-optimize-32" data-start="4733" data-end="4906">\r\n<p class="ai-optimize-33" data-start="4735" data-end="4906"><strong data-start="4735" data-end="4754">Aset finansial:</strong>&nbsp;Nabung reksadana pasar uang yang membagikan bunga; invest di saham blue chip yang rutin bagi dividen; ataupun pinjamkan uang di P2P lending terpercaya.</p>\r\n</li>\r\n<li class="ai-optimize-34" data-start="4907" data-end="5069">\r\n<p class="ai-optimize-35" data-start="4909" data-end="5069"><strong data-start="4909" data-end="4926">Proyek pasif:</strong>&nbsp;Afiliasi, template desain digital, atau micro-work seperti lewat platform freelance, di mana kamu membuat sekali tetapi bisa terjual berulang.</p>\r\n</li>\r\n</ul>\r\n<p class="ai-optimize-36" data-start="5071" data-end="5280">Tujuannya: saat kita tidur atau jalan-jalan, rekening tetap terisi. Memang nggak instan, tapi sisihkan sebagian pendapatan untuk membangun&nbsp;<em data-start="5210" data-end="5229">penghasilan pasif</em>. Dari situ, kejar&nbsp;<em data-start="5248" data-end="5267">financial freedom</em>-mu perlahan.</p>\r\n<h2 class="ai-optimize-37" data-start="5282" data-end="5340"><strong>Investasi untuk Masa Depan: Pintu Menuju Pensiun Dini</strong></h2>\r\n<p class="ai-optimize-38" data-start="5342" data-end="5622"><em data-start="5380" data-end="5451">Financial freedom concept: koper terbuka penuh uang, simbol kekayaan.</em>&nbsp;Gak lengkap rasanya kalau bahas&nbsp;<strong data-start="5484" data-end="5505">financial freedom</strong>&nbsp;tanpa bicara investasi. Ingat, investasi bukan judi &mdash; harus cerdas dan disiplin. Beberapa langkah invest buat Gen Z:</p>\r\n<ul data-start="5624" data-end="6607">\r\n<li class="ai-optimize-39" data-start="5624" data-end="5847">\r\n<p class="ai-optimize-40" data-start="5626" data-end="5847"><strong data-start="5626" data-end="5652">Reksa Dana atau Saham:</strong>&nbsp;Buka akun investasi di aplikasi (Bibit, IPOT, Tokopedia). Pilih reksa dana pasar uang untuk pemula (risiko rendah) atau saham untuk keuntungan jangka panjang. Sesuaikan dengan profil risiko, ya.</p>\r\n</li>\r\n<li class="ai-optimize-41" data-start="5848" data-end="6091">\r\n<p class="ai-optimize-42" data-start="5850" data-end="6091"><strong data-start="5850" data-end="5867">Emas Digital:</strong>&nbsp;Emas tradisional atau digital bisa jadi penyelamat saat inflasi tinggi. Harga emas cenderung naik stabil. Contohnya, platform emas digital memudahkan Gen Z punya aset emas kecil-kecilan.</p>\r\n</li>\r\n<li class="ai-optimize-43" data-start="6092" data-end="6370">\r\n<p class="ai-optimize-44" data-start="6094" data-end="6370"><strong data-start="6094" data-end="6112">Diversifikasi:</strong>&nbsp;Jangan taruh semua uang di satu tempat. Kombinasikan berbagai instrumen (saham, obligasi, properti, emas).&nbsp;<strong data-start="6220" data-end="6232">Generali</strong>&nbsp;menyebut, punya sumber penghasilan pasif (termasuk investasi) adalah ciri utama kebebasan finansial.</p>\r\n</li>\r\n<li class="ai-optimize-45" data-start="6371" data-end="6607">\r\n<p class="ai-optimize-46" data-start="6373" data-end="6607"><strong data-start="6373" data-end="6390">Pensiun Dini:</strong>&nbsp;Mimpi pensiun muda? Atur investasi yang hasilnya bisa menutupi pengeluaran di hari tua. Banyak Gen Z bercita-cita pensiun di 40-an&mdash;yuk mulai nabung di dana pensiun swasta atau produk investasi jangka panjang lainnya.</p>\r\n</li>\r\n</ul>\r\n<p class="ai-optimize-47" data-start="6609" data-end="6718">Dengan berinvestasi sejak dini, kita manfaatkan kekuatan bunga majemuk. Sedikit-sedikit lama-lama jadi bukit!</p>\r\n<p class="ai-optimize-52" data-start="7578" data-end="8194">Intinya,&nbsp;<em data-start="7587" data-end="7606">financial freedom</em>&nbsp;di umur 30 bukan khayalan kalau kita punya strategi. Mulai dari perencanaan matang, disiplin menabung, melunasi utang, hingga membangun&nbsp;<em data-start="7743" data-end="7762">penghasilan pasif</em>&nbsp;dan&nbsp;<em data-start="7767" data-end="7778">investasi</em>. Semua itu butuh proses dan komitmen. Sebagaimana Generali (2022) simpulkan, kebebasan finansial tercapai jika penghasilan pasif dan tabungan cukup menanggung hidup tanpa utang. Ayo, catat dulu targetmu, lalu mulai bertindak: kurangi pengeluaran konsumtif, tingkatkan literasi finansial, dan coba praktikkan satu langkah kecil tiap hari.</p>\r\n<p class="ai-optimize-53" data-start="8196" data-end="8417">Jangan lupa bagikan artikel ini ke teman-temanmu yang juga pengen&nbsp;<em data-start="8262" data-end="8281">financial freedom</em> di masa muda! Yuk mulai perjalanan finansial kita sekarang, semakin cepat mulai, semakin dekat juga ke mimpi merdeka secara finansial.</p>	t	2025-07-05 22:00:54.445	2025-07-06 22:37:36.583	cmcqrdgbf0000ul3cfjchfrxl			cmcs7b13t0007ul1o4m849b01	\N	\N	f	f	\N	\N	\N	\N	\N
cmcs40k2z0001ul5kdspdlm12	7-ide-passive-income-paling-realistis-di-2025	7 Ide Passive Income Paling Realistis di 2025	<p class="ai-optimize-6 ai-optimize-introduction">Jam menunjukkan pukul 8 malam. Kamu baru saja sampai di rumah setelah berjibaku dengan macetnya jalanan. Badan lengket, kepala penat, dan notifikasi kerjaan di grup WhatsApp masih saja berbunyi. Kamu merebahkan diri di sofa, membuka media sosial, dan melihat temanmu sedang liburan di pantai pada hari kerja.</p>\r\n<p class="ai-optimize-6 ai-optimize-introduction">ini hanya tersting</p>\r\n<p class="ai-optimize-7">Dalam hati kamu bertanya,&nbsp;<em>&ldquo;Kok bisa, ya? Kapan gue bisa kayak gitu?&rdquo;</em></p>\r\n<p class="ai-optimize-8">Jujur saja, saya pun pernah berada di posisi itu. Bertahun-tahun saya merasa seperti hamster yang berlari di roda putar: bekerja keras, gajian, bayar tagihan, lalu uang habis, dan siklus itu berulang lagi. Sampai akhirnya saya sadar, yang saya butuhkan bukan cuma gaji lebih besar, tapi sebuah&nbsp;<strong>sistem</strong>&nbsp;yang bisa menghasilkan uang, bahkan saat saya tidak sedang aktif bekerja.</p>\r\n<p class="ai-optimize-9">Selamat datang di dunia&nbsp;<em>passive income</em>.</p>\r\n<p class="ai-optimize-10">Artikel ini bukan sekadar daftar ide yang basi. Ini adalah panduan lengkap dan membumi yang akan saya bagikan, layaknya seorang teman yang sudah lebih dulu mencoba. Saya akan tunjukkan:</p>\r\n<ul>\r\n<li class="ai-optimize-11">\r\n<p class="ai-optimize-12"><strong>Apa itu pendapatan pasif yang sebenarnya</strong>&nbsp;(bukan mitos &ldquo;kaya mendadak&rdquo;).</p>\r\n</li>\r\n<li class="ai-optimize-13">\r\n<p class="ai-optimize-14"><strong>7 ide passive income terbaru dan paling relevan</strong>&nbsp;untuk kondisi tahun 2025, lengkap dengan potensi dan tingkat kesulitannya.</p>\r\n</li>\r\n<li class="ai-optimize-15">\r\n<p class="ai-optimize-16"><strong>Langkah-langkah konkret</strong>&nbsp;untuk memulai, bahkan jika kamu hanya punya waktu luang di akhir pekan.</p>\r\n</li>\r\n</ul>\r\n<p class="ai-optimize-18">&nbsp;</p>\r\n<h2 class="ai-optimize-19"><strong>Apa Itu Passive Income Sebenarnya?</strong></h2>\r\n<p class="ai-optimize-20">Sebelum kita melangkah lebih jauh, kita perlu luruskan satu hal penting. Banyak orang salah kaprah mengira&nbsp;<em>passive income</em>&nbsp;itu artinya uang datang dari langit tanpa usaha sama sekali. Itu keliru besar.</p>\r\n<p class="ai-optimize-21">Bayangkan kamu menanam pohon mangga.</p>\r\n<p class="ai-optimize-22">Awalnya, kamu harus bekerja keras: membeli bibit unggul (investasi awal), mencangkul tanah, menanam, menyiramnya setiap hari, memberinya pupuk, dan melindunginya dari hama (usaha di depan). Selama berbulan-bulan, tidak ada hasil sama sekali. Hanya kerja, kerja, dan kerja.</p>\r\n<p class="ai-optimize-23">Tapi, setelah pohon itu tumbuh besar dan kuat, ia akan mulai berbuah dengan sendirinya. Setiap musim, kamu tinggal memetik hasilnya. Kamu mungkin sesekali masih perlu merawatnya, tapi usahanya tidak seberat di awal. Pohon itu kini menjadi &ldquo;mesin&rdquo; penghasil mangga untukmu.</p>\r\n<p class="ai-optimize-24">Itulah&nbsp;<strong>passive income</strong>. Usaha keras di awal untuk membangun sebuah sistem (aset), yang kemudian akan memberikan hasil secara terus-menerus dengan sedikit atau tanpa usaha aktif.</p>\r\n<p class="ai-optimize-25">Jadi, lupakan mitos &ldquo;tidak kerja dapat uang&rdquo;. Ganti dengan mindset:&nbsp;<strong>&ldquo;Kerja cerdas sekarang, panen hasilnya selamanya.&rdquo;</strong></p>\r\n<p>&nbsp;</p>\r\n<h2 class="ai-optimize-25"><strong>&nbsp;7 Ide Passive Income Terbaik dan Terkini untuk Dicoba di 2025</strong></h2>\r\n<p class="ai-optimize-28">Dunia digital terus berubah. Ide yang berhasil lima tahun lalu mungkin sudah tidak relevan. Berikut adalah ide-ide yang saya kurasi khusus untuk menyambut tahun 2025, dari yang modalnya kecil hingga yang butuh investasi lebih.</p>\r\n<p>&nbsp;</p>\r\n<h4 class="ai-optimize-29"><strong>1. Menjadi &ldquo;Arsitek&rdquo; Produk Digital Mini</strong></h4>\r\n<p class="ai-optimize-30">Ini favorit saya. Lupakan membuat kursus online yang rumit atau menulis e-book 200 halaman. Fokuslah pada produk digital &ldquo;mini&rdquo; yang menyelesaikan satu masalah spesifik.</p>\r\n<ul>\r\n<li class="ai-optimize-31">\r\n<p class="ai-optimize-32"><strong>Apa itu?</strong>&nbsp;Kamu membuat satu kali, menjualnya berkali-kali. Contohnya:</p>\r\n<ul>\r\n<li class="ai-optimize-33">\r\n<p class="ai-optimize-34"><strong>Template Notion:</strong>&nbsp;Untuk budgeting, manajemen proyek, atau meal planning.</p>\r\n</li>\r\n<li class="ai-optimize-35">\r\n<p class="ai-optimize-36"><strong>Preset Lightroom:</strong>&nbsp;Untuk fotografer amatir yang ingin fotonya keren seketika.</p>\r\n</li>\r\n<li class="ai-optimize-37">\r\n<p class="ai-optimize-38"><strong>Planner Digital:</strong>&nbsp;Untuk pengguna iPad yang suka mencatat secara digital.</p>\r\n</li>\r\n<li class="ai-optimize-39">\r\n<p class="ai-optimize-40"><strong>Kumpulan Prompt AI:</strong>&nbsp;Menjual daftar&nbsp;<em>prompt</em>&nbsp;(perintah) spesifik untuk menghasilkan gambar atau tulisan AI yang bagus.</p>\r\n</li>\r\n</ul>\r\n</li>\r\n<li class="ai-optimize-41">\r\n<p class="ai-optimize-42"><strong>Tingkat Kesulitan:</strong>&nbsp;Rendah ke Menengah.</p>\r\n</li>\r\n<li class="ai-optimize-43">\r\n<p class="ai-optimize-44"><strong>Modal:</strong>&nbsp;Hampir nol, lebih butuh waktu dan kreativitas.</p>\r\n</li>\r\n<li class="ai-optimize-45">\r\n<p class="ai-optimize-46"><strong>Cara Memulai:</strong>&nbsp;Identifikasi keahlian kecilmu. Jago bikin presentasi? Jual template PowerPoint/<a href="https://www.canva.com/">Canva</a>. Jago ngatur duit? Bikin template spreadsheet budget. Jual di platform seperti Etsy, Gumroad, atau bahkan Tokopedia.</p>\r\n</li>\r\n</ul>\r\n<p>&nbsp;</p>\r\n<h4 class="ai-optimize-47"><strong>2. Affiliate Marketing dengan Sentuhan Personal (Hyper-Niche)</strong></h4>\r\n<p class="ai-optimize-48"><em>Affiliate marketing</em>&nbsp;bukan hal baru, tapi caranya sudah berevolusi. Lupakan mereview &ldquo;HP terbaik&rdquo;. Pasarnya sudah terlalu ramai.</p>\r\n<ul>\r\n<li class="ai-optimize-49">\r\n<p class="ai-optimize-50"><strong>Apa itu?</strong>&nbsp;Kamu merekomendasikan produk orang lain melalui link unik. Jika ada yang membeli lewat link-mu, kamu dapat komisi. Kuncinya di 2025 adalah&nbsp;<strong>hyper-niche</strong>.</p>\r\n<ul>\r\n<li class="ai-optimize-51">\r\n<p class="ai-optimize-52"><strong>Contoh:</strong>&nbsp;Daripada blog &ldquo;Peralatan Dapur&rdquo;, buat blog atau akun TikTok khusus &ldquo;Review Peralatan Kopi untuk Pemula&rdquo;. Review grinder, timbangan, teko leher angsa dengan jujur.</p>\r\n</li>\r\n</ul>\r\n</li>\r\n<li class="ai-optimize-53">\r\n<p class="ai-optimize-54"><strong>Tingkat Kesulitan:</strong>&nbsp;Menengah.</p>\r\n</li>\r\n<li class="ai-optimize-55">\r\n<p class="ai-optimize-56"><strong>Modal:</strong>&nbsp;Rendah. Bisa dimulai dengan blog gratis atau media sosial.</p>\r\n</li>\r\n<li class="ai-optimize-57">\r\n<p class="ai-optimize-58"><strong>Cara Memulai:</strong>&nbsp;Pilih hobi atau topik yang sangat spesifik yang kamu kuasai. Buat konten yang jujur dan bermanfaat seputar topik itu. Daftar program afiliasi di e-commerce seperti Tokopedia/Shopee Affiliates atau brand langsung.</p>\r\n</li>\r\n</ul>\r\n<p>&nbsp;</p>\r\n<h4 class="ai-optimize-60"><strong>3. Membangun &ldquo;Kerajaan&rdquo; Konten yang Ditenagai AI</strong></h4>\r\n<p class="ai-optimize-61">AI (Artificial Intelligence) bukan lagi masa depan, tapi masa kini. Kamu bisa memanfaatkannya sebagai asisten super untuk membangun blog atau kanal YouTube yang menghasilkan uang dari iklan (AdSense).</p>\r\n<ul>\r\n<li class="ai-optimize-62">\r\n<p class="ai-optimize-63"><strong>Apa itu?</strong>&nbsp;Kamu tetap menjadi otak dan editor utama, tapi AI membantumu dalam riset ide, membuat outline, bahkan menyusun draf awal. Ini memotong waktu produksi konten hingga 70%.</p>\r\n</li>\r\n<li class="ai-optimize-64">\r\n<p class="ai-optimize-65"><strong>Tingkat Kesulitan:</strong>&nbsp;Menengah.</p>\r\n</li>\r\n<li class="ai-optimize-66">\r\n<p class="ai-optimize-67"><strong>Modal:</strong>&nbsp;Rendah ke Menengah (untuk tools AI premium).</p>\r\n</li>\r\n<li class="ai-optimize-68">\r\n<p class="ai-optimize-69"><strong>Cara Memulai:</strong>&nbsp;Pilih niche yang kamu minati. Gunakan tools AI seperti ChatGPT atau Gemini untuk brainstorming. Buat konten berkualitas (ingat, AI adalah asisten, bukan penggantimu!), lalu monetisasi dengan Google AdSense setelah traffic-mu cukup.</p>\r\n</li>\r\n</ul>\r\n<p>&nbsp;</p>\r\n<h4 class="ai-optimize-70"><strong>4. &ldquo;Beternak Uang&rdquo; di Platform P2P Lending &amp; Robo-Advisor</strong></h4>\r\n<p class="ai-optimize-71">Jika kamu punya dana lebih tapi tidak punya banyak waktu, ini adalah jalur yang paling &ldquo;pasif&rdquo;.</p>\r\n<ul>\r\n<li class="ai-optimize-72">\r\n<p class="ai-optimize-73"><strong>Apa itu?</strong></p>\r\n<ul>\r\n<li class="ai-optimize-74">\r\n<p class="ai-optimize-75"><strong>P2P Lending:</strong>&nbsp;Kamu meminjamkan uangmu kepada individu atau UKM melalui platform digital dan mendapatkan bunga.</p>\r\n</li>\r\n<li class="ai-optimize-76">\r\n<p class="ai-optimize-77"><strong><a href="https://faq.bibit.id/id/category/robo-advisor-bxiv33/">Robo-Advisor</a>:</strong>&nbsp;Kamu menaruh uang di sebuah aplikasi, dan &ldquo;robot&rdquo; akan otomatis menginvestasikannya ke reksa dana atau saham sesuai profil risikomu.</p>\r\n</li>\r\n</ul>\r\n</li>\r\n<li class="ai-optimize-78">\r\n<p class="ai-optimize-79"><strong>Tingkat Kesulitan:</strong>&nbsp;Rendah.</p>\r\n</li>\r\n<li class="ai-optimize-80">\r\n<p class="ai-optimize-81"><strong>Modal:</strong>&nbsp;Menengah ke Tinggi.</p>\r\n</li>\r\n<li class="ai-optimize-82">\r\n<p class="ai-optimize-83"><strong>Cara Memulai:</strong>&nbsp;Pilih platform P2P Lending yang terdaftar dan diawasi OJK. Untuk Robo-Advisor, pilih aplikasi yang punya rekam jejak bagus di Indonesia. Mulailah dengan nominal kecil untuk memahami cara kerjanya.&nbsp;<strong>Ingat, selalu diversifikasi!</strong>&nbsp;Jangan taruh semua telurmu dalam satu keranjang.</p>\r\n</li>\r\n</ul>\r\n<h4>&nbsp;</h4>\r\n<h4 class="ai-optimize-85"><strong>5. Menyewakan Aset yang &ldquo;Menganggur&rdquo;</strong></h4>\r\n<p class="ai-optimize-86">Lihat sekeliling rumahmu. Ada barang yang jarang dipakai tapi punya nilai sewa?</p>\r\n<ul>\r\n<li class="ai-optimize-87">\r\n<p class="ai-optimize-88"><strong>Apa itu?</strong>&nbsp;Kamu menyewakan barang-barang milikmu. Bukan cuma kamar atau rumah (seperti Airbnb), tapi juga:</p>\r\n<ul>\r\n<li class="ai-optimize-89">\r\n<p class="ai-optimize-90">Kamera dan lensa.</p>\r\n</li>\r\n<li class="ai-optimize-91">\r\n<p class="ai-optimize-92">Drone.</p>\r\n</li>\r\n<li class="ai-optimize-93">\r\n<p class="ai-optimize-94">Peralatan sound system atau lighting untuk pesta kecil.</p>\r\n</li>\r\n<li class="ai-optimize-95">\r\n<p class="ai-optimize-96">Bahkan mobilmu saat tidak dipakai (lewat platform sewa mobil).</p>\r\n</li>\r\n</ul>\r\n</li>\r\n<li class="ai-optimize-97">\r\n<p class="ai-optimize-98"><strong>Tingkat Kesulitan:</strong>&nbsp;Rendah.</p>\r\n</li>\r\n<li class="ai-optimize-99">\r\n<p class="ai-optimize-100"><strong>Modal:</strong>&nbsp;Tergantung aset yang sudah kamu miliki.</p>\r\n</li>\r\n<li class="ai-optimize-101">\r\n<p class="ai-optimize-102"><strong>Cara Memulai:</strong>&nbsp;Identifikasi asetmu. Foto dengan baik. Iklankan di media sosial, komunitas, atau platform penyewaan khusus jika ada. Buat perjanjian sewa yang jelas untuk keamanan.</p>\r\n</li>\r\n</ul>\r\n<p>&nbsp;</p>\r\n<h4 class="ai-optimize-103"><strong>6. Dropshipping atau Print-on-Demand Otomatis</strong></h4>\r\n<p class="ai-optimize-104">Model bisnis ini memungkinkan kamu punya toko online tanpa perlu menyimpan stok barang.</p>\r\n<ul>\r\n<li class="ai-optimize-105">\r\n<p class="ai-optimize-106"><strong>Apa itu?</strong></p>\r\n<ul>\r\n<li class="ai-optimize-107">\r\n<p class="ai-optimize-108"><strong>Dropshipping:</strong>&nbsp;Kamu menjual produk dari supplier. Saat ada pesanan, supplier yang akan mengirimkan barangnya langsung ke pembeli.</p>\r\n</li>\r\n<li class="ai-optimize-109">\r\n<p class="ai-optimize-110"><strong>Print-on-Demand:</strong>&nbsp;Kamu menjual produk custom (kaos, mug, casing HP) dengan desainmu. Produk baru akan dicetak saat ada pesanan.</p>\r\n</li>\r\n</ul>\r\n</li>\r\n<li class="ai-optimize-111">\r\n<p class="ai-optimize-112"><strong>Tingkat Kesulitan:</strong>&nbsp;Menengah ke Tinggi (di bagian pemasaran).</p>\r\n</li>\r\n<li class="ai-optimize-113">\r\n<p class="ai-optimize-114"><strong>Modal:</strong>&nbsp;Rendah.</p>\r\n</li>\r\n<li class="ai-optimize-115">\r\n<p class="ai-optimize-116"><strong>Cara Memulai:</strong>&nbsp;Pilih niche produk yang unik. Cari supplier terpercaya. Buat toko online di platform seperti Shopify atau manfaatkan marketplace. Fokus utamamu adalah pemasaran dan branding.</p>\r\n</li>\r\n</ul>\r\n<p>&nbsp;</p>\r\n<h4 class="ai-optimize-117"><strong>7. Membangun Newsletter Berbayar di Bidang Spesialis</strong></h4>\r\n<p class="ai-optimize-118">Jika kamu punya pengetahuan mendalam di satu bidang (misalnya, analisis saham, tren marketing, resep masakan sehat), ini bisa jadi tambang emas.</p>\r\n<ul>\r\n<li class="ai-optimize-119">\r\n<p class="ai-optimize-120"><strong>Apa itu?</strong>&nbsp;Kamu mengirimkan email eksklusif berisi insight berharga secara rutin kepada pelanggan yang membayar biaya langganan bulanan.</p>\r\n</li>\r\n<li class="ai-optimize-121">\r\n<p class="ai-optimize-122"><strong>Tingkat Kesulitan:</strong>&nbsp;Tinggi (butuh keahlian dan konsistensi).</p>\r\n</li>\r\n<li class="ai-optimize-123">\r\n<p class="ai-optimize-124"><strong>Modal:</strong>&nbsp;Sangat Rendah.</p>\r\n</li>\r\n<li class="ai-optimize-125">\r\n<p class="ai-optimize-126"><strong>Cara Memulai:</strong>&nbsp;Mulai dengan newsletter gratis untuk membangun audiens. Gunakan platform seperti Substack atau ConvertKit. Setelah punya basis pembaca yang loyal, tawarkan versi premium dengan konten yang lebih mendalam.</p>\r\n</li>\r\n</ul>\r\n<p class="ai-optimize-127">&nbsp;</p>\r\n<h2 class="ai-optimize-128"><strong>Jadi, Harus Mulai dari Mana? Peta Jalan Singkat untuk Pemula</strong></h2>\r\n<p class="ai-optimize-129">Melihat banyak pilihan kadang membuat bingung. Ikuti 4 langkah sederhana ini:</p>\r\n<ol start="1">\r\n<li class="ai-optimize-130">\r\n<p class="ai-optimize-131"><strong>Kenali Dirimu:</strong>&nbsp;Kamu lebih punya&nbsp;<strong>waktu</strong>&nbsp;atau&nbsp;<strong>uang</strong>? Apa keahlian unikmu, sekecil apapun itu? Jujurlah pada diri sendiri.</p>\r\n</li>\r\n<li class="ai-optimize-132">\r\n<p class="ai-optimize-133"><strong>Pilih Satu Medan Perang:</strong>&nbsp;Jangan mencoba semua ide sekaligus. Pilih SATU ide yang paling cocok dengan jawabanmu di poin pertama.</p>\r\n</li>\r\n<li class="ai-optimize-134">\r\n<p class="ai-optimize-135"><strong>Riset &amp; Eksekusi Kecil:</strong>&nbsp;Pelajari satu ide itu lebih dalam. Coba buat satu produk digital mini, atau tulis 3 artikel blog, atau investasikan Rp 500.000 dulu di Robo-Advisor. Rasakan prosesnya.</p>\r\n</li>\r\n<li class="ai-optimize-136">\r\n<p class="ai-optimize-137"><strong>Ukur &amp; Kembangkan:</strong>&nbsp;Lihat hasilnya. Apa yang berhasil? Apa yang tidak? Dari sana, kamu bisa memutuskan untuk lanjut, ganti strategi, atau mencoba ide lain.</p>\r\n</li>\r\n</ol>\r\n<p>&nbsp;</p>\r\n<h2 class="ai-optimize-138"><strong>Ini Bukan Sprint, Ini Maraton Menuju Kebebasan</strong></h2>\r\n<p class="ai-optimize-139">Membangun&nbsp;<em>passive income</em>&nbsp;itu seperti lari maraton, bukan lari sprint 100 meter. Butuh kesabaran, konsistensi, dan kemauan untuk belajar dari kegagalan. Pohon mangga tidak akan berbuah dalam semalam.</p>\r\n<p class="ai-optimize-140">Pesan terpenting dari saya:&nbsp;<strong>mulailah sekarang, sekecil apapun itu.</strong></p>\r\n<p class="ai-optimize-141">Masa depan finansialmu yang lebih bebas tidak akan dibangun oleh angan-angan, tapi oleh satu langkah kecil yang kamu ambil hari ini.</p>\r\n<p class="ai-optimize-142"><strong>Rekomendasi Aksi Berdasarkan Profilmu:</strong></p>\r\n<ul>\r\n<li class="ai-optimize-143">\r\n<p class="ai-optimize-144"><strong>Jika Kamu Si Hati-hati (Risk-Averse &amp; Modal Terbatas):</strong>&nbsp;Mulailah dengan&nbsp;<strong>Ide #1 (Produk Digital Mini)</strong>&nbsp;atau&nbsp;<strong>Ide #2 (Affiliate Marketing Hyper-Niche)</strong>. Risikonya hampir nol, hanya butuh investasi waktu dan kreativitasmu.</p>\r\n</li>\r\n<li class="ai-optimize-145">\r\n<p class="ai-optimize-146"><strong>Jika Kamu Si Seimbang (Punya Modal &amp; Sedikit Waktu):</strong>&nbsp;Coba alokasikan sebagian dana ke&nbsp;<strong>Ide #4 (P2P Lending &amp; Robo-Advisor)</strong>. Sambil menunggu &ldquo;uang bekerja untukmu&rdquo;, kamu bisa pelan-pelan membangun&nbsp;<strong>Ide #3 (Konten dengan AI)</strong>.</p>\r\n</li>\r\n<li class="ai-optimize-147">\r\n<p class="ai-optimize-148"><strong>Jika Kamu Si Pemberani (Siap Ambil Risiko &amp; Belajar Hal Baru):</strong>&nbsp;Langsung dalami&nbsp;<strong>Ide #6 (Dropshipping/Print-on-Demand)</strong>&nbsp;atau&nbsp;<strong>Ide #7 (Newsletter Berbayar)</strong>. Potensi keuntungannya besar, tapi butuh dedikasi tinggi dalam pemasaran dan membangun audiens.</p>\r\n</li>\r\n</ul>\r\n<p class="ai-optimize-149">Pilih jalanmu, dan mulailah langkah pertamamu hari ini. Sampai jumpa di puncak&nbsp;<a href="https://www.crevalen.xyz/how-to/financial-freedom-umur-30/">kebebasan finansial</a>!</p>	t	2025-07-06 20:13:15.156	2025-07-06 23:15:29.121	cmcqrdgbf0000ul3cfjchfrxl	\N	\N	cmcs7bqjp0008ul1oemvv8p7y	\N	\N	f	f	\N	\N	\N	\N	\N
cmd38q12j000aulfo3fyfvxa5	apa-itu-zero-sum-game	Zero-Sum Game: Menang atau Kalah? Ini Cara Kerjanya	<p style="text-align: justify;">Bulan lalu, saat saya menghadiri reuni kecil dengan beberapa teman lama, ada satu momen yang begitu membekas. Dua sahabat saya, sebut saja Budi dan Rian, bercerita tentang pencapaian karier mereka. Keduanya bekerja di industri yang sama, bahkan sempat menjadi rival di awal karier. Ketika Rian bercerita tentang promosinya yang gemilang, saya bisa melihat secercah kekecewaan di mata Budi, meskipun ia berusaha tersenyum dan memberi selamat.</p><p style="text-align: justify;">Seolah-olah, kesuksesan Rian adalah sepotong kue yang hilang dari piringnya. Inilah esensi dari sebuah <strong>zero-sum game</strong>, sebuah konsep yang diam-diam mengatur banyak aspek kehidupan kita tanpa kita sadari.</p><p style="text-align: justify;">Pernahkah Anda merasa seperti itu? Merasa bahwa kemenangan orang lain adalah kekalahan Anda? Atau dalam sebuah negosiasi, Anda berpikir satu-satunya cara untuk menang adalah dengan membuat pihak lain rugi? Jika ya, Anda tidak sendirian. Yuk, kita telusuri bersama mengapa pola pikir ini begitu menjebak dan bagaimana kita bisa keluar darinya.</p><p style="text-align: justify;">&nbsp;</p><h4 style="text-align: justify;"><strong>Apa Itu Zero-Sum Game? Definisi Sederhana di Balik Konsep Rumit</strong></h4><p style="text-align: justify;">Bayangkan Anda dan seorang teman memesan satu loyang pizza yang terbagi menjadi delapan potong. Setiap potong yang Anda ambil, berarti teman Anda mendapat lebih sedikit. Jika Anda makan lima potong, teman Anda hanya kebagian tiga. Totalnya tetap delapan. Tidak ada pizza tambahan yang muncul secara ajaib. Keuntungan Anda (+5) adalah kerugian teman Anda (−5), dan jika dijumlahkan, hasilnya nol.</p><p style="text-align: justify;">Itulah analogi paling sederhana untuk menjelaskan&nbsp;<strong>apa itu zero-sum game</strong>. Secara formal,&nbsp;<strong>menurut&nbsp;</strong><a target="_blank" rel="noopener" href="https://www.investopedia.com/"><strong>Investopedia</strong></a>, ini adalah situasi di mana keuntungan satu pihak setara dengan kerugian pihak lain. Sumber daya yang diperebutkan bersifat tetap, terbatas, dan tidak bisa bertambah. Kemenangan satu orang mutlak dibayar oleh kekalahan orang lain.</p><p style="text-align: justify;">Contoh klasiknya adalah permainan seperti catur atau poker. Dalam catur, hanya ada satu pemenang. Tidak ada skenario di mana kedua pemain bisa menang secara bersamaan. Kemenangan si Putih adalah kekalahan si Hitam. Begitu juga dalam poker, uang yang dimenangkan oleh satu pemain berasal langsung dari kantong pemain lain yang kalah di meja yang sama.</p><blockquote><p>Zero-sum game adalah sebuah situasi di mana keuntungan yang didapatkan oleh satu pihak setara dengan kerugian yang dialami oleh pihak lain, karena sumber daya yang diperebutkan bersifat tetap dan terbatas.</p></blockquote><p style="text-align: justify;">&nbsp;</p><h2 style="text-align: justify;"><strong>Bagaimana Cara Kerja Zero-Sum Game dalam Kehidupan Nyata?</strong></h2><p style="text-align: justify;">Konsep ini tidak hanya ada di atas papan catur atau meja judi. Pola pikir ini meresap ke dalam banyak skenario sehari-hari, sering kali tanpa kita sadari.</p><ul><li><p><strong>Promosi Jabatan:</strong>&nbsp;Jika ada satu posisi manajer yang kosong dan dua kandidat yang sama kuat bersaing, maka ini adalah&nbsp;<em>zero-sum game</em>&nbsp;klasik. Hanya satu yang bisa mendapatkan posisi itu; yang lain tidak.</p></li><li><p><strong>Negosiasi Harga:</strong>&nbsp;Saat tawar-menawar harga mobil bekas, setiap seribu rupiah yang berhasil Anda potong dari harga penjual adalah kerugian bagi mereka, dan sebaliknya. "Kue" yang diperebutkan adalah selisih harga.</p></li><li><p><strong>Pasar Saham (Jangka Pendek):</strong>&nbsp;Dalam perdagangan derivatif atau&nbsp;<em>day trading</em>, keuntungan seorang&nbsp;<em>trader</em>&nbsp;sering kali merupakan kerugian&nbsp;<em>trader</em>&nbsp;lain dalam transaksi yang sama di waktu yang sangat singkat.</p></li></ul><p style="text-align: justify;">Masalahnya, kita sering kali salah menerapkan logika ini pada situasi yang sebenarnya tidak terbatas. Inilah yang disebut "jebakan mental zero-sum."</p><p style="text-align: justify;">&nbsp;</p><h2 style="text-align: justify;"><strong>Jebakan Mental: Mengapa Kita Terobsesi dengan Kemenangan Orang Lain?</strong></h2><p style="text-align: justify;">Sebagai jurnalis, saya pernah meliput kisah dua startup teknologi yang bersaing ketat. Alih-alih berkolaborasi, mereka menghabiskan jutaan dolar untuk saling menjatuhkan, mencuri talenta, dan perang harga. Mereka melihat pasar sebagai satu loyang pizza yang tetap. Akhirnya? Keduanya kehabisan dana dan diakuisisi dengan harga murah oleh perusahaan raksasa dari luar negeri. Mereka terlalu fokus pada "mengalahkan" satu sama lain sehingga lupa bahwa mereka bisa "memperbesar kue" bersama.</p><p style="text-align: justify;">Ini terjadi karena otak kita secara alami cenderung menyederhanakan masalah. Berbagai&nbsp;<strong>studi psikologi kognitif</strong>&nbsp;menunjukkan bahwa kita memiliki bias untuk melihat kompetisi sebagai permainan menang-kalah. Ini mungkin sisa-sisa evolusi di mana sumber daya seperti makanan dan tempat berlindung benar-benar terbatas.</p><p style="text-align: justify;">&nbsp;</p><h2 style="text-align: justify;"><strong>Bukan Cuma Kalah-Menang: Mengenal Non-Zero-Sum Game (Win-Win Solution)</strong></h2><p style="text-align: justify;">Sekarang, mari kita bicara tentang skenario yang jauh lebih menarik dan produktif:&nbsp;<em>non-zero-sum game</em>&nbsp;atau&nbsp;<em>positive-sum game</em>. Di sini, "kue"-nya bisa bertambah besar.</p><p style="text-align: justify;">Dalam situasi ini, kemenangan satu pihak tidak harus berarti kekalahan pihak lain. Bahkan, semua pihak bisa sama-sama menang (win-win) atau sama-sama kalah (lose-lose). Konsep ini, yang dipopulerkan oleh ahli matematika&nbsp;<strong>John von Neumann dan Oskar Morgenstern</strong>&nbsp;dalam "Theory of Games and Economic Behavior," adalah fondasi dari hampir semua kemajuan ekonomi dan sosial.</p><p style="text-align: justify;">Contohnya melimpah:</p><ul><li><p><strong>Perdagangan Internasional:</strong>&nbsp;Ketika Indonesia menjual CPO ke Eropa dan membeli mesin dari Jerman, kedua negara mendapatkan sesuatu yang mereka butuhkan. Ekonomi keduanya bertumbuh. Kue pai global menjadi lebih besar.</p></li><li><p><strong>Kolaborasi Tim:</strong>&nbsp;Saat tim Anda bekerja sama dalam sebuah proyek, ide-ide yang dilemparkan akan saling membangun. Hasil akhirnya jauh lebih baik daripada jika setiap anggota bekerja sendiri-sendiri. 1 + 1 bisa menjadi 3.</p></li><li><p><strong>Pendidikan:</strong>&nbsp;Ketika seorang guru membagikan ilmunya kepada murid, sang guru tidak kehilangan pengetahuannya. Sebaliknya, pengetahuan itu berlipat ganda dan menciptakan generasi yang lebih cerdas.</p></li></ul><p style="text-align: justify;">Melihat dunia melalui lensa&nbsp;<em>positive-sum game</em>&nbsp;membuka peluang untuk inovasi, kolaborasi, dan pertumbuhan bersama. Ini adalah tentang&nbsp;<strong>menciptakan nilai baru</strong>, bukan sekadar merebut nilai yang sudah ada.</p><p style="text-align: justify;">&nbsp;</p><h2 style="text-align: justify;"><strong>Apakah Bitcoin Sebuah Zero-Sum Game?</strong></h2><p style="text-align: justify;">Salah satu pertanyaan yang sering saya dapatkan adalah tentang aset digital.&nbsp;<strong>Apakah Bitcoin zero-sum game?</strong>&nbsp;Jawabannya kompleks dan memicu perdebatan sengit.</p><ul><li><p><strong>Argumen "Ya, Itu Zero-Sum":</strong>&nbsp;Kubu ini, yang sering diisi oleh ekonom tradisional seperti&nbsp;<strong>ekonom pemenang Nobel, Paul Krugman</strong>, berpendapat bahwa Bitcoin tidak menghasilkan nilai intrinsik. Ia tidak menghasilkan pendapatan, tidak membayar dividen, dan tidak menciptakan produk atau layanan baru. Nilainya murni berasal dari apa yang orang lain bersedia bayar untuk itu (<em>Tinkerbell effect</em>). Oleh karena itu, keuntungan yang didapat oleh seorang investor yang menjual di harga tinggi secara teoretis berasal dari "kerugian" (atau potensi keuntungan yang hilang) dari orang yang membeli atau tidak menjual pada waktu yang sama. Dalam skala mikro, setiap transaksi jual beli adalah zero-sum.</p></li><li><p><strong>Argumen "Tidak, Itu Positive-Sum":</strong>&nbsp;Di sisi lain, para pendukung kripto berpendapat bahwa melihatnya per transaksi itu picik. Mereka melihat keseluruhan ekosistem Bitcoin sebagai&nbsp;<em>positive-sum game</em>. Mengapa? Karena seiring adopsi meningkat, kepercayaan tumbuh, dan teknologi berkembang, "kue" itu sendiri yaitu total kapitalisasi pasar bisa membesar secara eksponensial. Orang yang membeli di tahun 2015 dan menjual di 2021 bisa sama-sama untung dengan orang yang membeli di 2020 dan menjual di 2024, selama nilai jaringan secara keseluruhan terus bertambah. Mereka tidak merebut nilai dari satu sama lain, tetapi berpartisipasi dalam jaringan yang nilainya sedang tumbuh.</p></li></ul><p style="text-align: justify;">Pandangan saya? Keduanya punya poin valid. Pada level transaksi harian, ia punya elemen zero-sum yang kuat. Namun, pada skala makro dan jangka panjang, potensinya sebagai jaringan global yang&nbsp;<strong>menciptakan nilai baru</strong>&nbsp;(seperti sistem pembayaran alternatif atau penyimpan nilai) membuatnya lebih condong ke arah&nbsp;<em>positive-sum game</em>. Ini adalah contoh sempurna bagaimana sebuah konsep bisa dilihat dari dua sisi yang berbeda.</p><p style="text-align: justify;">&nbsp;</p><h2 style="text-align: justify;"><strong>Tiga Langkah Praktis: Cara Keluar dari Pola Pikir Zero-Sum Game</strong></h2><p style="text-align: justify;">Sekarang, bagaimana cara saya menerapkannya? Ini dia tiga langkah praktis untuk mulai&nbsp;<strong>membangun pola pikir bertumbuh (growth mindset)</strong>&nbsp;dan melepaskan diri dari jebakan zero-sum.</p><ol><li><p><strong>Identifikasi Jebakannya:</strong>&nbsp;Mulailah dengan kesadaran diri. Saat Anda merasa iri dengan kesuksesan teman, atau saat Anda masuk ke sebuah negosiasi dengan mental "harus menang telak", berhenti sejenak. Tanyakan pada diri sendiri: "Apakah sumber daya di sini benar-benar terbatas? Apakah ini pizza dengan delapan potong, atau adonan yang bisa kita buat lebih besar bersama?"</p></li><li><p><strong>Ubah Bingkai Pertanyaan (Reframe):</strong>&nbsp;Alih-alih bertanya, "Bagaimana saya bisa mendapatkan bagian yang lebih besar?", mulailah bertanya, "<strong>Bagaimana kita bisa membuat kue ini lebih besar?</strong>" Dalam negosiasi bisnis, ini bisa berarti mencari area kolaborasi baru. Dalam persaingan karier, ini bisa berarti saling berbagi ilmu untuk meningkatkan kompetensi seluruh tim.</p></li><li><p><strong>Fokus pada Penciptaan Nilai:</strong>&nbsp;Geser fokus Anda dari "mengambil" menjadi "memberi" atau "menciptakan". Dalam karier, fokuslah untuk menjadi sangat berharga sehingga perusahaan menciptakan peran baru untuk Anda. Dalam investasi, carilah aset yang&nbsp;<strong>menciptakan nilai baru</strong>&nbsp;(seperti saham perusahaan inovatif) daripada hanya berspekulasi. Ini adalah inti dari&nbsp;<strong>psikologi di balik keputusan investasi</strong>&nbsp;yang sehat.</p></li></ol><p style="text-align: justify;">&nbsp;</p><h2 style="text-align: justify;"><strong>Kesimpulan: Memilih Papan Catur yang Tepat</strong></h2><p style="text-align: justify;">Kembali ke cerita Budi dan Rian di awal. Setelah obrolan kami, saya menantang Budi untuk melihatnya dari sudut pandang lain. Mungkin promosi Rian membuka pintu bagi Budi untuk berkolaborasi dalam proyek lintas-departemen yang lebih besar. Mungkin kesuksesan Rian adalah bukti bahwa orang dari latar belakang seperti mereka bisa sukses di perusahaan itu sebuah validasi.</p><p style="text-align: justify;">Hidup ini bukanlah satu&nbsp;<strong>zero-sum game</strong>&nbsp;yang panjang. Ia adalah rangkaian dari berbagai permainan. Beberapa memang zero-sum, seperti saat memperebutkan kursi terakhir di kereta. Namun, sebagian besar area terpenting dalam hidup pengetahuan, cinta, kebahagiaan, dan kemakmuran sejati adalah&nbsp;<em>positive-sum game</em>.</p><p style="text-align: justify;">Saya berharap, setelah obrolan kita ini, Anda bisa lebih jeli dalam memilih permainan mana yang ingin Anda mainkan. Berhentilah mencoba merebut potongan pizza terbesar dari orang lain, dan mulailah mengajak mereka untuk memanggang kue yang lebih besar bersama. Karena pada akhirnya, kemenangan yang paling memuaskan bukanlah yang diraih di atas kekalahan orang lain, tetapi yang dirayakan bersama.</p><p style="text-align: justify;">Bagaimana menurut Anda? Pernahkah Anda terjebak dalam pola pikir ini? Silakan tinggalkan komentar di bawah, saya senang sekali bisa berdiskusi lebih lanjut. Bagikan artikel ini jika Anda merasa bermanfaat!</p>	t	2025-07-14 15:10:30.3	2025-07-14 16:49:19.384	cmcqrdgbf0000ul3cfjchfrxl	Zero-sum game adalah sebuah situasi di mana keuntungan yang didapatkan oleh satu pihak setara dengan kerugian yang dialami oleh pihak lain, karena sumber daya yang diperebutkan bersifat tetap dan terbatas.	Zero-Sum Game: Menang atau Kalah? Ini Cara Kerjanya	cmd38q0s60008ulfon1izy3bz			f	f		\N		BlogPosting	\N
cmd4o4yhk0002ulagedu6hjim	6-kesalahan-fatal-yang-sering-dilakukan-freelancer-pemula	6 Kesalahan Fatal yang Sering Dilakukan Freelancer Pemula (dan Cara Menghindarinya!)	<p>Hai, teman-teman freelancer pemula! Saya masih ingat betul hari pertama saya “resmi” nyemplung di dunia freelance, semangat membara, mimpi besar, dan… bingung setengah mati. Saya pikir tinggal duduk manis, nunggu invoice berdatangan, lalu bikin kopi sambil scroll media sosial. Ternyata, realitanya jauh lebih kompleks.</p><p>Banyak freelancer baru yang terjebak pada jebakan-jebakan umum, sampai akhirnya burn out atau pundi-pundi penghasilan yang seharusnya menggembirakan malah mengecewakan. Dalam artikel ini, saya mau membagikan&nbsp;<strong>6 kesalahan paling sering</strong>&nbsp;yang saya (dan banyak teman freelancer) lakukan di awal-awal karier, lengkap dengan&nbsp;<a target="_blank" rel="noopener noreferrer nofollow" href="https://www.crevalen.xyz/category/tips/"><strong><u>tips</u></strong></a><strong>&nbsp;freelance</strong>&nbsp;praktis untuk menghindarinya. Yuk, simak baik-baik agar perjalanan freelance kamu lebih mulus!</p><h2><strong>&nbsp;</strong></h2><h2><strong>Kesalahan 1: Menetapkan Harga Terlalu Rendah</strong></h2><p>Saya pernah men-charge klien pertama saya Rp50.000 per artikel 500 kata padahal riset dan revisinya memakan waktu dua jam lebih. Akibatnya, saya bekerja super keras tapi&nbsp;<em>return</em>–nya jauh dari sepadan. Menetapkan harga terlalu rendah bisa bikin:</p><ul><li><p><strong>Burn out</strong>&nbsp;karena volume kerja meningkat untuk menutup kebutuhan finansial.</p></li><li><p><strong>Persepsi klien</strong>&nbsp;bahwa kualitasmu “murahan”.</p></li><li><p><strong>Sulit menaikkan tarif</strong>&nbsp;di kemudian hari karena klien sudah terbiasa bayar murah.</p></li></ul><h3><strong>Cara Menghindarinya</strong></h3><ol><li><p><strong>Riset Pasar</strong>: Cek marketplace freelance, grup Facebook, atau forum komunitas untuk tahu rata-rata tarif&nbsp;<em>(LSI: tips freelance, tarif freelance)</em>.</p></li><li><p><strong>Hitung Biaya Hidup &amp; Bisnis</strong>: Libatkan biaya listrik, internet, perangkat, dan margin keuntungan minimal.</p></li><li><p><strong>Buat Paket</strong>: Daripada tarif per artikel, tawarkan paket misalnya “3 artikel + revisi” dengan harga khusus.</p></li><li><p><strong>Naikkan Tarif Secara Bertahap</strong>: Setiap 3–6 bulan, lakukan peninjauan harga.</p></li></ol><p><em>“Menurut pengalaman saya, menaikkan tarif sebesar 10–15% setiap beberapa bulan bisa terasa ‘ringan’ bagi klien yang puas, tapi sangat berarti bagi kantongmu.”</em></p><hr><h2><strong>Kesalahan 2: Tidak Memiliki Kontrak atau Scope yang Jelas</strong></h2><p>Bayangkan kamu sudah menyelesaikan proyek, lalu klien minta revisi di luar kesepakatan misalnya menambahkan video atau mendesain ulang 20 slide presentasi. Tanpa&nbsp;<strong>kontrak</strong>&nbsp;atau dokumen&nbsp;<a target="_blank" rel="noopener noreferrer nofollow" href="https://asana.com/id/resources/scope-work-vs-statement-work"><strong><em><u>scope of work</u></em></strong></a>, kamu kesulitan menagih tambahan kerja tersebut. Akhirnya, kerja lembur tanpa kompensasi.</p><h3><strong>Baca Juga:</strong></h3><h3><a target="_blank" rel="noopener noreferrer nofollow" href="https://www.crevalen.xyz/tips/kakeibo-metode-cerdas-menghemat-uang-dari-jepang/"><strong><u>Gaji Sering Habis? Coba Kakeibo, Metode Cerdas Menghemat Uang dari Jepang</u></strong></a></h3><p>&nbsp;</p><h3><strong>&nbsp;</strong></h3><h3><strong>Cara Menghindarinya</strong></h3><ol><li><p><strong>Buat Kontrak Sederhana</strong>: Cantumkan deskripsi layanan, deadline, revisi yang termasuk, dan ketentuan pembayaran.</p></li><li><p><strong>Tegaskan Scope</strong>: Misalnya, “termasuk dua kali revisi, revisi tambahan +RpX.000.”</p></li><li><p><strong>Deposit di Muka</strong>: Minta minimal 30–50% DP agar klien serius.</p></li><li><p><strong>Dokumentasi Komunikasi</strong>: Simpan chat/email sebagai bukti kesepakatan.</p></li></ol><p><em>“Sejak saya menerapkan kontrak sederhana, kasus ‘klien ngambek minta gratisan’ bisa ditekan hingga hampir nol.”</em></p><hr><h2><strong>Kesalahan 3: Komunikasi yang Buruk dengan Klien</strong></h2><p>Komunikasi adalah kunci sukses kerja remote&nbsp;<em>(LSI: kerja remote, komunikasi klien)</em>. Kalau kamu lambat membalas chat, tidak memberi update progress, atau terlalu ‘singkat’ saat menjelaskan teknis, klien bisa jadi ragu, frustrasi, atau buru-buru ‘minta refund’. Bahkan mis-komunikasi kecil bisa berujung reputasi buruk.</p><h3><strong>Cara Menghindarinya</strong></h3><ol><li><p><strong>Tentukan “Office Hour”</strong>: Misalnya, “Saya respons chat Senin–Jumat, jam 09.00–17.00 WIB.”</p></li><li><p><strong>Gunakan Bahasa yang Jelas</strong>: Hindari jargon teknis tanpa penjelasan.</p></li><li><p><strong>Update Berkala</strong>: Buat progress report singkat setiap 2–3 hari.</p></li><li><p><strong>Tanya Kebutuhan dan Harapan</strong>: Tanyakan milestone, look &amp; feel, style guide.</p></li></ol><p><em>“Menurut saya, sedikit effort ekstra di awal (tanya preferensi klien) bisa menghemat puluhan revisi di akhir.”</em></p><hr><h2><strong>Kesalahan 4: Tidak Membangun Portofolio yang Kuat</strong></h2><p>Tanpa&nbsp;<strong>portofolio</strong>, kamu seperti ‘toko kosong’ bagaimana calon klien menilai kualitas kerjamu? Saya pernah menolak proyek besar karena portofolio saya masih “it’s complicated”: ada beberapa tulisan blog gratis, tapi tidak tertata rapi.</p><h3><strong>Cara Menghindarinya</strong></h3><ol><li><p><strong>Buat Website atau Halaman Khusus</strong>: Tampilkan studi kasus dengan hasil konkret (misalnya kenaikan traffic, conversion rate).</p></li><li><p><strong>Gunakan Platform Portofolio</strong>: Behance, Dribbble, GitHub (untuk developer).</p></li><li><p><strong>Update Secara Berkala</strong>: Setiap selesai proyek, tambahkan ke portofolio.</p></li><li><p><strong>Tampilkan Testimonial Klien</strong>: Bukti sosial itu powerful!</p></li></ol><p><em>“Saya ingat pertama kali punya testimonial positif: rasanya seperti dapat ‘golden ticket’ dari Wonka!”</em></p><hr><h2><strong>Kesalahan 5: Mengabaikan Manajemen Waktu dan Deadline</strong></h2><p>Freelancer itu seringkali juga&nbsp;<strong>manajer proyek</strong>&nbsp;untuk dirinya sendiri. Saya dulu sering menunda-nunda, lalu deadline mepet, akhirnya kerja begadang kualitas menurun, burnout menghantui, bahkan beberapa tulisan “tiba-tiba” hilang di folder yang salah.</p><h3><strong>Cara Menghindarinya</strong></h3><ol><li><p><strong>Gunakan To-Do List &amp; Kalender</strong>: Google Calendar, Trello, atau aplikasi keren lain&nbsp;<em>(LSI: manajemen waktu, tips freelance)</em>.</p></li><li><p><strong>Teknik Pomodoro</strong>: Bekerja 25 menit, istirahat 5 menit—membantu fokus.</p></li><li><p><strong>Buffer Time</strong>: Tambahkan 1–2 hari ekstra sebelum deadline.</p></li><li><p><strong>Prioritaskan Tugas</strong>: Gunakan metode Eisenhower (urgent vs. important).</p></li></ol><p><em>“Saya sekarang selalu sisipkan satu hari ‘cadangan’ sebelum deadline; kalau selesai lebih cepat, bisa santai atau pakai waktu ekstra untuk riset lebih mendalam.”</em></p><hr><h2><strong>Kesalahan 6: Kurangnya Pemasaran Diri dan Personal Branding</strong></h2><p>Banyak freelancer pikir “klien akan datang sendiri.” Padahal, tanpa&nbsp;<strong>personal branding</strong>, kamu seperti kapal tanpa mercusuar. Di era&nbsp;<strong>freelance</strong>&nbsp;yang kompetitif, menonjol itu wajib.</p><h3><strong>Cara Menghindarinya</strong></h3><ol><li><p><strong>Optimasi Profil Online</strong>: LinkedIn, Upwork, atau situs portofolio. Gunakan foto profesional, headline yang jelas.</p></li><li><p><strong>Buat Konten Edukatif</strong>: Tulisan blog, video pendek di media sosial tentang tips freelance, case study, atau insight industri.</p></li><li><p><strong>Jaringan (Networking)</strong>: Ikut webinar, grup komunitas, atau acara kopi darat.</p></li><li><p><strong>Minta Referral</strong>: Klien puas adalah “salesperson” terbaik.</p></li></ol><p><em>“Setiap bulan, saya sisihkan waktu satu jam untuk posting LinkedIn tentang proyek yang saya kerjakan—hasilnya, klien baru berdatangan lewat DM!”</em></p><hr><p>Nah, teman-teman, itulah&nbsp;<strong>6 kesalahan krusial</strong>&nbsp;yang kerap menjegal freelancer pemula mulai dari harga terlalu murah, kontrak tak jelas, sampai branding yang terabaikan. Semua ini sebenarnya mudah dihindari jika kita sadar sejak dini dan disiplin menerapkan&nbsp;<a target="_blank" rel="noopener noreferrer nofollow" href="https://www.crevalen.xyz/tips/investasi-pemula-5-langkah-mudah-memulai-investasi/"><strong><u>tips</u></strong></a><strong>&nbsp;freelance</strong>&nbsp;di atas.</p><p>Intinya, treat freelancing like a real business: tetapkan harga layak, bangun sistem kerja yang rapi, jaga komunikasi, dan jangan lupa investasikan waktu untuk personal branding.</p><p>Kalau kamu merasa artikel ini bermanfaat, yuk&nbsp;<strong>bagikan</strong>&nbsp;ke teman-teman freelancer-mu atau tinggalkan komentar tentang kesalahan lain yang pernah kamu alami! Jangan lupa&nbsp;<strong>subscribe</strong>&nbsp;newsletter saya untuk mendapat update tips freelance,&nbsp;<strong>strategi client management</strong>, dan trik SEO khusus freelancer setiap minggu. Sampai jumpa di artikel selanjutnya, dan tetap semangat mengejar kebebasan finansial sebagai freelancer!</p>	t	2025-07-15 15:09:47.259	2025-07-15 15:10:09.998	cmcqrdgbf0000ul3cfjchfrxl			cmd4o4y7c0000ulagdd90t8we			f	f		\N		BlogPosting	\N
\.


--
-- Data for Name: Session; Type: TABLE DATA; Schema: public; Owner: user_dev
--

COPY public."Session" (id, "expiresAt", "userId") FROM stdin;
476eb71f84f8fade38a2be7369af3a14	2025-08-04 21:59:09.303	cmcqrdgbf0000ul3cfjchfrxl
\.


--
-- Data for Name: Setting; Type: TABLE DATA; Schema: public; Owner: user_dev
--

COPY public."Setting" (key, value, "updatedAt") FROM stdin;
site_title	Crevalen | Edukasi Finansial	2025-07-14 15:04:09.829
site_description	Crevalen adalah Blog finansial dan investasi terpercaya. Tips realistis, strategi cerdas, dan panduan praktis membangun aset dari nol.	2025-07-14 15:04:09.829
post_title_template	%post_title% | %site_title%	2025-07-14 15:04:09.829
publisher_name	Crevalen	2025-07-14 15:04:09.829
publisher_logo_url		2025-07-14 15:04:09.829
robots_txt_content	User-agent: *\nAllow: /\n\nSitemap: https://www.crevalen.xyz/sitemap.xml	2025-07-15 15:38:12.507
\.


--
-- Data for Name: Tag; Type: TABLE DATA; Schema: public; Owner: user_dev
--

COPY public."Tag" (id, slug, name, "updatedAt") FROM stdin;
cmcsaiw4c0001ullomc025jv0	testing	Testing	2025-07-07 12:19:21.653
cmd38q12z000culforulfs87z	zero-sum-game	Zero Sum Game	2025-07-14 15:10:30.3
cmd4o4yhp0004ulagsgl5jas4	freelancer	Freelancer	2025-07-15 15:09:47.259
\.


--
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: user_dev
--

COPY public."User" (id, username, "passwordHash", role) FROM stdin;
cmcqrdgbf0000ul3cfjchfrxl	admin	$argon2id$v=19$m=19456,t=2,p=1$TWp7uJfVUjYetJj87q+OYg$TRbAVA+pKNeEwM5YGWVEsJlxwK4WWDkidGFuIxBkKx0	ADMIN
cmd4p3wh30000ulngz0sfvbpt	aldi2512	$argon2id$v=19$m=19456,t=2,p=1$IKgRPAvaEzZGKgp+UsQKRA$9c4s9IHCzbNOhSOX1g9pY/8t7GPyvrE/7JK9z7B28Nk	ADMIN
\.


--
-- Data for Name: _CategoryToPost; Type: TABLE DATA; Schema: public; Owner: user_dev
--

COPY public."_CategoryToPost" ("A", "B") FROM stdin;
cmcsaivpf0000ulloavrwsvsz	cmcs40k2z0001ul5kdspdlm12
cmd38jews0007ulfoq1n85akb	cmd38q12j000aulfo3fyfvxa5
cmcs4orvv0000uli0hmfge9q2	cmd4o4yhk0002ulagedu6hjim
\.


--
-- Data for Name: _PostToTag; Type: TABLE DATA; Schema: public; Owner: user_dev
--

COPY public."_PostToTag" ("A", "B") FROM stdin;
cmcs40k2z0001ul5kdspdlm12	cmcsaiw4c0001ullomc025jv0
cmd38q12j000aulfo3fyfvxa5	cmd38q12z000culforulfs87z
cmd4o4yhk0002ulagedu6hjim	cmd4o4yhp0004ulagsgl5jas4
\.


--
-- Name: Category Category_pkey; Type: CONSTRAINT; Schema: public; Owner: user_dev
--

ALTER TABLE ONLY public."Category"
    ADD CONSTRAINT "Category_pkey" PRIMARY KEY (id);


--
-- Name: Comment Comment_pkey; Type: CONSTRAINT; Schema: public; Owner: user_dev
--

ALTER TABLE ONLY public."Comment"
    ADD CONSTRAINT "Comment_pkey" PRIMARY KEY (id);


--
-- Name: Media Media_pkey; Type: CONSTRAINT; Schema: public; Owner: user_dev
--

ALTER TABLE ONLY public."Media"
    ADD CONSTRAINT "Media_pkey" PRIMARY KEY (id);


--
-- Name: Page Page_pkey; Type: CONSTRAINT; Schema: public; Owner: user_dev
--

ALTER TABLE ONLY public."Page"
    ADD CONSTRAINT "Page_pkey" PRIMARY KEY (id);


--
-- Name: Post Post_pkey; Type: CONSTRAINT; Schema: public; Owner: user_dev
--

ALTER TABLE ONLY public."Post"
    ADD CONSTRAINT "Post_pkey" PRIMARY KEY (id);


--
-- Name: Session Session_pkey; Type: CONSTRAINT; Schema: public; Owner: user_dev
--

ALTER TABLE ONLY public."Session"
    ADD CONSTRAINT "Session_pkey" PRIMARY KEY (id);


--
-- Name: Setting Setting_pkey; Type: CONSTRAINT; Schema: public; Owner: user_dev
--

ALTER TABLE ONLY public."Setting"
    ADD CONSTRAINT "Setting_pkey" PRIMARY KEY (key);


--
-- Name: Tag Tag_pkey; Type: CONSTRAINT; Schema: public; Owner: user_dev
--

ALTER TABLE ONLY public."Tag"
    ADD CONSTRAINT "Tag_pkey" PRIMARY KEY (id);


--
-- Name: User User_pkey; Type: CONSTRAINT; Schema: public; Owner: user_dev
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (id);


--
-- Name: _CategoryToPost _CategoryToPost_AB_pkey; Type: CONSTRAINT; Schema: public; Owner: user_dev
--

ALTER TABLE ONLY public."_CategoryToPost"
    ADD CONSTRAINT "_CategoryToPost_AB_pkey" PRIMARY KEY ("A", "B");


--
-- Name: _PostToTag _PostToTag_AB_pkey; Type: CONSTRAINT; Schema: public; Owner: user_dev
--

ALTER TABLE ONLY public."_PostToTag"
    ADD CONSTRAINT "_PostToTag_AB_pkey" PRIMARY KEY ("A", "B");


--
-- Name: Category_name_key; Type: INDEX; Schema: public; Owner: user_dev
--

CREATE UNIQUE INDEX "Category_name_key" ON public."Category" USING btree (name);


--
-- Name: Category_slug_key; Type: INDEX; Schema: public; Owner: user_dev
--

CREATE UNIQUE INDEX "Category_slug_key" ON public."Category" USING btree (slug);


--
-- Name: Media_key_key; Type: INDEX; Schema: public; Owner: user_dev
--

CREATE UNIQUE INDEX "Media_key_key" ON public."Media" USING btree (key);


--
-- Name: Media_url_key; Type: INDEX; Schema: public; Owner: user_dev
--

CREATE UNIQUE INDEX "Media_url_key" ON public."Media" USING btree (url);


--
-- Name: Page_slug_key; Type: INDEX; Schema: public; Owner: user_dev
--

CREATE UNIQUE INDEX "Page_slug_key" ON public."Page" USING btree (slug);


--
-- Name: Post_featuredImageId_key; Type: INDEX; Schema: public; Owner: user_dev
--

CREATE UNIQUE INDEX "Post_featuredImageId_key" ON public."Post" USING btree ("featuredImageId");


--
-- Name: Post_ogImageId_key; Type: INDEX; Schema: public; Owner: user_dev
--

CREATE UNIQUE INDEX "Post_ogImageId_key" ON public."Post" USING btree ("ogImageId");


--
-- Name: Post_slug_key; Type: INDEX; Schema: public; Owner: user_dev
--

CREATE UNIQUE INDEX "Post_slug_key" ON public."Post" USING btree (slug);


--
-- Name: Tag_name_key; Type: INDEX; Schema: public; Owner: user_dev
--

CREATE UNIQUE INDEX "Tag_name_key" ON public."Tag" USING btree (name);


--
-- Name: Tag_slug_key; Type: INDEX; Schema: public; Owner: user_dev
--

CREATE UNIQUE INDEX "Tag_slug_key" ON public."Tag" USING btree (slug);


--
-- Name: User_username_key; Type: INDEX; Schema: public; Owner: user_dev
--

CREATE UNIQUE INDEX "User_username_key" ON public."User" USING btree (username);


--
-- Name: _CategoryToPost_B_index; Type: INDEX; Schema: public; Owner: user_dev
--

CREATE INDEX "_CategoryToPost_B_index" ON public."_CategoryToPost" USING btree ("B");


--
-- Name: _PostToTag_B_index; Type: INDEX; Schema: public; Owner: user_dev
--

CREATE INDEX "_PostToTag_B_index" ON public."_PostToTag" USING btree ("B");


--
-- Name: Comment Comment_parentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user_dev
--

ALTER TABLE ONLY public."Comment"
    ADD CONSTRAINT "Comment_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES public."Comment"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Comment Comment_postId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user_dev
--

ALTER TABLE ONLY public."Comment"
    ADD CONSTRAINT "Comment_postId_fkey" FOREIGN KEY ("postId") REFERENCES public."Post"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Post Post_authorId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user_dev
--

ALTER TABLE ONLY public."Post"
    ADD CONSTRAINT "Post_authorId_fkey" FOREIGN KEY ("authorId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Post Post_featuredImageId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user_dev
--

ALTER TABLE ONLY public."Post"
    ADD CONSTRAINT "Post_featuredImageId_fkey" FOREIGN KEY ("featuredImageId") REFERENCES public."Media"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Post Post_ogImageId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user_dev
--

ALTER TABLE ONLY public."Post"
    ADD CONSTRAINT "Post_ogImageId_fkey" FOREIGN KEY ("ogImageId") REFERENCES public."Media"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Session Session_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user_dev
--

ALTER TABLE ONLY public."Session"
    ADD CONSTRAINT "Session_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _CategoryToPost _CategoryToPost_A_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user_dev
--

ALTER TABLE ONLY public."_CategoryToPost"
    ADD CONSTRAINT "_CategoryToPost_A_fkey" FOREIGN KEY ("A") REFERENCES public."Category"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _CategoryToPost _CategoryToPost_B_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user_dev
--

ALTER TABLE ONLY public."_CategoryToPost"
    ADD CONSTRAINT "_CategoryToPost_B_fkey" FOREIGN KEY ("B") REFERENCES public."Post"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _PostToTag _PostToTag_A_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user_dev
--

ALTER TABLE ONLY public."_PostToTag"
    ADD CONSTRAINT "_PostToTag_A_fkey" FOREIGN KEY ("A") REFERENCES public."Post"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _PostToTag _PostToTag_B_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user_dev
--

ALTER TABLE ONLY public."_PostToTag"
    ADD CONSTRAINT "_PostToTag_B_fkey" FOREIGN KEY ("B") REFERENCES public."Tag"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

