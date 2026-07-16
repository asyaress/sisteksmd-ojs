{**
 * plugins/themes/sistekModern/templates/frontend/pages/navigationMenuItemViewContent.tpl
 *
 * Theme override for custom navigation menu pages.
 *}
{include file="frontend/components/header.tpl" pageTitleTranslated=$title}
{if empty($jkcReviewerMembers)}{assign var="jkcReviewerMembers" value=[]}{/if}

<div class="page page_information jkc-custom-page">
	{include file="frontend/components/breadcrumbs.tpl" currentTitle=$title}

	{if $jkcInformationPageMode|default:'' == 'reviewer' && $jkcReviewerMembers|@count}
		<section class="jkc-editorial-team-shell jkc-editorial-team-shell--reviewer">
			<p class="jkc-editorial-team-shell__eyebrow">Peer Review Network</p>
			<h1>{$title|escape}</h1>
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
							{if $reviewerMember.scopusId}
								<div class="jkc-editorial-profile__meta">
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
								</div>
							{/if}
						</div>
					</article>
				{/foreach}
			</div>
		</section>
	{else}
		<h1 class="page_title">{$title|escape}</h1>
		<div class="description">
			{$content|strip_unsafe_html}
		</div>
	{/if}
</div>

{include file="frontend/components/footer.tpl"}
