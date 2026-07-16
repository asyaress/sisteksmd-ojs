{**
 * plugins/themes/sistekModern/templates/frontend/objects/announcement_summary.tpl
 *
 * Styled announcement summary card for SISTEK Modern Theme.
 *}
{assign var="announcementId" value=$announcement->id}
{capture assign="announcementUrl"}{url page="announcement" op="view" path=$announcementId}{/capture}

<article class="obj_announcement_summary jkc-announcement-summary-card">
	<div class="jkc-announcement-summary-card__icon" aria-hidden="true"></div>
	<div class="jkc-announcement-summary-card__body">
		<div class="jkc-announcement-summary-card__meta">
			{if $announcement->datePosted}
				<span class="jkc-announcement-summary-card__date">
					{$announcement->datePosted->format($dateFormatShort)}
				</span>
			{/if}
		</div>
		<h2 class="jkc-announcement-summary-card__title">
			<a href="{$announcementUrl}">
				{$announcement->getLocalizedData('title')|escape}
			</a>
		</h2>
		<div class="jkc-announcement-summary-card__summary">
			{$announcement->getLocalizedData('descriptionShort')|strip_unsafe_html}
		</div>
		<a href="{$announcementUrl}" class="jkc-announcement-summary-card__more">
			<span aria-hidden="true">{translate key="common.readMore"}</span>
			<span class="pkp_screen_reader">{translate key="common.readMoreWithTitle" title=$announcement->getLocalizedData('title')|escape}</span>
		</a>
	</div>
</article>
