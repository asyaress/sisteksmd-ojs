{**
 * plugins/themes/sistekModern/templates/frontend/objects/article_details.tpl
 *}
{if !$heading}
	{assign var="heading" value="h3"}
{/if}

{if !isset($jkcArticleStats)}
	{assign var="jkcArticleStats" value=['views'=>0,'downloads'=>0,'hasStats'=>false]}
{/if}

{assign var="jkcHasAbstract" value=false}
{if $publication->getLocalizedData('abstract')}
	{assign var="jkcHasAbstract" value=true}
{/if}
{assign var="jkcHasReferences" value=false}
{if $parsedCitations || $publication->getData('citationsRaw')}
	{assign var="jkcHasReferences" value=true}
{/if}
{assign var="jkcHasAuthorsTab" value=$publication->getData('authors')|@count > 0}
{assign var="jkcHasCiteTab" value=$citation|default:false}
{assign var="jkcDefaultTab" value="abstract"}
{if !$jkcHasAbstract}
	{if $jkcHasCiteTab}
		{assign var="jkcDefaultTab" value="cite"}
	{elseif $jkcHasReferences}
		{assign var="jkcDefaultTab" value="references"}
	{elseif $jkcHasAuthorsTab}
		{assign var="jkcDefaultTab" value="authors"}
	{/if}
{/if}

{assign var="jkcCorrespondingAuthor" value=null}
{foreach from=$publication->getData('authors') item=jkcAuthorContact}
	{if $jkcAuthorContact->getData('primaryContact')}
		{assign var="jkcCorrespondingAuthor" value=$jkcAuthorContact}
		{break}
	{/if}
{/foreach}

