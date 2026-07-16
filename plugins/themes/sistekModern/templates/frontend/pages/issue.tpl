{**
 * plugins/themes/sistekModern/templates/frontend/pages/issue.tpl
 *
 * Modernized issue landing page.
 *}
{include file="frontend/components/header.tpl" pageTitleTranslated=$issueIdentification}

<div class="page page_issue jkc-issue-page">

	{if !$issue}
		{include file="frontend/components/breadcrumbs_issue.tpl" currentTitleKey="current.noCurrentIssue"}
		<section class="jkc-issue-empty">
			<h1>{translate key="current.noCurrentIssue"}</h1>
			{include file="frontend/components/notification.tpl" type="warning" messageKey="current.noCurrentIssueDesc"}
		</section>
	{else}
		{include file="frontend/components/breadcrumbs_issue.tpl" currentTitle=$issueIdentification}
		{include file="frontend/objects/issue_toc.tpl"}
	{/if}
</div>

{include file="frontend/components/footer.tpl"}
