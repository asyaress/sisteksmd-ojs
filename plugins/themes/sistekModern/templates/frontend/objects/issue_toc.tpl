{**
 * plugins/themes/sistekModern/templates/frontend/objects/issue_toc.tpl
 *
 * Modernized issue table of contents with prominent issue cover.
 *}
{if !$heading}
	{assign var="heading" value="h2"}
{/if}
{assign var="articleHeading" value="h3"}
{if $heading == "h3"}
	{assign var="articleHeading" value="h4"}
{elseif $heading == "h4"}
	{assign var="articleHeading" value="h5"}
{elseif $heading == "h5"}
	{assign var="articleHeading" value="h6"}
{/if}

{assign var=issueCover value=$issue->getLocalizedCoverImageUrl()}
{if !$issueCover}
	{assign var=issueCover value="`$baseUrl`/plugins/themes/sistekModern/assets/images/sistek-current-issue-cover.svg"}
{/if}

<div class="obj_issue_toc jkc-issue-toc">

	{if !$issue->getPublished()}
		{include file="frontend/components/notification.tpl" type="warning" messageKey="editor.issues.preview"}
	{/if}

	<section class="jkc-issue-hero">
		<div class="jkc-issue-hero__cover">
			{capture assign="defaultAltText"}
				{translate key="issue.viewIssueIdentification" identification=$issue->getIssueIdentification()|escape}
			{/capture}
			<img src="{$issueCover|escape}" alt="{$issue->getLocalizedCoverImageAltText()|escape|default:$defaultAltText}">
		</div>

		<div class="jkc-issue-hero__content">
			<p class="jkc-issue-hero__eyebrow">Current Issue</p>
			<h1 class="jkc-issue-hero__title">{$issueIdentification|escape}</h1>

			<div class="jkc-issue-hero__meta">
				{if $issue->getDatePublished()}
					<span><strong>{translate key="submissions.published"}:</strong> {$issue->getDatePublished()|date_format:$dateFormatShort}</span>
				{/if}

				{assign var=doiObject value=$issue->getData('doiObject')}
				{if $doiObject}
					{assign var="doiUrl" value=$doiObject->getData('resolvingUrl')|escape}
					<span><strong>DOI:</strong> <a href="{$doiUrl|escape}" rel="noopener noreferrer">{$doiUrl|escape}</a></span>
				{/if}
			</div>

			{if $issue->hasDescription()}
				<div class="jkc-issue-hero__description">
					{$issue->getLocalizedDescription()|strip_unsafe_html}
				</div>
			{/if}

			{foreach from=$pubIdPlugins item=pubIdPlugin}
				{assign var=pubId value=$issue->getStoredPubId($pubIdPlugin->getPubIdType())}
				{if $pubId}
					{assign var="resolvingUrl" value=$pubIdPlugin->getResolvingURL($currentJournal->getId(), $pubId)|escape}
					<div class="jkc-issue-hero__pubid">
						<strong>{$pubIdPlugin->getPubIdDisplayType()|escape}:</strong>
						{if $resolvingUrl}
							<a href="{$resolvingUrl|escape}" rel="noopener noreferrer">{$resolvingUrl|escape}</a>
						{else}
							{$pubId|escape}
						{/if}
					</div>
				{/if}
			{/foreach}

			{if $issueGalleys}
				<div class="jkc-issue-hero__galleys">
					<span class="jkc-issue-hero__galleys-label">{translate key="issue.fullIssue"}</span>
					<ul class="galleys_links">
						{foreach from=$issueGalleys item=galley}
							<li>
								{include file="frontend/objects/galley_link.tpl" parent=$issue labelledBy="issueTocGalleyLabel" purchaseFee=$currentJournal->getData('purchaseIssueFee') purchaseCurrency=$currentJournal->getData('currency')}
							</li>
						{/foreach}
					</ul>
				</div>
			{/if}
		</div>
	</section>

	<div class="jkc-issue-sections">
	{foreach name=sections from=$publishedSubmissions item=section}
		{if $section.articles}
			<section class="jkc-issue-section">
				{if $section.title}
					<{$heading} class="jkc-issue-section__title">{$section.title|escape}</{$heading}>
				{/if}
				<ul class="cmp_article_list articles">
					{foreach from=$section.articles item=article}
						<li>
							{include file="frontend/objects/article_summary.tpl" heading=$articleHeading}
						</li>
					{/foreach}
				</ul>
			</section>
		{/if}
	{/foreach}
	</div>
</div>