<article class="obj_article_details jkc-article-details">

	{if $publication->getData('status') !== \PKP\submission\PKPSubmission::STATUS_PUBLISHED}
		<div class="cmp_notification notice jkc-article-notice">
			{capture assign="submissionUrl"}{url page="workflow" op="access" path=$article->getId()}{/capture}
			{translate key="submission.viewingPreview" url=$submissionUrl}
		</div>
	{elseif $currentPublication->getId() !== $publication->getId()}
		<div class="cmp_notification notice jkc-article-notice">
			{capture assign="latestVersionUrl"}{url page="article" op="view" path=$article->getBestId()}{/capture}
			{translate key="submission.outdatedVersion"
				datePublished=$publication->getData('datePublished')|date_format:$dateFormatShort
				urlRecentVersion=$latestVersionUrl|escape
			}
		</div>
	{/if}

	<header class="jkc-article-hero">
		{if $jkcArticleCover.url}
			<div class="jkc-article-hero__cover{if !$jkcArticleCover.hasArticleCover} is-fallback{/if}">
				<img src="{$jkcArticleCover.url|escape}" alt="{$jkcArticleCover.alt|escape}" loading="eager">
			</div>
		{/if}

		<div class="jkc-article-hero__inner">
		<div class="jkc-article-hero__meta">
			<div class="jkc-article-hero__issue-lines">
				{if $issue}
					<div><strong>{$issue->getIssueIdentification()|escape}</strong></div>
					{if $issue->getDatePublished()}
						<div>{translate key="submissions.published"}: {$issue->getDatePublished()|date_format:$dateFormatShort}</div>
					{/if}
				{/if}
				{if $section}
					<div>{$section->getLocalizedTitle()|escape}</div>
				{/if}
			</div>
		</div>

		<h1 class="page_title jkc-article-title">{$publication->getLocalizedTitle(null, 'html')|strip_unsafe_html}</h1>

		{if $publication->getLocalizedData('subtitle')}
			<p class="subtitle jkc-article-subtitle">{$publication->getLocalizedSubTitle(null, 'html')|strip_unsafe_html}</p>
		{/if}

		{if $publication->getData('authors')}
			<p class="jkc-article-authors-line">
				{foreach name="jkcAuthorLine" from=$publication->getData('authors') item=author}
					<strong>{$author->getFullName()|escape}</strong>{if !$smarty.foreach.jkcAuthorLine.last}, {/if}
				{/foreach}
			</p>
			<p class="jkc-article-affiliations-line">
				{foreach name="jkcAffLine" from=$publication->getData('authors') item=author}
					{if $author->getLocalizedData('affiliation')}
						{$author->getLocalizedData('affiliation')|escape}{if !$smarty.foreach.jkcAffLine.last}; {/if}
					{/if}
				{/foreach}
			</p>
		{/if}

		{if $jkcCorrespondingAuthor}
			<p class="jkc-article-corresponding">
				Corresponding Author: <strong>{$jkcCorrespondingAuthor->getFullName()|escape}</strong>
				{if $jkcCorrespondingAuthor->getData('email')}
					<a href="mailto:{$jkcCorrespondingAuthor->getData('email')|escape:'url'}" class="jkc-article-corresponding__email">{$jkcCorrespondingAuthor->getData('email')|escape}</a>
				{/if}
			</p>
		{/if}

		{if $jkcArticleDoiUrl}
			{assign var="doiUrl" value=$jkcArticleDoiUrl|escape}
			<div class="jkc-article-doi-row">
				<div class="jkc-article-doi">
					<span>DOI:</span>
					<a href="{$doiUrl}" target="_blank" rel="noopener noreferrer">{$doiUrl}</a>
				</div>
				<a href="{$doiUrl}" class="jkc-button jkc-button--outline jkc-article-doi-check" target="_blank" rel="noopener noreferrer">Check for updates</a>
			</div>
		{/if}

		<p class="jkc-article-publication-line">
			{if $currentJournal}{$currentJournal->getLocalizedName()|escape}{/if}
			{if $issue} &middot; {$issue->getIssueIdentification()|escape}{/if}
			{if $publication->getData('pages')} &middot; {$publication->getData('pages')|escape}{/if}
		</p>

		{if $publication->getData('datePublished')}
			<p class="jkc-article-published-date">
				Article Published:
				{if $firstPublication->getId() === $publication->getId()}
					{$firstPublication->getData('datePublished')|date_format:$dateFormatShort}
				{else}
					{translate key="submission.updatedOn" datePublished=$firstPublication->getData('datePublished')|date_format:$dateFormatShort dateUpdated=$publication->getData('datePublished')|date_format:$dateFormatShort}
				{/if}
			</p>
		{/if}

		{if $jkcArticleShareUrl}
			{assign var="jkcShareTitle" value=$publication->getLocalizedTitle()|strip_unsafe_html|escape:'url'}
			<section class="jkc-article-share" aria-label="Share article">
				<span class="jkc-article-share__label">&lt; SHARE</span>
				<div class="jkc-article-share__buttons">
					<a class="jkc-share-btn jkc-share-btn--whatsapp" href="https://wa.me/?text={$jkcShareTitle}%20{$jkcArticleShareUrl|escape:'url'}" target="_blank" rel="noopener noreferrer" aria-label="Share on WhatsApp">WA</a>
					<a class="jkc-share-btn jkc-share-btn--facebook" href="https://www.facebook.com/sharer/sharer.php?u={$jkcArticleShareUrl|escape:'url'}" target="_blank" rel="noopener noreferrer" aria-label="Share on Facebook">f</a>
					<a class="jkc-share-btn jkc-share-btn--twitter" href="https://twitter.com/intent/tweet?url={$jkcArticleShareUrl|escape:'url'}&text={$jkcShareTitle}" target="_blank" rel="noopener noreferrer" aria-label="Share on X">X</a>
					<a class="jkc-share-btn jkc-share-btn--linkedin" href="https://www.linkedin.com/sharing/share-offsite/?url={$jkcArticleShareUrl|escape:'url'}" target="_blank" rel="noopener noreferrer" aria-label="Share on LinkedIn">in</a>
					<a class="jkc-share-btn jkc-share-btn--telegram" href="https://t.me/share/url?url={$jkcArticleShareUrl|escape:'url'}&text={$jkcShareTitle}" target="_blank" rel="noopener noreferrer" aria-label="Share on Telegram">TG</a>
				</div>
			</section>
		{/if}
		</div>
	</header>

	<div class="jkc-article-body">
		<div class="jkc-article-main">
			<div class="jkc-article-tabs" data-jkc-article-tabs>
				<nav class="jkc-article-tabs__nav" role="tablist" aria-label="Article sections">
					{if $jkcHasAbstract}
						<button type="button" class="jkc-article-tabs__btn{if $jkcDefaultTab == 'abstract'} is-active{/if}" role="tab" aria-selected="{if $jkcDefaultTab == 'abstract'}true{else}false{/if}" aria-controls="jkc-tab-abstract" id="jkc-tab-btn-abstract" data-tab-target="abstract">
							<span>Abstract</span>
						</button>
					{/if}
					{if $jkcHasCiteTab}
						<button type="button" class="jkc-article-tabs__btn{if $jkcDefaultTab == 'cite'} is-active{/if}" role="tab" aria-selected="{if $jkcDefaultTab == 'cite'}true{else}false{/if}" aria-controls="jkc-tab-cite" id="jkc-tab-btn-cite" data-tab-target="cite">
							<span>Cite</span>
						</button>
					{/if}
					{if $jkcHasReferences}
						<button type="button" class="jkc-article-tabs__btn{if $jkcDefaultTab == 'references'} is-active{/if}" role="tab" aria-selected="{if $jkcDefaultTab == 'references'}true{else}false{/if}" aria-controls="jkc-tab-references" id="jkc-tab-btn-references" data-tab-target="references">
							<span>References</span>
						</button>
					{/if}
					{if $jkcHasAuthorsTab}
						<button type="button" class="jkc-article-tabs__btn{if $jkcDefaultTab == 'authors'} is-active{/if}" role="tab" aria-selected="{if $jkcDefaultTab == 'authors'}true{else}false{/if}" aria-controls="jkc-tab-authors" id="jkc-tab-btn-authors" data-tab-target="authors">
							<span>Authors Details</span>
						</button>
					{/if}
				</nav>

				{if $jkcHasAbstract}
					<section class="jkc-article-tabpanel{if $jkcDefaultTab == 'abstract'} is-active{/if}" id="jkc-tab-abstract" role="tabpanel" aria-labelledby="jkc-tab-btn-abstract" data-tab-panel="abstract"{if $jkcDefaultTab != 'abstract'} hidden{/if}>
						<div class="jkc-article-panel">
							<h2 class="jkc-article-panel__title">{translate key="article.abstract"}</h2>
							<div class="jkc-article-panel__content">{$publication->getLocalizedData('abstract')|strip_unsafe_html}</div>
							{if !empty($publication->getLocalizedData('keywords'))}
								<ul class="jkc-article-keywords__list" aria-label="{translate key="article.subject"|escape}">
									{foreach from=$publication->getLocalizedData('keywords') item="keyword"}
										<li><span class="jkc-keyword-pill">{$keyword|escape}</span></li>
									{/foreach}
								</ul>
							{/if}
						</div>
					</section>
				{/if}

				{if $jkcHasCiteTab}
					<section class="jkc-article-tabpanel{if $jkcDefaultTab == 'cite'} is-active{/if}" id="jkc-tab-cite" role="tabpanel" aria-labelledby="jkc-tab-btn-cite" data-tab-panel="cite"{if $jkcDefaultTab != 'cite'} hidden{/if}>
						<div class="jkc-article-panel">
							<h2 class="jkc-article-panel__title">{translate key="submission.howToCite"}</h2>
							<div class="jkc-article-citation-block">
								<div id="citationOutput" role="region" aria-live="polite">{$citation|strip_unsafe_html}</div>
								{if $citationStyles|@count > 0}
									<div class="citation_formats">
										<button class="citation_formats_button label" aria-controls="cslCitationFormats" aria-expanded="false" data-csl-dropdown="true">
											{translate key="submission.howToCite.citationFormats"}
										</button>
										<div id="cslCitationFormats" class="citation_formats_list" aria-hidden="true">
											<ul class="citation_formats_styles">
												{foreach from=$citationStyles item="citationStyle"}
													<li>
														<a aria-controls="citationOutput" href="{url page="citationstylelanguage" op="get" path=$citationStyle.id params=$citationArgs}" data-load-citation data-json-href="{url page="citationstylelanguage" op="get" path=$citationStyle.id params=$citationArgsJson}">
															{$citationStyle.title|escape}
														</a>
													</li>
												{/foreach}
											</ul>
											{if count($citationDownloads)}
												<div class="label">{translate key="submission.howToCite.downloadCitation"}</div>
												<ul class="citation_formats_styles">
													{foreach from=$citationDownloads item="citationDownload"}
														<li>
															<a href="{url page="citationstylelanguage" op="download" path=$citationDownload.id params=$citationArgs}">
																<span class="fa fa-download"></span>
																{$citationDownload.title|escape}
															</a>
														</li>
													{/foreach}
												</ul>
											{/if}
										</div>
									</div>
								{/if}
							</div>
						</div>
					</section>
				{/if}

				{if $jkcHasReferences}
					<section class="jkc-article-tabpanel{if $jkcDefaultTab == 'references'} is-active{/if}" id="jkc-tab-references" role="tabpanel" aria-labelledby="jkc-tab-btn-references" data-tab-panel="references"{if $jkcDefaultTab != 'references'} hidden{/if}>
						<div class="jkc-article-panel">
							<h2 class="jkc-article-panel__title">{translate key="submission.citations"}</h2>
							<div class="jkc-article-panel__content">
								{if $parsedCitations}
									{foreach from=$parsedCitations item="parsedCitation"}
										<p>{$parsedCitation->getCitationWithLinks()|strip_unsafe_html} {call_hook name="Templates::Article::Details::Reference" citation=$parsedCitation}</p>
									{/foreach}
								{else}
									{$publication->getData('citationsRaw')|escape|nl2br}
								{/if}
							</div>
						</div>
					</section>
				{/if}

				{if $jkcHasAuthorsTab}
					<section class="jkc-article-tabpanel{if $jkcDefaultTab == 'authors'} is-active{/if}" id="jkc-tab-authors" role="tabpanel" aria-labelledby="jkc-tab-btn-authors" data-tab-panel="authors"{if $jkcDefaultTab != 'authors'} hidden{/if}>
						<div class="jkc-article-panel">
							<h2 class="jkc-article-panel__title">{translate key="article.authors"}</h2>
							<ul class="jkc-article-author-details">
								{foreach from=$publication->getData('authors') item=author}
									<li class="jkc-article-author-details__item">
										<strong>{$author->getFullName()|escape}</strong>
										{if $author->getData('primaryContact')} <em>(Corresponding Author)</em>{/if}
										{if $author->getLocalizedData('affiliation')}
											<div>{$author->getLocalizedData('affiliation')|escape}</div>
										{/if}
										{if $author->getData('orcid')}
											<div>
												{if $author->getData('orcidAccessToken')}{$orcidIcon}{/if}
												<a href="{$author->getData('orcid')|escape}" target="_blank" rel="noopener noreferrer">{$author->getData('orcid')|escape}</a>
											</div>
										{/if}
										{if $author->getLocalizedData('biography')}
											<div>{$author->getLocalizedData('biography')|strip_unsafe_html}</div>
										{/if}
									</li>
								{/foreach}
							</ul>
						</div>
					</section>
				{/if}
			</div>

			{call_hook name="Templates::Article::Main"}
		</div>

		<aside class="jkc-article-aside" aria-label="Downloads and article info">
			{if $primaryGalleys}
				<div class="jkc-article-aside-card">
					<h3 class="jkc-article-aside-card__title">{translate key="submission.downloads"}</h3>
					<ul class="jkc-article-galleys">
						{foreach from=$primaryGalleys item=galley}
							<li>
								{include file="frontend/objects/galley_link.tpl" parent=$article publication=$publication galley=$galley purchaseFee=$currentJournal->getData('purchaseArticleFee') purchaseCurrency=$currentJournal->getData('currency')}
							</li>
						{/foreach}
					</ul>
				</div>
			{/if}

			{if $supplementaryGalleys}
				<div class="jkc-article-aside-card">
					<h3 class="jkc-article-aside-card__title">{translate key="submission.additionalFiles"}</h3>
					<ul class="jkc-article-galleys">
						{foreach from=$supplementaryGalleys item=galley}
							<li>
								{include file="frontend/objects/galley_link.tpl" parent=$article publication=$publication galley=$galley isSupplementary="1"}
							</li>
						{/foreach}
					</ul>
				</div>
			{/if}

			<div class="jkc-article-aside-card">
				<h3 class="jkc-article-aside-card__title">Statistic</h3>
				{if $jkcArticleStats.hasStats}
					<div class="jkc-article-stats-metric">
						<span>Read Counter</span>
						<strong>{$jkcArticleStats.views|escape}</strong>
					</div>
					<div class="jkc-article-stats-metric">
						<span>PDF Downloads</span>
						<strong>{$jkcArticleStats.downloads|escape}</strong>
					</div>
				{else}
					<p class="jkc-article-stats-note">{translate key="plugins.themes.default.displayStats.noStats"}</p>
				{/if}
				<p class="jkc-article-stats-note">Download data is available when usage statistics are enabled in this journal.</p>
			</div>

			{if $publication->getData('licenseUrl')}
				<div class="jkc-article-aside-card">
					<h3 class="jkc-article-aside-card__title">{translate key="submission.license"}</h3>
					<div class="jkc-article-license-compact">
						{if $publication->getLocalizedData('copyrightHolder')}
							<p>{translate key="submission.copyrightStatement" copyrightHolder=$publication->getLocalizedData('copyrightHolder') copyrightYear=$publication->getData('copyrightYear')}</p>
						{/if}
						{if $ccLicenseBadge}{$ccLicenseBadge}{/if}
					</div>
				</div>
			{/if}

			{if $publication->getLocalizedData('dataAvailability')}
				<div class="jkc-article-aside-card">
					<h3 class="jkc-article-aside-card__title">{translate key="submission.dataAvailability"}</h3>
					<div>{$publication->getLocalizedData('dataAvailability')|strip_unsafe_html}</div>
				</div>
			{/if}

			{if count($article->getPublishedPublications()) > 1}
				<div class="jkc-article-aside-card">
					<h3 class="jkc-article-aside-card__title">{translate key="submission.versions"}</h3>
					<ul class="jkc-article-versions">
						{foreach from=array_reverse($article->getPublishedPublications()) item=iPublication}
							{capture assign="name"}{translate key="submission.versionIdentity" datePublished=$iPublication->getData('datePublished')|date_format:$dateFormatShort version=$iPublication->getData('version')}{/capture}
							<li>
								{if $iPublication->getId() === $publication->getId()}
									{$name|escape}
								{elseif $iPublication->getId() === $currentPublication->getId()}
									<a href="{url page="article" op="view" path=$article->getBestId()}">{$name|escape}</a>
								{else}
									<a href="{url page="article" op="view" path=$article->getBestId()|to_array:"version":$iPublication->getId()}">{$name|escape}</a>
								{/if}
							</li>
						{/foreach}
					</ul>
				</div>
			{/if}
		</aside>
	</div>
</article>
