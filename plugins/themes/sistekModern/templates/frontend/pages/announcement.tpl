{**
 * plugins/themes/sistekModern/templates/frontend/pages/announcement.tpl
 *
 * Professional announcement detail page for SISTEK Modern Theme.
 *}
{include file="frontend/components/header.tpl" pageTitleTranslated=$announcement->getLocalizedData('title')|escape}

<div class="page page_announcement jkc-announcement-page">
	{include file="frontend/components/breadcrumbs_announcement.tpl" currentTitle=$announcement->getLocalizedData('title')}

	<section class="jkc-announcement-hero">
		<p class="jkc-announcement-hero__eyebrow">Announcement</p>
		<h1>{$announcement->getLocalizedData('title')|escape}</h1>
		<div class="jkc-announcement-hero__meta">
			{if $announcement->datePosted}
				<span>{$announcement->datePosted->format($dateFormatShort)}</span>
			{/if}
		</div>
	</section>

	{include file="frontend/objects/announcement_full.tpl"}
</div>

{include file="frontend/components/footer.tpl"}
