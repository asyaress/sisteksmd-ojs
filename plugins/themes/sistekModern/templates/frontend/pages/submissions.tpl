{**
 * plugins/themes/sistekModern/templates/frontend/pages/submissions.tpl
 *
 * Modernized submissions page for JKC theme.
 * Keeps native OJS content, but restructures presentation into clean editorial panels.
 *}
{include file="frontend/components/header.tpl" pageTitle="about.submissions"}

{assign var="hasAuthorGuidelines" value=$currentContext->getLocalizedData('authorGuidelines')}
{assign var="hasCopyrightNotice" value=$currentContext->getLocalizedData('copyrightNotice')}
{assign var="hasPrivacyStatement" value=$currentContext->getLocalizedData('privacyStatement')}
{assign var="hasChecklist" value=$submissionChecklist}

<div class="page page_submissions jkc-submissions-page">
	{include file="frontend/components/breadcrumbs.tpl" currentTitleKey="about.submissions"}

	<section class="jkc-submissions-hero">
		<div class="jkc-submissions-hero__intro">
			<p class="jkc-submissions-hero__eyebrow">Submission Information</p>
			<h1>{translate key="about.submissions"}</h1>
			<p class="jkc-submissions-hero__summary">Review the journal requirements, manuscript preparation checklist, and publication policies before starting your submission.</p>
		</div>

		<div class="jkc-submissions-hero__notice">
			{if $sections|@count == 0 || $currentContext->getData('disableSubmissions')}
				<div class="jkc-submissions-notice jkc-submissions-notice--muted">
					<p>{translate key="author.submit.notAccepting"}</p>
				</div>
			{else}
				{if $isUserLoggedIn}
					{capture assign="newSubmission"}{url page="submission"}{/capture}
					{capture assign="viewSubmissions"}{url page="submissions"}{/capture}
					<div class="jkc-submissions-notice jkc-submissions-notice--ready">
						<div class="jkc-submissions-notice__body">
							<h2>Ready to submit?</h2>
							<p>You can start a new manuscript submission or review your existing submissions from the author dashboard.</p>
						</div>
						<div class="jkc-submissions-notice__actions">
							<a href="{$newSubmission|escape}" class="jkc-button jkc-button--primary">New Submission</a>
							<a href="{$viewSubmissions|escape}" class="jkc-button jkc-button--outline">View Submissions</a>
						</div>
					</div>
				{else}
					{capture assign="loginUrl"}{url page="login"}{/capture}
					{capture assign="registerUrl"}{url page="user" op="register"}{/capture}
					<div class="jkc-submissions-notice jkc-submissions-notice--login">
						<div class="jkc-submissions-notice__body">
							<h2>Online submission access</h2>
							<p>Please sign in or create an author account to continue with manuscript submission.</p>
						</div>
						<div class="jkc-submissions-notice__actions">
							<a href="{$loginUrl|escape}" class="jkc-button jkc-button--primary">Login</a>
							<a href="{$registerUrl|escape}" class="jkc-button jkc-button--outline">Register</a>
						</div>
					</div>
				{/if}
			{/if}
		</div>
	</section>

	<div class="jkc-submissions-toc" aria-label="Submission page sections">
		{if $hasAuthorGuidelines}<a href="#authorGuidelines">Author Guidelines</a>{/if}
		{if $hasChecklist}<a href="#submissionPreparationChecklist">Preparation Checklist</a>{/if}
		{foreach from=$sections item="section"}{if $section->getLocalizedPolicy()}<a href="#sectionPolicy{$section->getId()|escape}">{$section->getLocalizedTitle()|escape}</a>{/if}{/foreach}
		{if $hasCopyrightNotice}<a href="#copyrightNotice">Copyright</a>{/if}
		{if $hasPrivacyStatement}<a href="#privacyStatement">Privacy</a>{/if}
	</div>

	<div class="jkc-submissions-sections">
		{if $hasAuthorGuidelines}
			<section class="jkc-submission-panel author_guidelines" id="authorGuidelines">
				<div class="jkc-submission-panel__head">
					<h2>{translate key="about.authorGuidelines"}</h2>
					{include file="frontend/components/editLink.tpl" page="management" op="settings" path="workflow" anchor="submission/instructions" sectionTitleKey="about.authorGuidelines"}
				</div>
				<div class="jkc-submission-panel__content">
					{$currentContext->getLocalizedData('authorGuidelines')|strip_unsafe_html}
				</div>
			</section>
		{/if}

		{if $submissionChecklist}
			<section class="jkc-submission-panel submission_checklist" id="submissionPreparationChecklist">
				<div class="jkc-submission-panel__head">
					<h2>{translate key="about.submissionPreparationChecklist"}</h2>
					{include file="frontend/components/editLink.tpl" page="management" op="settings" path="workflow" anchor="submission/instructions" sectionTitleKey="about.submissionPreparationChecklist"}
				</div>
				<div class="jkc-submission-panel__content">
					{$submissionChecklist|strip_unsafe_html}
				</div>
			</section>
		{/if}

		{foreach from=$sections item="section"}
			{if $section->getLocalizedPolicy()}
				<section class="jkc-submission-panel section_policy" id="sectionPolicy{$section->getId()|escape}">
					<div class="jkc-submission-panel__head">
						<h2>{$section->getLocalizedTitle()|escape}</h2>
					</div>
					<div class="jkc-submission-panel__content">
						{$section->getLocalizedPolicy()|strip_unsafe_html}
						{if $isUserLoggedIn}
							{capture assign="sectionSubmissionUrl"}{url page="submission" sectionId=$section->getId()}{/capture}
							<p class="jkc-submission-panel__section-link">
								{translate key="about.onlineSubmissions.submitToSection" name=$section->getLocalizedTitle() url=$sectionSubmissionUrl}
							</p>
						{/if}
					</div>
				</section>
			{/if}
		{/foreach}

		{if $hasCopyrightNotice}
			<section class="jkc-submission-panel copyright_notice" id="copyrightNotice">
				<div class="jkc-submission-panel__head">
					<h2>{translate key="about.copyrightNotice"}</h2>
					{include file="frontend/components/editLink.tpl" page="management" op="settings" path="workflow" anchor="submission/authorGuidelines" sectionTitleKey="about.copyrightNotice"}
				</div>
				<div class="jkc-submission-panel__content">
					{$currentContext->getLocalizedData('copyrightNotice')|strip_unsafe_html}
				</div>
			</section>
		{/if}

		{if $hasPrivacyStatement}
			<section class="jkc-submission-panel privacy_statement" id="privacyStatement">
				<div class="jkc-submission-panel__head">
					<h2>{translate key="about.privacyStatement"}</h2>
					{include file="frontend/components/editLink.tpl" page="management" op="settings" path="website" anchor="setup/privacy" sectionTitleKey="about.privacyStatement"}
				</div>
				<div class="jkc-submission-panel__content">
					{$currentContext->getLocalizedData('privacyStatement')|strip_unsafe_html}
				</div>
			</section>
		{/if}
	</div>
</div><!-- .page -->

{include file="frontend/components/footer.tpl"}
