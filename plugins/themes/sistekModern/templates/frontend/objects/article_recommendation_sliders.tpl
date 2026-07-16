{**
 * plugins/themes/sistekModern/templates/frontend/objects/article_recommendation_sliders.tpl
 *
 * Cover-first horizontal sliders for related articles.
 *}
{if empty($jkcArticleRecommendationSliders)}{assign var="jkcArticleRecommendationSliders" value=[]}{/if}
{if $jkcArticleRecommendationSliders|@count}
	<section class="jkc-article-rec-zone" aria-label="Related articles">
		{foreach from=$jkcArticleRecommendationSliders item=slider}
			<div class="jkc-article-rec-showcase" data-jkc-rec-slider="{$slider.key|escape}">
				<div class="jkc-article-rec-showcase__head">
					<h3 class="jkc-article-rec-showcase__title">{$slider.title|escape}</h3>
					{if $slider.items|@count > 1}
						<div class="jkc-article-rec-showcase__controls">
							<button type="button" class="jkc-slider-arrow jkc-slider-arrow--prev" data-track="jkc-rec-track-{$slider.key|escape}" aria-label="Previous articles"></button>
							<button type="button" class="jkc-slider-arrow jkc-slider-arrow--next" data-track="jkc-rec-track-{$slider.key|escape}" aria-label="Next articles"></button>
						</div>
					{/if}
				</div>

				<div class="jkc-article-rec-track-wrap">
					<div class="jkc-article-rec-track" id="jkc-rec-track-{$slider.key|escape}" tabindex="0">
						{foreach from=$slider.items item=articleItem}
							{assign var=recArticle value=$articleItem.article}
							{assign var=recPublication value=$recArticle->getCurrentPublication()}
							{assign var=recTitle value=$recPublication->getLocalizedTitle(null, 'html')|strip_unsafe_html}

							<article class="jkc-rec-cover-card">
								<a class="jkc-rec-cover-card__image" href="{url page='article' op='view' path=$articleItem.articlePath}">
									<img src="{$articleItem.thumbnailUrl|escape}" alt="{$articleItem.thumbnailAlt|escape}" loading="lazy">
								</a>
								<div class="jkc-rec-cover-card__body">
									<h4 class="jkc-rec-cover-card__title">
										<a href="{url page='article' op='view' path=$articleItem.articlePath}">{$recTitle}</a>
									</h4>
									{if $articleItem.authorString}
										<p class="jkc-rec-cover-card__authors">{$articleItem.authorString|escape}</p>
									{/if}
									{if $articleItem.issueIdentification}
										<p class="jkc-rec-cover-card__issue">{$articleItem.issueIdentification|escape}</p>
									{/if}
								</div>
							</article>
						{/foreach}
					</div>
				</div>

				{if $slider.searchUrl}
					<p class="jkc-article-rec-showcase__footer">
						{capture assign="jkcAdvancedSearchLink"}
							<a href="{$slider.searchUrl|escape}">{translate key="plugins.generic.recommendBySimilarity.advancedSearch"}</a>
						{/capture}
						{translate key="plugins.generic.recommendBySimilarity.advancedSearchIntro" advancedSearchLink=$jkcAdvancedSearchLink}
					</p>
				{/if}
			</div>
		{/foreach}
	</section>
{/if}
