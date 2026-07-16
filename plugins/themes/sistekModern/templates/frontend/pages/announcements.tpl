{**
 * plugins/themes/sistekModern/templates/frontend/pages/announcements.tpl
 *
 * Professional announcement listing for SISTEK Modern Theme.
 *}
{include file="frontend/components/header.tpl" pageTitle="announcement.announcements"}
{if empty($announcementsIntroduction)}{assign var="announcementsIntroduction" value=''}{/if}

<div class="page page_announcements jkc-announcements-page">
	{include file="frontend/components/breadcrumbs.tpl" currentTitleKey="announcement.announcements"}

	<section class="jkc-announcements-hero">
		<p class="jkc-announcements-hero__eyebrow">Journal Updates</p>
		<h1>{translate key="announcement.announcements"}</h1>
		<p class="jkc-announcements-hero__summary">Informasi resmi, pembaruan penerbitan, dan komunikasi editorial dari Jurnal Sistem Informasi dan Teknologi STMIK Samarinda (SISTEK-SMD).</p>
		{include file="frontend/components/editLink.tpl" page="management" op="settings" path="announcements" anchor="announcements" sectionTitleKey="announcement.announcements"}
	</section>

	{if $announcementsIntroduction|trim}
		<section class="jkc-announcements-intro">
			<div class="jkc-announcements-intro__content">
				{$announcementsIntroduction|strip_unsafe_html}
			</div>
		</section>
	{/if}

	<section class="jkc-announcements-list-wrap">
		{include file="frontend/components/announcements.tpl"}
	</section>
</div>

{include file="frontend/components/footer.tpl"}
