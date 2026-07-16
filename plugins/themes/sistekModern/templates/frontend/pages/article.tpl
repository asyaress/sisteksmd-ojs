{**
 * plugins/themes/sistekModern/templates/frontend/pages/article.tpl
 *
 * Modernized article landing page wrapper.
 *}
{include file="frontend/components/header.tpl" pageTitleTranslated=$article->getCurrentPublication()->getLocalizedFullTitle(null, 'html')|strip_unsafe_html}

<div class="page page_article jkc-article-page">
	{if $section}
		{include file="frontend/components/breadcrumbs_article.tpl" currentTitle=$section->getLocalizedTitle()}
	{else}
		{include file="frontend/components/breadcrumbs_article.tpl" currentTitleKey="common.publication"}
	{/if}

	{include file="frontend/objects/article_details.tpl"}

	{include file="frontend/objects/article_recommendation_sliders.tpl"}
</div>

{include file="frontend/components/footer.tpl"}
