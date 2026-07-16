{**
 * plugins/themes/sistekModern/templates/frontend/pages/information.tpl
 *
 * Theme override for generic information pages.
 * Adds a structured reviewer layout while preserving default rendering elsewhere.
 *}
{if !$contentOnly}
	{include file="frontend/components/header.tpl" pageTitle=$pageTitle}
{/if}
{if empty($jkcReviewerMembers)}{assign var="jkcReviewerMembers" value=[]}{/if}

{if $jkcInformationPageMode|default:'' == 'reviewer'}
	<div class="page page_information page_reviewer_information jkc-editorial-team-page">
		{include file="frontend/components/breadcrumbs.tpl" currentTitleKey=$pageTitle}

		<section class="jkc-editorial-team-shell jkc-editorial-team-shell--reviewer">
			<p class="jkc-editorial-team-shell__eyebrow">Peer Review Network</p>
			<h1>{translate key=$pageTitle}</h1>
			<p class="jkc-editorial-team-shell__summary">Mitra bestari yang mendukung mutu ilmiah, ketelitian evaluasi, dan integritas akademik Jurnal Sistem Informasi dan Teknologi STMIK Samarinda (SISTEK-SMD).</p>
			{include file="frontend/components/editLink.tpl" page="management" op="settings" path="website" anchor="setup/information" sectionTitleKey="manager.website.information"}

			{if $jkcReviewerMembers|@count}
				<div class="jkc-editorial-team-list" aria-label="Reviewer members">
					{foreach from=$jkcReviewerMembers item=reviewerMember}
						<article class="jkc-editorial-profile">
							<div class="jkc-editorial-profile__photo">
								<img src="{$reviewerMember.imageUrl|escape}" alt="{$reviewerMember.imageAlt|escape}" loading="lazy">
							</div>
							<div class="jkc-editorial-profile__body">
								<h2 class="jkc-editorial-profile__name">{$reviewerMember.name|escape}</h2>
								<p class="jkc-editorial-profile__role">{$reviewerMember.role|escape}</p>
								{if $reviewerMember.affiliation}
									<p class="jkc-editorial-profile__affiliation">{$reviewerMember.affiliation|escape}</p>
								{/if}
								<div class="jkc-editorial-profile__meta">
									{if $reviewerMember.scopusId}
										{if $reviewerMember.scopusUrl}
											<a href="{$reviewerMember.scopusUrl|escape}" class="jkc-editorial-profile__chip" target="_blank" rel="noopener">
												<span class="fa fa-graduation-cap" aria-hidden="true"></span>
												<span>Scopus</span>
												<strong>{$reviewerMember.scopusId|escape}</strong>
											</a>
										{else}
											<span class="jkc-editorial-profile__chip">
												<span class="fa fa-graduation-cap" aria-hidden="true"></span>
												<span>Scopus</span>
												<strong>{$reviewerMember.scopusId|escape}</strong>
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
					{$content|strip_unsafe_html}
				</div>
			{/if}
		</section>
	</div>
{else}
	<div class="page page_information">
		{include file="frontend/components/breadcrumbs.tpl" currentTitleKey=$pageTitle}
		<h1>
			{translate key=$pageTitle}
		</h1>
		{include file="frontend/components/editLink.tpl" page="management" op="settings" path="website" anchor="setup/information" sectionTitleKey="manager.website.information"}

		<div class="description">
			{$content|strip_unsafe_html}
		</div>
	</div>
{/if}

{if !$contentOnly}
	{include file="frontend/components/footer.tpl"}
{/if}
