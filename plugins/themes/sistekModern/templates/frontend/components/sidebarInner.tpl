{**
 * Inner-page sidebar enhancement for SISTEK Modern Theme.
 * Keeps Primary Menu from OJS, then adds minimal custom support panels.
 *}
{if !empty($jkcSidebarEditorialMembers)}
	<section class="jkc-sidebar-panel jkc-sidebar-panel--editorial" aria-labelledby="jkcSidebarEditorial">
		<div class="jkc-sidebar-panel__header">
			<h2 id="jkcSidebarEditorial">Meet Our Editorial Team</h2>
		</div>
		<div class="jkc-sidebar-panel__body jkc-sidebar-editorial">
			{foreach from=$jkcSidebarEditorialMembers item=member}
				<article class="jkc-sidebar-editorial__item">
					<div class="jkc-sidebar-editorial__photo">
						<img src="{$member.imageUrl|escape}" alt="{$member.imageAlt|escape}" loading="lazy">
					</div>
					<div class="jkc-sidebar-editorial__content">
						<h3>{$member.name|escape}</h3>
						<p class="jkc-sidebar-editorial__role">{$member.role|escape}</p>
						{if $member.affiliation}
							<p class="jkc-sidebar-editorial__affiliation">{$member.affiliation|escape}</p>
						{/if}
						{if $member.scopusId}
							<p class="jkc-sidebar-editorial__meta">
								<span>Scopus ID</span>
								{if $member.scopusUrl}
									<a href="{$member.scopusUrl|escape}" target="_blank" rel="noopener">{$member.scopusId|escape}</a>
								{else}
									{$member.scopusId|escape}
								{/if}
							</p>
						{/if}
					</div>
				</article>
			{/foreach}
			<a class="jkc-sidebar-panel__action" href="{$jkcSidebarEditorialUrl|escape}">Read More</a>
		</div>
	</section>
{/if}

{if $jkcSidebarTemplateLink}
	<section class="jkc-sidebar-panel jkc-sidebar-panel--template" aria-labelledby="jkcSidebarTemplate">
		<div class="jkc-sidebar-panel__header">
			<h2 id="jkcSidebarTemplate">Journal Template</h2>
		</div>
		<a class="jkc-sidebar-template" href="{$jkcSidebarTemplateLink|escape}" target="_blank" rel="noopener">
			<span class="jkc-sidebar-template__icon" aria-hidden="true">
				<svg viewBox="0 0 24 24" focusable="false"><path d="M7 3h7l5 5v13a1 1 0 0 1-1 1H7a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2zm7 1.5V9h4.5" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/><path d="M9 13h6M9 17h6" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/></svg>
			</span>
			<span class="jkc-sidebar-template__body">
				<strong>Download Template</strong>
				<span>Use the official manuscript template for submissions.</span>
			</span>
		</a>
	</section>
{/if}

{if !empty($jkcSidebarTools)}
	<section class="jkc-sidebar-panel jkc-sidebar-panel--tools" aria-labelledby="jkcSidebarTools">
		<div class="jkc-sidebar-panel__header">
			<h2 id="jkcSidebarTools">Required Tools</h2>
		</div>
		<div class="jkc-sidebar-tools">
			{foreach from=$jkcSidebarTools item=tool}
				<a class="jkc-sidebar-tools__item" href="{$tool.href|escape}" target="_blank" rel="noopener">
					{if $tool.imageExists}
						<img src="{$tool.imageUrl|escape}" alt="{$tool.name|escape}" loading="lazy">
					{else}
						<span>{$tool.name|escape}</span>
					{/if}
				</a>
			{/foreach}
		</div>
	</section>
{/if}

{if !empty($jkcSidebarPublisher)}
	<section class="jkc-sidebar-panel jkc-sidebar-panel--publisher" aria-labelledby="jkcSidebarPublisher">
		<div class="jkc-sidebar-panel__header">
			<h2 id="jkcSidebarPublisher">Publisher</h2>
		</div>
		<div class="jkc-sidebar-publisher">
			<div class="jkc-sidebar-publisher__logo">
				<img src="{$jkcSidebarPublisher.imageUrl|escape}" alt="{$jkcSidebarPublisher.name|escape}" loading="lazy">
			</div>
			<p>{$jkcSidebarPublisher.name|escape}</p>
		</div>
	</section>
{/if}

{if !empty($jkcSidebarStats)}
	<section class="jkc-sidebar-panel jkc-sidebar-panel--stats" aria-labelledby="jkcSidebarStats">
		<div class="jkc-sidebar-panel__header">
			<h2 id="jkcSidebarStats">Web Statistics</h2>
		</div>
		<div class="jkc-sidebar-stats">
			{foreach from=$jkcSidebarStats item=stat}
				<div class="jkc-sidebar-stats__item">
					<strong>{$stat.value|escape}</strong>
					<span>{$stat.label|escape}</span>
				</div>
			{/foreach}
		</div>
	</section>
{/if}

{if !empty($jkcSidebarVolumes)}
	<section class="jkc-sidebar-panel jkc-sidebar-panel--volumes" aria-labelledby="jkcSidebarVolumes">
		<div class="jkc-sidebar-panel__header">
			<h2 id="jkcSidebarVolumes">Published Volumes</h2>
		</div>
		<div class="jkc-sidebar-volumes">
			{foreach from=$jkcSidebarVolumes item=volume}
				<details class="jkc-sidebar-volumes__year"{if $volume.open} open{/if}>
					<summary>{$volume.year|escape}</summary>
					<ul>
						{foreach from=$volume.items item=issueItem}
							<li><a href="{$issueItem.url|escape}">{$issueItem.title|escape}</a></li>
						{/foreach}
					</ul>
				</details>
			{/foreach}
		</div>
	</section>
{/if}

{if !empty($jkcSidebarKeywords)}
	<section class="jkc-sidebar-panel jkc-sidebar-panel--keywords" aria-labelledby="jkcSidebarKeywords">
		<div class="jkc-sidebar-panel__header">
			<h2 id="jkcSidebarKeywords">Keywords</h2>
		</div>
		<div class="jkc-sidebar-keywords">
			{foreach from=$jkcSidebarKeywords item=keyword}
				<span>{$keyword|escape}</span>
			{/foreach}
		</div>
	</section>
{/if}
