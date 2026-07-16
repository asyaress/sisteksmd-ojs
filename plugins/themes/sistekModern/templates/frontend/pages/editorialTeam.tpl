{**
 * plugins/themes/sistekModern/templates/frontend/pages/editorialTeam.tpl
 *
 * Theme override for the editorial team page.
 * Rebuilds the raw OJS masthead HTML into a cleaner, profile-based layout.
 *}
{include file="frontend/components/header.tpl" pageTitle="about.editorialTeam"}
{if empty($jkcEditorialTeamMembers)}{assign var="jkcEditorialTeamMembers" value=[]}{/if}

<div class="page page_editorial_team jkc-editorial-team-page">
	{include file="frontend/components/breadcrumbs.tpl" currentTitleKey="about.editorialTeam"}

	<section class="jkc-editorial-team-shell">
		<p class="jkc-editorial-team-shell__eyebrow">Journal Governance</p>
		<h1>{translate key="about.editorialTeam"}</h1>
		<p class="jkc-editorial-team-shell__summary">Tim editorial Jurnal Sistem Informasi dan Teknologi STMIK Samarinda (SISTEK-SMD) yang mengelola mutu ilmiah, proses review, dan arah penerbitan jurnal.</p>
		{include file="frontend/components/editLink.tpl" page="management" op="settings" path="context" anchor="masthead" sectionTitleKey="about.editorialTeam"}

		{if $jkcEditorialTeamMembers|@count}
			<div class="jkc-editorial-team-list" aria-label="Editorial team members">
				{foreach from=$jkcEditorialTeamMembers item=editorMember}
					<article class="jkc-editorial-profile">
						<div class="jkc-editorial-profile__photo">
							<img src="{$editorMember.imageUrl|escape}" alt="{$editorMember.imageAlt|escape}" loading="lazy">
						</div>
						<div class="jkc-editorial-profile__body">
							<h2 class="jkc-editorial-profile__name">{$editorMember.name|escape}</h2>
							<p class="jkc-editorial-profile__role">{$editorMember.role|escape}</p>
							{if $editorMember.affiliation}
								<p class="jkc-editorial-profile__affiliation">{$editorMember.affiliation|escape}</p>
							{/if}
							<div class="jkc-editorial-profile__meta">
								{if $editorMember.scopusId}
									{if $editorMember.scopusUrl}
										<a href="{$editorMember.scopusUrl|escape}" class="jkc-editorial-profile__chip" target="_blank" rel="noopener">
											<span class="fa fa-graduation-cap" aria-hidden="true"></span>
											<span>Scopus</span>
											<strong>{$editorMember.scopusId|escape}</strong>
										</a>
									{else}
										<span class="jkc-editorial-profile__chip">
											<span class="fa fa-graduation-cap" aria-hidden="true"></span>
											<span>Scopus</span>
											<strong>{$editorMember.scopusId|escape}</strong>
										</span>
									{/if}
								{/if}
							</div>
						</div>
					</article>
				{/foreach}
			</div>
		{else}
			<div class="jkc-editorial-team-fallback">
				{$currentContext->getLocalizedData('editorialTeam')|strip_unsafe_html}
			</div>
		{/if}
	</section>
</div>

{include file="frontend/components/footer.tpl"}
