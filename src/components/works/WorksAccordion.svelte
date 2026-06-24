<script lang="ts">
import Icon from "@iconify/svelte";

export type WorkItem = {
	slug: string;
	title: string;
	url: string;
	published: string;
	updated?: string;
	description: string;
	image: string;
	tags: string[];
	version: string;
	architecture: string;
	video: string;
	videoPoster: string;
	featured: boolean;
};

type Props = {
	works: WorkItem[];
};

let { works }: Props = $props();
let openSlug = $state("");

function toggle(slug: string) {
	const nextSlug = openSlug === slug ? "" : slug;
	document
		.querySelectorAll<HTMLVideoElement>(".work-preview-video")
		.forEach((video) => {
			video.pause();
		});
	openSlug = nextSlug;
}
</script>

{#if works.length > 0}
	<div class="works-list flex flex-col gap-4">
		{#each works as work, index (work.slug)}
			{@const isOpen = openSlug === work.slug}
			<article
				class="work-panel card-base overflow-hidden rounded-[var(--radius-large)]"
				class:is-open={isOpen}
				style={`animation-delay: calc(var(--content-delay) + ${index * 60}ms);`}
			>
				<button
					type="button"
					class="work-summary group grid w-full grid-cols-1 gap-4 p-4 text-left transition md:grid-cols-[9.5rem_minmax(0,1fr)_2.75rem] md:items-center md:p-5"
					aria-expanded={isOpen}
					aria-controls={`work-panel-${work.slug}`}
					onclick={() => toggle(work.slug)}
				>
					<div class="relative aspect-video overflow-hidden rounded-xl bg-black/10 dark:bg-white/10 md:aspect-[4/3]">
						{#if work.image}
							<img
								src={work.image}
								alt={work.title}
								class="h-full w-full object-cover transition duration-700 group-hover:scale-105"
								loading={index === 0 ? "eager" : "lazy"}
							/>
						{:else}
							<div class="flex h-full w-full items-center justify-center text-[var(--primary)]">
								<Icon icon="material-symbols:work-outline-rounded" class="text-4xl" />
							</div>
						{/if}
						{#if work.featured}
							<div class="absolute left-3 top-3 rounded-md bg-[var(--primary)] px-2 py-1 text-xs font-bold text-white shadow-sm dark:text-black/80">
								精选
							</div>
						{/if}
					</div>

					<div class="min-w-0">
						<div class="mb-2 flex flex-wrap items-center gap-2">
							<h2 class="truncate text-xl font-bold text-black/90 transition group-hover:text-[var(--primary)] dark:text-white/90 md:text-2xl">
								{work.title}
							</h2>
							{#if work.version}
								<span class="rounded-md border border-[var(--line-divider)] bg-[var(--btn-regular-bg)] px-2 py-1 text-xs font-medium text-black/50 dark:text-white/50">
									{work.version}
								</span>
							{/if}
						</div>
						<p class="line-clamp-2 text-sm leading-relaxed text-black/65 dark:text-white/65">
							{work.description}
						</p>
						<div class="mt-3 flex flex-wrap gap-2">
							{#each work.tags.slice(0, 4) as tag}
								<span class="rounded-md bg-[var(--btn-regular-bg)] px-2.5 py-1 text-xs font-medium text-black/45 dark:text-white/45">
									{tag}
								</span>
							{/each}
						</div>
					</div>

					<div class="hidden h-11 w-11 items-center justify-center rounded-xl bg-[var(--btn-regular-bg)] text-[var(--primary)] transition group-hover:bg-[var(--btn-regular-bg-hover)] md:flex">
						<Icon
							icon="material-symbols:keyboard-arrow-down-rounded"
							class={`text-3xl transition duration-300 ${isOpen ? "rotate-180" : ""}`}
						/>
					</div>
				</button>

				<div
					id={`work-panel-${work.slug}`}
					class={`work-detail grid transition-[grid-template-rows] duration-500 ease-out ${isOpen ? "grid-rows-[1fr]" : "grid-rows-[0fr]"}`}
				>
					<div class="min-h-0 overflow-hidden">
						{#if work.video}
							<div class="grid gap-5 border-t border-[var(--line-divider)] p-4 md:grid-cols-[minmax(0,1.45fr)_minmax(16rem,0.75fr)] md:p-5">
								<div class="relative aspect-video overflow-hidden rounded-xl bg-black">
									<video
										class="work-preview-video aspect-video h-full w-full bg-black object-contain"
										src={work.video}
										poster={work.videoPoster || work.image}
										controls
										playsinline
										preload="metadata"
										data-video-ready="false"
										onloadedmetadata={(event) => {
											const video = event.currentTarget;
											video.dataset.videoReady = "true";
										}}
										onerror={(event) => {
											const video = event.currentTarget;
											if (video.dataset.videoReady === "true") return;
											video.classList.add("hidden");
											const overlay = video.nextElementSibling as HTMLElement | null;
											if (overlay) overlay.style.display = "flex";
										}}
									>
										当前浏览器不支持视频播放。
									</video>
									<div class="absolute inset-0 flex items-center justify-center p-4" style="display: none;">
										<div class="flex items-start gap-2 rounded-xl bg-amber-50 p-3 text-xs leading-relaxed text-amber-800 dark:bg-amber-900/30 dark:text-amber-300">
											<Icon icon="material-symbols:info-outline-rounded" class="mt-0.5 flex-shrink-0 text-base" />
											<span>当前视频托管于腾讯云 COS，仅支持中国网络访问。如无法播放，请更换中国网络查看。</span>
										</div>
									</div>
								</div>

								<div class="flex min-w-0 flex-col justify-between gap-5">
									<div class="space-y-4">
										<div>
											<div class="mb-1 text-xs font-bold tracking-wide text-black/35 dark:text-white/35">项目版本</div>
											<div class="text-sm font-medium text-black/80 dark:text-white/80">{work.version || "未标注"}</div>
										</div>
										<div>
											<div class="mb-1 text-xs font-bold tracking-wide text-black/35 dark:text-white/35">项目架构</div>
											<div class="text-sm leading-relaxed text-black/75 dark:text-white/75">{work.architecture || "未标注"}</div>
										</div>
										<div>
											<div class="mb-1 text-xs font-bold tracking-wide text-black/35 dark:text-white/35">项目介绍</div>
											<p class="text-sm leading-relaxed text-black/65 dark:text-white/65">{work.description}</p>
										</div>
									</div>

									<a
										href={work.url}
										class="btn-regular ml-auto inline-flex h-11 items-center gap-2 rounded-xl px-4 text-sm font-bold"
									>
										详细说明
										<Icon icon="material-symbols:arrow-forward-rounded" class="text-xl" />
									</a>
								</div>
							</div>
						{:else}
							<div class="border-t border-[var(--line-divider)] p-4 md:p-5">
								<div class="grid gap-4 md:grid-cols-[minmax(0,1fr)_auto] md:items-end">
									<div class="space-y-4">
										<div class="grid gap-1 md:grid-cols-[5rem_minmax(0,1fr)] md:gap-5">
											<div class="text-xs font-bold leading-6 tracking-wide text-black/35 dark:text-white/35">项目版本</div>
											<div class="text-sm font-medium leading-6 text-black/80 dark:text-white/80">{work.version || "未标注"}</div>
										</div>
										<div class="grid gap-1 md:grid-cols-[5rem_minmax(0,1fr)] md:gap-5">
											<div class="text-xs font-bold leading-6 tracking-wide text-black/35 dark:text-white/35">项目架构</div>
											<div class="text-sm leading-6 text-black/75 dark:text-white/75">{work.architecture || "未标注"}</div>
										</div>
										<div class="grid gap-1 md:grid-cols-[5rem_minmax(0,1fr)] md:gap-5">
											<div class="text-xs font-bold leading-6 tracking-wide text-black/35 dark:text-white/35">项目介绍</div>
											<p class="text-sm leading-6 text-black/65 dark:text-white/65">{work.description}</p>
										</div>
									</div>
									<a
										href={work.url}
										class="btn-regular inline-flex h-11 items-center justify-center gap-2 rounded-xl px-4 text-sm font-bold md:ml-auto"
									>
										详细说明
										<Icon icon="material-symbols:arrow-forward-rounded" class="text-xl" />
									</a>
								</div>
							</div>
						{/if}
					</div>
				</div>
			</article>
		{/each}
	</div>
{:else}
	<div class="card-base rounded-[var(--radius-large)] p-8 text-center md:p-12">
		<div class="mb-3 text-xl font-bold text-[var(--primary)]">作品集筹备中</div>
		<p class="mx-auto max-w-md text-sm leading-relaxed text-black/60 dark:text-white/60">
			作品内容会以 Markdown 维护，并在这里展示项目预览、版本、架构与详细说明。
		</p>
	</div>
{/if}

<style>
	.work-panel {
		animation: work-enter 0.45s ease both;
	}

	.work-panel.is-open {
		border-color: color-mix(in oklch, var(--primary) 42%, var(--line-divider));
	}

	@keyframes work-enter {
		from {
			opacity: 0;
			transform: translateY(10px);
		}
		to {
			opacity: 1;
			transform: translateY(0);
		}
	}

	@media (prefers-reduced-motion: reduce) {
		.work-panel {
			animation: none;
		}
	}
</style>
