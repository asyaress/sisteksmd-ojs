{**
 * plugins/themes/sistekModern/templates/frontend/objects/announcement_full.tpl
 *
 * Styled full announcement view for SISTEK Modern Theme.
 *}
<article class="obj_announcement_full jkc-announcement-full-card">
	<div class="jkc-announcement-full-card__meta">
		{if $announcement->datePosted}
			<span class="jkc-announcement-full-card__date">
				{$announcement->datePosted->format($dateFormatShort)}
			</span>
		{/if}
	</div>
	<div class="jkc-announcement-full-card__content">
		{if $announcement->getLocalizedData('description')}
			{$announcement->getLocalizedData('description')|strip_unsafe_html}
		{else}
			{$announcement->getLocalizedData('descriptionShort')|strip_unsafe_html}
		{/if}
	</div>
</article>
