{**
 * plugins/themes/sistekModern/templates/frontend/components/header.tpl
 *
 * Phase 4: Header & Navigation Modernization
 * Safe override of default frontend header.
 *}
{strip}
	{assign var="showingLogo" value=true}
	{if !$displayPageHeaderLogo}
		{assign var="showingLogo" value=false}
	{/if}
{/strip}
<!DOCTYPE html>
<html lang="{$currentLocale|replace:"_":"-"|escape}" xml:lang="{$currentLocale|replace:"_":"-"|escape}">
{if !$pageTitleTranslated}{capture assign="pageTitleTranslated"}{translate key=$pageTitle}{/capture}{/if}
{include file="frontend/components/headerHead.tpl"}
<body class="pkp_page_{$requestedPage|escape|default:"index"} pkp_op_{$requestedOp|escape|default:"index"}{if $showingLogo} has_site_logo{/if} jkc_theme" dir="{$currentLocaleLangDir|escape|default:"ltr"}">

	<div class="pkp_structure_page">
		<header class="pkp_structure_head jkc_site_header" id="headerNavigationContainer" role="banner">
			{include file="frontend/components/skipLinks.tpl"}

			<div class="pkp_head_wrapper">
				<div class="jkc-header-topbar">
					<div class="pkp_navigation_user_wrapper" id="navigationUserWrapper">
						{load_menu name="user" id="navigationUser" ulClass="pkp_navigation_user" liClass="profile"}
					</div>
				</div>

				{assign var="jkcHeaderContext" value=null}
				{if $currentContext}
					{assign var="jkcHeaderContext" value=$currentContext}
				{elseif $currentJournal}
					{assign var="jkcHeaderContext" value=$currentJournal}
				{/if}
				{assign var="jkcHeaderIsHomepage" value=false}
				{if (!$requestedPage || $requestedPage == 'index') && (!$requestedOp || $requestedOp == 'index')}
					{assign var="jkcHeaderIsHomepage" value=true}
				{/if}

				{assign var="headerJournalName" value=$displayPageHeaderTitle}
				{if !$headerJournalName && $jkcHeaderContext}
					{assign var="headerJournalName" value=$jkcHeaderContext->getLocalizedName()}
				{/if}
				{if !$headerJournalName}
					{assign var="headerJournalName" value=$siteTitle}
				{/if}
				{assign var="headerJournalLanguage" value=''}
				{if isset($supportedLocales[$primaryLocale])}
					{assign var="headerJournalLanguage" value=$supportedLocales[$primaryLocale]}
				{/if}
				{assign var="headerPublisher" value=''}
				{assign var="headerFrequency" value=''}
				{assign var="headerOnlineIssn" value=''}
				{assign var="headerDoiPrefix" value=''}
				{assign var="headerDoiEnabled" value=false}
				{assign var="headerDescription" value=''}
				{if $jkcHeaderContext}
					{assign var="headerPublisher" value=$jkcHeaderContext->getData('publisherInstitution')}
					{assign var="headerFrequency" value=$jkcHeaderContext->getData('publicationFrequency')}
					{if !$headerFrequency}
						{assign var="headerFrequency" value=$jkcHeaderContext->getData('frequency')}
					{/if}
					{assign var="headerOnlineIssn" value=$jkcHeaderContext->getData('onlineIssn')}
					{assign var="headerDoiPrefix" value=$jkcHeaderContext->getData('doiPrefix')}
					{assign var="headerDoiEnabled" value=$jkcHeaderContext->getData('enableDois')}
					{assign var="headerDescription" value=$jkcHeaderContext->getLocalizedData('description')|strip_tags|trim}
				{/if}
				{capture assign="homeUrl"}
					{url page="index"}
				{/capture}

				<section class="jkc-header-masthead{if !$jkcHeaderIsHomepage} jkc-header-masthead--compact{/if}" aria-label="Journal identity">
					<div class="jkc-header-masthead__inner">
						<div class="jkc-header-masthead__identity">
							<a href="{$homeUrl|trim|escape}" class="jkc-header-masthead__logo">
								{if $displayPageHeaderLogo}
									<img src="{$publicFilesDir}/{$displayPageHeaderLogo.uploadName|escape:"url"}" width="{$displayPageHeaderLogo.width|escape}" height="{$displayPageHeaderLogo.height|escape}" {if $displayPageHeaderLogo.altText != ''}alt="{$displayPageHeaderLogo.altText|escape}"{else}alt="{$headerJournalName|escape}"{/if} loading="lazy" />
								{else}
									<img src="{$baseUrl}/plugins/themes/sistekModern/assets/images/sistek-logo-placeholder.svg" alt="{$headerJournalName|escape}" loading="lazy" />
								{/if}
							</a>
							<div class="jkc-header-masthead__copy">
								<h2 class="jkc-header-masthead__title">{$headerJournalName|escape}</h2>
								<p class="jkc-header-masthead__description">SISTEK-SMD: sistem informasi, teknologi informasi, ilmu komputer, dan transformasi digital.</p>
								<p class="jkc-header-masthead__issn">eISSN : {if $headerOnlineIssn && $headerOnlineIssn|lower != 'xxxx-xxxx'}{$headerOnlineIssn|escape}{else}-{/if}</p>
								<p class="jkc-header-masthead__issn">pISSN : {if $jkcHeaderContext && $jkcHeaderContext->getData('printIssn') && $jkcHeaderContext->getData('printIssn')|lower != 'xxxx-xxxx'}{$jkcHeaderContext->getData('printIssn')|escape}{else}-{/if}</p>
							</div>
						</div>
					</div>
					<div class="jkc-header-masthead__pattern" aria-hidden="true">
						<img src="{$baseUrl}/plugins/themes/sistekModern/assets/images/jkc-masthead-pattern.svg" alt="" loading="lazy" />
					</div>
				</section>

				{capture assign="primaryMenu"}
					{load_menu name="primary" id="navigationPrimary" ulClass="pkp_navigation_primary"}
				{/capture}

				<nav class="pkp_site_nav_menu jkc_site_nav" aria-label="{translate|escape key='common.navigation.site'}">
					<a id="siteNav"></a>
					<div class="pkp_site_name_wrapper jkc-nav-logo">
						<button class="pkp_site_nav_toggle" aria-label="{translate|escape key='common.navigation.site'}">
							<span>Open Menu</span>
						</button>
					</div>
					<div class="pkp_navigation_primary_row">
						<div class="pkp_navigation_primary_wrapper">
							{$primaryMenu}

							{if $currentContext && $requestedPage !== 'search'}
								<div class="pkp_navigation_search_wrapper">
									<a href="{url page='search'}" class="pkp_search pkp_search_desktop">
										<span class="fa fa-search" aria-hidden="true"></span>
										{translate key="common.search"}
									</a>
								</div>
							{/if}
						</div>
					</div>
				</nav>
			</div>
		</header>

		{if $isFullWidth}
			{assign var=hasSidebar value=0}
		{/if}
		<div class="pkp_structure_content{if $hasSidebar} has_sidebar{/if}">
			<div class="pkp_structure_main" role="main">
				<a id="pkp_content_main"></a>
