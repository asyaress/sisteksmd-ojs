{**
 * SISTEK Modern Theme footer override.
 * Professional journal footer while preserving OJS-native routes.
 *}

	</div><!-- pkp_structure_main -->

	{if empty($isFullWidth)}
		{capture assign="sidebarCode"}{call_hook name="Templates::Common::Sidebar"}{/capture}
		{if $sidebarCode}
			<div class="pkp_structure_sidebar left" role="complementary">
				{$sidebarCode|strip_unsafe_html}
				{if !empty($jkcSidebarRenderEnhancements) && $requestedPage != 'index'}
					{include file="frontend/components/sidebarInner.tpl"}
				{/if}
			</div>
		{/if}
	{/if}
</div><!-- pkp_structure_content -->

{if $currentContext}
	{assign var="jkcFooterTitle" value=$currentContext->getLocalizedName()}
	{assign var="jkcFooterPublisher" value=$currentContext->getData('publisherInstitution')}
	{assign var="jkcFooterContactName" value=$currentContext->getData('contactName')}
	{assign var="jkcFooterContactEmail" value=$currentContext->getData('contactEmail')}
	{assign var="jkcFooterSupportName" value=$currentContext->getData('supportName')}
	{assign var="jkcFooterSupportEmail" value=$currentContext->getData('supportEmail')}
	{assign var="jkcFooterOnlineIssn" value=$currentContext->getData('onlineIssn')}
	{assign var="jkcFooterPrintIssn" value=$currentContext->getData('printIssn')}
{else}
	{assign var="jkcFooterTitle" value=$siteTitle}
	{assign var="jkcFooterPublisher" value=''}
	{assign var="jkcFooterContactName" value=''}
	{assign var="jkcFooterContactEmail" value=''}
	{assign var="jkcFooterSupportName" value=''}
	{assign var="jkcFooterSupportEmail" value=''}
	{assign var="jkcFooterOnlineIssn" value=''}
	{assign var="jkcFooterPrintIssn" value=''}
{/if}

{capture assign="jkcFooterHomeUrl"}{url page="index"}{/capture}
{capture assign="jkcFooterCurrentIssueUrl"}{url page='issue' op='current'}{/capture}
{capture assign="jkcFooterArchiveUrl"}{url page='issue' op='archive'}{/capture}
{capture assign="jkcFooterSubmissionsUrl"}{url page='about' op='submissions'}{/capture}
{capture assign="jkcFooterEditorialUrl"}{url page='about' op='editorialMasthead'}{/capture}
{capture assign="jkcFooterContactUrl"}{url page='about' op='contact'}{/capture}
{capture assign="jkcFooterPrivacyUrl"}{url page='about' op='privacy'}{/capture}
{capture assign="jkcFooterAboutSystemUrl"}{url page='about' op='aboutThisPublishingSystem'}{/capture}
{capture assign="jkcFooterSearchUrl"}{url page='search'}{/capture}

<div class="pkp_structure_footer_wrapper jkc-footer" role="contentinfo">
	<a id="pkp_content_footer"></a>

	<div class="pkp_structure_footer jkc-footer__inner">
		<div class="jkc-footer__main">
			<section class="jkc-footer__identity">
				<a href="{$jkcFooterHomeUrl|trim|escape}" class="jkc-footer__identity-logo">
					{if $displayPageHeaderLogo}
						<img src="{$publicFilesDir}/{$displayPageHeaderLogo.uploadName|escape:"url"}" width="{$displayPageHeaderLogo.width|escape}" height="{$displayPageHeaderLogo.height|escape}" {if $displayPageHeaderLogo.altText != ''}alt="{$displayPageHeaderLogo.altText|escape}"{else}alt="{$jkcFooterTitle|escape}"{/if} loading="lazy">
					{else}
						<img src="{$baseUrl}/plugins/themes/sistekModern/assets/images/sistek-logo.png" alt="{$jkcFooterTitle|escape}" loading="lazy">
					{/if}
				</a>
				{if $jkcFooterPublisher}
					<p class="jkc-footer__publisher">{$jkcFooterPublisher|escape}</p>
				{/if}
				<div class="jkc-footer__issn">
					<span>eISSN: {if $jkcFooterOnlineIssn && $jkcFooterOnlineIssn|lower != 'xxxx-xxxx'}{$jkcFooterOnlineIssn|escape}{else}In progress{/if}</span>
					<span>pISSN: {if $jkcFooterPrintIssn && $jkcFooterPrintIssn|lower != 'xxxx-xxxx'}{$jkcFooterPrintIssn|escape}{else}In progress{/if}</span>
				</div>
			</section>

			<section class="jkc-footer__card">
				<h3>Contact</h3>
				<ul class="jkc-footer__meta">
					{if $jkcFooterContactName}
						<li><strong>Contact:</strong> {$jkcFooterContactName|escape}</li>
					{/if}
					{if $jkcFooterContactEmail}
						<li><strong>Email:</strong> <a href="mailto:{$jkcFooterContactEmail|escape:'url'}">{$jkcFooterContactEmail|escape}</a></li>
					{/if}
					{if $jkcFooterSupportName}
						<li><strong>Support:</strong> {$jkcFooterSupportName|escape}</li>
					{/if}
					{if $jkcFooterSupportEmail}
						<li><strong>Support Email:</strong> <a href="mailto:{$jkcFooterSupportEmail|escape:'url'}">{$jkcFooterSupportEmail|escape}</a></li>
					{/if}
				</ul>
			</section>

			<nav class="jkc-footer__card" aria-label="Journal footer links">
				<h3>Quick Links</h3>
				<ul class="jkc-footer__links">
					<li><a href="{$jkcFooterHomeUrl|trim|escape}">Home</a></li>
					<li><a href="{$jkcFooterCurrentIssueUrl|trim|escape}">Current Issue</a></li>
					<li><a href="{$jkcFooterArchiveUrl|trim|escape}">Archives</a></li>
					<li><a href="{$jkcFooterSubmissionsUrl|trim|escape}">Author Guidelines</a></li>
					<li><a href="{$jkcFooterEditorialUrl|trim|escape}">Editorial Team</a></li>
					<li><a href="{$jkcFooterSearchUrl|trim|escape}">Search</a></li>
				</ul>
			</nav>
		</div>

		<div class="jkc-footer__bottom">
			<div class="jkc-footer__bottom-copy">
				<p>&copy; {$smarty.now|date_format:"%Y"} {$jkcFooterTitle|escape}.</p>
				<div class="jkc-footer__bottom-links">
					<a href="{$jkcFooterContactUrl|trim|escape}">Contact</a>
					<a href="{$jkcFooterPrivacyUrl|trim|escape}">Privacy Statement</a>
					<a href="{$jkcFooterAboutSystemUrl|trim|escape}">{translate key="about.aboutThisPublishingSystem"}</a>
				</div>
			</div>
		</div>
	</div>
</div>

</div><!-- pkp_structure_page -->

{load_script context="frontend"}

{call_hook name="Templates::Common::Footer::PageFooter"}
</body>
</html>
