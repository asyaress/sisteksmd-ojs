{**
 * plugins/themes/sistekModern/templates/frontend/objects/issue_summary.tpl
 *
 * Modernized issue summary card with issue cover fallback.
 *}
{if $issue->getShowTitle()}
	{assign var=issueTitle value=$issue->getLocalizedTitle()}
{/if}
{assign var=issueSeries value=$issue->getIssueSeries()}
{assign var=issueCover value=$issue->getLocalizedCoverImageUrl()}
{if !$issueCover}
	{assign var=issueCover value="`$baseUrl`/plugins/themes/sistekModern/assets/images/sistek-current-issue-cover.svg"}
{/if}

<div class="obj_issue_summary jkc-issue-summary-card">
	<div class="jkc-issue-summary-card__row">
		<a class="cover" href="{url op="view" path=$issue->getBestIssueId()}">
			<img src="{$issueCover|escape}" alt="{$issue->getLocalizedCoverImageAltText()|escape|default:$issueIdentification|default:''}">
		</a>

		<div class="jkc-issue-summary-card__body">
			<h2>
				<a class="title" href="{url op="view" path=$issue->getBestIssueId()}">
					{if $issueTitle}
						{$issueTitle|escape}
					{else}
						{$issueSeries|escape}
					{/if}
				</a>
			</h2>

			{if $issueTitle && $issueSeries}
				<div class="series">{$issueSeries|escape}</div>
			{/if}

			{if $issue->getDatePublished()}
				<div class="jkc-issue-summary-card__published">
					<strong>{translate key="submissions.published"}:</strong> {$issue->getDatePublished()|date_format:$dateFormatShort}
				</div>
			{/if}

			<div class="description">
				{$issue->getLocalizedDescription()|strip_unsafe_html|truncate:260:"..."}
			</div>

			<a class="jkc-issue-summary-card__action" href="{url op="view" path=$issue->getBestIssueId()}">
				View Issue
			</a>
		</div>
	</div>
</div>
