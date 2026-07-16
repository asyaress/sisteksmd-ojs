{**
 * plugins/themes/sistekModern/templates/frontend/pages/issueArchive.tpl
 *
 * Modernized issue archive page.
 *}
{capture assign="pageTitle"}
	{if $prevPage}
		{translate key="archive.archivesPageNumber" pageNumber=$prevPage+1}
	{else}
		{translate key="archive.archives"}
	{/if}
{/capture}
{include file="frontend/components/header.tpl" pageTitleTranslated=$pageTitle}

<div class="page page_issue_archive jkc-archive-page">
	{include file="frontend/components/breadcrumbs.tpl" currentTitle=$pageTitle}

	<section class="jkc-archive-hero">
		<p class="jkc-archive-hero__eyebrow">Issue Archive</p>
		<h1>{$pageTitle|escape}</h1>
		<p class="jkc-archive-hero__summary">Telusuri terbitan Jurnal Sistem Informasi dan Teknologi STMIK Samarinda (SISTEK-SMD), detail publikasi, dan daftar isi setiap edisi.</p>
	</section>

	{if empty($issues)}
		<section class="jkc-archive-empty">
			<p>{translate key="current.noCurrentIssueDesc"}</p>
		</section>
	{else}
		<ul class="issues_archive">
			{foreach from=$issues item="issue"}
				<li>
					{include file="frontend/objects/issue_summary.tpl"}
				</li>
			{/foreach}
		</ul>

		{if $prevPage > 1}
			{capture assign=prevUrl}{url page="issue" op="archive" path=$prevPage}{/capture}
		{elseif $prevPage === 1}
			{capture assign=prevUrl}{url page="issue" op="archive"}{/capture}
		{/if}
		{if $nextPage}
			{capture assign=nextUrl}{url page="issue" op="archive" path=$nextPage}{/capture}
		{/if}
		{include
			file="frontend/components/pagination.tpl"
			prevUrl=$prevUrl
			nextUrl=$nextUrl
			showingStart=$showingStart
			showingEnd=$showingEnd
			total=$total
		}
	{/if}
</div>

{include file="frontend/components/footer.tpl"}
