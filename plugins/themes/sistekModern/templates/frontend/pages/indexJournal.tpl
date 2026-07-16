{**
 * plugins/themes/sistekModern/templates/frontend/pages/indexJournal.tpl
 *
 * Phase 5U-A: Unify-Inspired Top Grid
 *}
{include file="frontend/components/header.tpl" pageTitleTranslated=$currentJournal->getLocalizedName()}

{assign var="jkcThemeAssets" value="`$baseUrl`/plugins/themes/sistekModern/assets"}
{if empty($jkcHomepageArticleSections)}{assign var="jkcHomepageArticleSections" value=[]}{/if}
{if empty($jkcEditorialPickItems)}{assign var="jkcEditorialPickItems" value=[]}{/if}
{if empty($jkcHomepageTools)}{assign var="jkcHomepageTools" value=[]}{/if}
{if empty($jkcHomepageContactCards)}{assign var="jkcHomepageContactCards" value=[]}{/if}
{if empty($jkcHomepageStats)}{assign var="jkcHomepageStats" value=[]}{/if}
{if empty($announcements)}{assign var="announcements" value=[]}{/if}
{assign var="journalDescriptionText" value=$currentContext->getLocalizedData('description')|strip_tags|trim}
{assign var="journalLanguage" value=''}
{if isset($supportedLocales[$primaryLocale])}
	{assign var="journalLanguage" value=$supportedLocales[$primaryLocale]}
{/if}

{assign var="publisherInstitution" value=$currentContext->getData('publisherInstitution')}
{assign var="publicationFrequency" value=$currentContext->getData('publicationFrequency')}
{if !$publicationFrequency}
	{assign var="publicationFrequency" value=$currentContext->getData('frequency')}
{/if}
{assign var="onlineIssn" value=$currentContext->getData('onlineIssn')}
{assign var="doiPrefix" value=$currentContext->getData('doiPrefix')}
{assign var="doiEnabled" value=$currentContext->getData('enableDois')}

{if $isUserLoggedIn}
	{capture assign="submitManuscriptUrl"}{url page="submission"}{/capture}
{else}
	{capture assign="submitManuscriptUrl"}{url page="submissions"}{/capture}
{/if}
{capture assign="currentIssueUrl"}{url page="issue" op="current"}{/capture}
{capture assign="authorGuidelinesUrl"}{url page="about" op="submissions"}#authorGuidelines{/capture}
{capture assign="aboutJournalUrl"}{url page='about'}{/capture}

<div class="page_index_journal jkc-home jkc-homepage jkc-prototype-home">

	{call_hook name="Templates::Index::journal"}

	<div class="jkc-unify-top jkc-prototype-grid">
		<section class="jkc-feature-banner jkc-center" aria-label="Journal feature banner">
			<div class="jkc-feature-banner__hero">
				<div class="jkc-feature-banner__slider" aria-hidden="true">
					<div class="jkc-feature-banner__slide">
						<img src="{$jkcThemeAssets}/images/feature-slide-1.png" alt="" loading="lazy">
					</div>
					<div class="jkc-feature-banner__slide">
						<img src="{$jkcThemeAssets}/images/feature-slide-2.png" alt="" loading="lazy">
					</div>
					<div class="jkc-feature-banner__slide">
						<img src="{$jkcThemeAssets}/images/feature-slide-3.png" alt="" loading="lazy">
					</div>
				</div>
				<div class="jkc-feature-banner__overlay" aria-hidden="true"></div>
				<div class="jkc-feature-banner__body">
					<p class="jkc-feature-banner__eyebrow">Peer-Reviewed &middot; Open Access</p>
					<h1 class="jkc-feature-banner__title">Memajukan riset komputasi cerdas</h1>
					<p class="jkc-feature-banner__subtitle">Publikasi penelitian orisinal di bidang AI, ilmu data, IoT, pengolahan citra, dan keamanan komputer.</p>
					<div class="jkc-feature-banner__actions">
						<a href="{$currentIssueUrl|escape}" class="jkc-button jkc-button--primary">Current Issue</a>
						<a href="{$aboutJournalUrl|escape}" class="jkc-button jkc-button--outline">Read More</a>
					</div>
				</div>
			</div>
			<div class="jkc-feature-banner__dots" aria-hidden="true">
				<span class="is-active"></span><span></span><span></span>
			</div>
			<div class="jkc-feature-banner__about">
				<h2 class="jkc-panel__title">About Journal</h2>
				<div class="jkc-about-journal__rule" aria-hidden="true"></div>
				{if $journalDescriptionText}
					<p class="jkc-about-journal__text">{$journalDescriptionText|escape}</p>
				{else}
					<p class="jkc-about-journal__text">Journal description will appear here when available.</p>
				{/if}
				<a href="{$aboutJournalUrl|escape}" class="jkc-button jkc-button--ghost">Read More</a>
			</div>
		</section>

		<aside class="jkc-action-rail jkc-right-rail" aria-label="Submission and quick actions">
			<a href="{$submitManuscriptUrl|escape}" class="jkc-submit-card">
				<div class="jkc-action-card__icon" aria-hidden="true">
					<img src="{$jkcThemeAssets}/icons/submission.svg" alt="" loading="lazy">
				</div>
				<span>Make Submission</span>
			</a>

			{if $jkcJournalTemplateLink}
				<a href="{$jkcJournalTemplateLink|escape}" class="jkc-template-card" target="_blank" rel="noopener noreferrer">
					<div class="jkc-action-card__icon" aria-hidden="true">
						<img src="{$jkcThemeAssets}/icons/pdf.svg" alt="" loading="lazy">
					</div>
					<div class="jkc-template-card__copy">
						<strong>Journal Template</strong>
						<span>Download manuscript template</span>
					</div>
				</a>
			{/if}

			<section class="jkc-action-card jkc-card">
				<h2 class="jkc-panel__title">Author Resources</h2>
				<ul class="jkc-compact-links">
					<li><a href="{$authorGuidelinesUrl|escape}">Author Guidelines</a></li>
					<li><a href="{url page='about' op='submissions'}#submissionPreparationChecklist">Submission Checklist</a></li>
					<li><a href="{url page='peer-review'}">Peer-Review Process</a></li>
					<li><a href="{url page='ethics'}">Publication Ethics</a></li>
				</ul>
			</section>

			<section class="jkc-action-card jkc-card">
				<h2 class="jkc-panel__title">Meet Our Editorial Team</h2>
				<p class="jkc-action-card__text">View complete editorial board and journal management team.</p>
				<a href="{url page='about' op='editorialMasthead'}" class="jkc-button jkc-button--outline">View Editorial Team</a>
			</section>
		</aside>

		<aside class="jkc-left-rail" aria-label="Current issue and journal facts">
			<section class="jkc-issue-rail-card jkc-card" id="homepageIssue">
				<h2 class="jkc-panel__title">Current Issue</h2>
				{if $issue}
					{capture assign="issueViewUrl"}{url page="issue" op="view" path=$issue->getBestIssueId()}{/capture}
					{assign var="issueCover" value=$issue->getLocalizedCoverImageUrl()}
					<div class="jkc-issue-rail-card__cover">
						{if $issueCover}
							{assign var="issueCoverAlt" value=$issue->getLocalizedCoverImageAltText()|default:$issue->getIssueIdentification()}
							<a href="{$issueViewUrl|escape}">
								<img src="{$issueCover|escape}" alt="{$issueCoverAlt|escape}" loading="lazy">
							</a>
						{else}
							<a href="{$issueViewUrl|escape}">
								<img src="{$jkcThemeAssets}/images/sistek-current-issue-cover.svg" alt="{$issue->getIssueIdentification()|strip_unsafe_html|escape}" loading="lazy">
							</a>
						{/if}
					</div>

					<p class="jkc-issue-rail-card__issue-id">{$issue->getIssueIdentification()|strip_unsafe_html}</p>
					{if $issue->getDatePublished()}
						<p class="jkc-issue-rail-card__date">Published {$issue->getDatePublished()|date_format:$dateFormatShort}</p>
					{/if}
					<a href="{$issueViewUrl|escape}" class="jkc-button jkc-button--outline">View Current Issue</a>
				{else}
					<p class="jkc-issue-rail-card__empty">Current issue will appear here once published.</p>
				{/if}

				<ul class="jkc-journal-facts">
					{if $publisherInstitution}<li><strong>Publisher:</strong> {$publisherInstitution|escape}</li>{/if}
					{if $journalLanguage}<li><strong>Language:</strong> {$journalLanguage|escape}</li>{/if}
					{if $publicationFrequency}<li><strong>Frequency:</strong> {$publicationFrequency|escape}</li>{/if}
					{if $doiEnabled}
						<li><strong>DOI:</strong> {if $doiPrefix}{$doiPrefix|escape}{else}Enabled{/if}</li>
					{/if}
					{if $onlineIssn && $onlineIssn|lower != 'xxxx-xxxx'}
						<li><strong>e-ISSN:</strong> {$onlineIssn|escape}</li>
					{else}
						<li><strong>e-ISSN:</strong> In progress</li>
					{/if}
				</ul>
			</section>
		</aside>

	</div>

	<section class="jkc-info-strip" aria-label="Journal menu and indexing">
		<div class="jkc-info-strip__main">
			<div class="jkc-policy-grid">
				<article class="jkc-policy-card">
					<span class="jkc-policy-card__icon" aria-hidden="true"></span>
					<h2><a href="{url page='about' op='editorialMasthead'}">Editorial Team</a></h2>
					<p>Kenali dewan editor dan pengelola jurnal yang mendukung proses publikasi ilmiah JKC.</p>
					<a class="jkc-policy-card__more" href="{url page='about' op='editorialMasthead'}">read more</a>
				</article>
				<article class="jkc-policy-card">
					<span class="jkc-policy-card__icon" aria-hidden="true"></span>
					<h2><a href="{url page='reviewer'}">Reviewer</a></h2>
					<p>Informasi reviewer, kontribusi penelaahan, dan dukungan kualitas naskah jurnal.</p>
					<a class="jkc-policy-card__more" href="{url page='reviewer'}">read more</a>
				</article>
				<article class="jkc-policy-card">
					<span class="jkc-policy-card__icon" aria-hidden="true"></span>
					<h2><a href="{url page='focusnscope'}">Focus and Scope</a></h2>
					<p>Ruang lingkup publikasi meliputi komputasi cerdas, data, jaringan, IoT, dan rekayasa perangkat lunak.</p>
					<a class="jkc-policy-card__more" href="{url page='focusnscope'}">read more</a>
				</article>
				<article class="jkc-policy-card">
					<span class="jkc-policy-card__icon" aria-hidden="true"></span>
					<h2><a href="{url page='ethics'}">Publication Ethics</a></h2>
					<p>Pedoman etika publikasi untuk menjaga integritas, transparansi, dan tanggung jawab akademik.</p>
					<a class="jkc-policy-card__more" href="{url page='ethics'}">read more</a>
				</article>
				<article class="jkc-policy-card">
					<span class="jkc-policy-card__icon" aria-hidden="true"></span>
					<h2><a href="{url page='about' op='submissions'}#authorGuidelines">Author Guidelines</a></h2>
					<p>Panduan penulis untuk format naskah, metadata, dan proses pengiriman artikel.</p>
					<a class="jkc-policy-card__more" href="{url page='about' op='submissions'}#authorGuidelines">read more</a>
				</article>
				<article class="jkc-policy-card">
					<span class="jkc-policy-card__icon" aria-hidden="true"></span>
					<h2><a href="{url page='peer-review'}">Peer-Review Process</a></h2>
					<p>Alur review sejawat yang membantu memastikan kualitas dan kesesuaian artikel.</p>
					<a class="jkc-policy-card__more" href="{url page='peer-review'}">read more</a>
				</article>
				<article class="jkc-policy-card">
					<span class="jkc-policy-card__icon" aria-hidden="true"></span>
					<h2><a href="{url page='about' op='submissions'}#copyrightNotice">Copyright Notice</a></h2>
					<p>Informasi hak cipta, lisensi, dan ketentuan penggunaan artikel yang diterbitkan.</p>
					<a class="jkc-policy-card__more" href="{url page='about' op='submissions'}#copyrightNotice">read more</a>
				</article>
				<article class="jkc-policy-card">
					<span class="jkc-policy-card__icon" aria-hidden="true"></span>
					<h2><a href="{url page='publication-charge'}">Article Publication Charge</a></h2>
					<p>Informasi biaya publikasi artikel, jika berlaku, untuk proses editorial dan penerbitan.</p>
					<a class="jkc-policy-card__more" href="{url page='publication-charge'}">read more</a>
				</article>
				<article class="jkc-policy-card">
					<span class="jkc-policy-card__icon" aria-hidden="true"></span>
					<h2><a href="{url page='open-access'}">Open-Access Policy</a></h2>
					<p>Kebijakan akses terbuka untuk memperluas keterbacaan dan dampak riset komputasi.</p>
					<a class="jkc-policy-card__more" href="{url page='open-access'}">read more</a>
				</article>
				<article class="jkc-policy-card">
					<span class="jkc-policy-card__icon" aria-hidden="true"></span>
					<h2><a href="{url page='plagiarism'}">Plagiarism Policy</a></h2>
					<p>Kebijakan pemeriksaan kemiripan untuk menjaga orisinalitas dan etika akademik.</p>
					<a class="jkc-policy-card__more" href="{url page='plagiarism'}">read more</a>
				</article>
				<article class="jkc-policy-card">
					<span class="jkc-policy-card__icon" aria-hidden="true"></span>
					<h2><a href="{url page='indexing'}">Indexing</a></h2>
					<p>Daftar layanan pengindeksan dan abstraksi yang terkait dengan jurnal.</p>
					<a class="jkc-policy-card__more" href="{url page='indexing'}">read more</a>
				</article>
				<article class="jkc-policy-card">
					<span class="jkc-policy-card__icon" aria-hidden="true"></span>
					<h2><a href="{url page='about' op='contact'}">Contact</a></h2>
					<p>Informasi kontak pengelola jurnal untuk korespondensi editorial dan administrasi.</p>
					<a class="jkc-policy-card__more" href="{url page='about' op='contact'}">read more</a>
				</article>
			</div>
		</div>

		<aside class="jkc-info-strip__side" aria-label="Indexing and tools">
			<section class="jkc-index-card">
				<h2>Indexed In</h2>
				<div class="jkc-index-logos" aria-label="Journal indexing list">
					<img src="{$jkcThemeAssets}/images/indexing/Logo-Google-Scholar.png" alt="Google Scholar" loading="lazy">
					<img src="{$jkcThemeAssets}/images/indexing/logo-crossref.png" alt="Crossref" loading="lazy">
					<img src="{$jkcThemeAssets}/images/indexing/logo-dimensions.png" alt="Dimensions" loading="lazy">
					<img src="{$jkcThemeAssets}/images/indexing/logo-garuda.png" alt="GARUDA Garba Rujukan Digital" loading="lazy">
					<img src="{$jkcThemeAssets}/images/indexing/logo-world-cat.png" alt="WorldCat" loading="lazy">
				</div>
				<a class="jkc-index-card__more" href="{url page='indexing'}">More Indexing</a>
			</section>
			<section class="jkc-index-card jkc-index-card--tools">
				<h2>Tools</h2>
				<div class="jkc-tools-list" aria-label="Writing and research support tools">
					{foreach from=$jkcHomepageTools item=tool}
						<a href="{$tool.href|escape}" class="jkc-tool-item" target="_blank" rel="noopener noreferrer">
							{if $tool.imageExists}
								<img src="{$tool.imageUrl|escape}" alt="{$tool.name|escape}" loading="lazy">
							{else}
								<span class="jkc-tool-item__placeholder">{$tool.name|escape}</span>
							{/if}
						</a>
					{/foreach}
				</div>
			</section>
		</aside>
	</section>

	{if !empty($jkcHomepageArticleSections)}
			<section class="jkc-articles-showcase" aria-labelledby="jkcHomepageArticlesHeading">
			<div class="jkc-section-heading">
				<h2 id="jkcHomepageArticlesHeading">Articles</h2>
			</div>

			<div class="jkc-articles-tabs" role="tablist" aria-label="Article discovery sections">
				{foreach from=$jkcHomepageArticleSections item=articleSection name=articleTabs}
					<button
						type="button"
						class="jkc-articles-tab{if $smarty.foreach.articleTabs.first} is-active{/if}"
						role="tab"
						id="jkc-tab-{$articleSection.key|escape}"
						data-target="jkc-panel-{$articleSection.key|escape}"
						aria-controls="jkc-panel-{$articleSection.key|escape}"
						aria-selected="{if $smarty.foreach.articleTabs.first}true{else}false{/if}"
					>
						<span class="jkc-articles-tab__icon" aria-hidden="true"></span>
						<span>{$articleSection.title|escape}</span>
					</button>
				{/foreach}
			</div>

			<div class="jkc-articles-panels">
				{foreach from=$jkcHomepageArticleSections item=articleSection name=articlePanels}
					<section
						class="jkc-articles-panel{if $smarty.foreach.articlePanels.first} is-active{/if}"
						id="jkc-panel-{$articleSection.key|escape}"
						role="tabpanel"
						aria-labelledby="jkc-tab-{$articleSection.key|escape}"
						{if !$smarty.foreach.articlePanels.first}hidden{/if}
					>
						<div class="jkc-articles-panel__head">
							<div>
								<h3 class="jkc-articles-panel__title">{$articleSection.title|escape} Articles</h3>
								<p class="jkc-articles-panel__hint"></p>
							</div>
							<div class="jkc-articles-panel__controls">
								<button type="button" class="jkc-slider-arrow jkc-slider-arrow--prev" data-track="jkc-track-{$articleSection.key|escape}" aria-label="Previous articles"></button>
								<button type="button" class="jkc-slider-arrow jkc-slider-arrow--next" data-track="jkc-track-{$articleSection.key|escape}" aria-label="Next articles"></button>
							</div>
						</div>

						{if !empty($articleSection.items)}
							<div class="jkc-articles-track-wrap">
								<div class="jkc-articles-track" id="jkc-track-{$articleSection.key|escape}" tabindex="0">
									{foreach from=$articleSection.items item=articleItem}
										{assign var=article value=$articleItem.article}
										{assign var=publication value=$article->getCurrentPublication()}
										{assign var=articleTitle value=$publication->getLocalizedTitle(null, 'html')|strip_unsafe_html}
										{assign var=articleAbstract value=$publication->getLocalizedData('abstract')|strip_tags|trim}

										<article class="jkc-article-card jkc-article-card--slider">
											<a class="jkc-article-card__thumb jkc-article-card__thumb--landscape" href="{url page='article' op='view' path=$articleItem.articlePath}">
												<img src="{$articleItem.thumbnailUrl|escape}" alt="{$articleItem.thumbnailAlt|escape}" loading="lazy">
											</a>

											<div class="jkc-article-card__body">
												<div class="jkc-article-card__topline">
													{if $articleItem.issueIdentification}
														<p class="jkc-article-card__eyebrow">{$articleItem.issueIdentification|escape}</p>
													{/if}
													{if $articleItem.doiUrl}
														<a href="{$articleItem.doiUrl|escape}" class="jkc-badge jkc-badge--doi" rel="noopener noreferrer">DOI</a>
													{/if}
												</div>

												<h4 class="jkc-article-card__title">
													<a href="{url page='article' op='view' path=$articleItem.articlePath}">
														{$articleTitle}
													</a>
												</h4>

												{if $articleItem.authorString}
													<p class="jkc-article-card__authors">{$articleItem.authorString|escape}</p>
												{/if}

												<div class="jkc-article-card__meta">
													{if $publication->getData('datePublished')}
														<span class="jkc-article-card__meta-item jkc-article-card__meta-item--date">{$publication->getData('datePublished')|date_format:$dateFormatShort}</span>
													{/if}
													{if $publication->getData('pages')}
														<span class="jkc-article-card__meta-item jkc-article-card__meta-item--pages">Pages {$publication->getData('pages')|escape}</span>
													{/if}
													{if isset($articleItem.metricValue) && $articleItem.metricLabel}
														<span class="jkc-article-card__meta-item jkc-article-card__meta-item--metric">{$articleItem.metricLabel|escape}: {$articleItem.metricValue|escape}</span>
													{/if}
												</div>

												{if $articleAbstract}
													<p class="jkc-article-card__excerpt">{$articleAbstract|escape|truncate:170:"..."}</p>
												{/if}

												<div class="jkc-article-card__actions">
													<a href="{url page='article' op='view' path=$articleItem.articlePath}" class="jkc-button jkc-button--outline">Abstract</a>
													{assign var=pdfGalleyPath value=''}
													{foreach from=$article->getGalleys() item=galley}
														{if !$pdfGalleyPath && $galley->isPdfGalley()}
															{assign var=pdfGalleyPath value=$articleItem.articlePath|to_array:$galley->getBestGalleyId()}
														{/if}
													{/foreach}
													{if $pdfGalleyPath}
														<a href="{url page='article' op='view' path=$pdfGalleyPath}" class="jkc-button jkc-button--primary">PDF</a>
													{/if}
												</div>
											</div>
										</article>
									{/foreach}
								</div>
							</div>
						{else}
							<div class="jkc-article-lane__empty">{$articleSection.emptyMessage|escape}</div>
						{/if}
					</section>
				{/foreach}
			</div>

			<div class="jkc-articles-showcase__footer">
				<a href="{url page='search'}" class="jkc-button jkc-button--primary">More Articles</a>
			</div>
		</section>
	{/if}

	{if ($numAnnouncementsHomepage && !empty($announcements)) || !empty($jkcEditorialPickItems)}
		<section class="jkc-home-highlights" aria-labelledby="jkcHomeHighlightsHeading">
			<div class="jkc-home-highlights__announcements">
				<div class="jkc-section-heading jkc-section-heading--left">
					<p class="jkc-section-heading__eyebrow">Journal Updates</p>
					<h2 id="jkcHomeHighlightsHeading">{translate key="announcement.announcements"}</h2>
				</div>

				{if $numAnnouncementsHomepage && !empty($announcements)}
					<div class="jkc-announcement-list">
						{foreach name=announcements from=$announcements item=announcement}
							{if $smarty.foreach.announcements.iteration > 1}
								{break}
							{/if}
							{assign var="announcementId" value=$announcement->id}
							<article class="jkc-announcement-card">
								<div class="jkc-announcement-card__icon" aria-hidden="true"></div>
								<div class="jkc-announcement-card__body">
									<div class="jkc-announcement-card__topline">
										{if $announcement->datePosted}
											<span class="jkc-announcement-card__date">{$announcement->datePosted->format($dateFormatShort)}</span>
										{/if}
									</div>
									<h3 class="jkc-announcement-card__title">
										<a href="{url page='announcement' op='view' path=$announcementId}">
											{$announcement->getLocalizedData('title')|escape}
										</a>
									</h3>
									{if $announcement->getLocalizedData('descriptionShort')}
										<p class="jkc-announcement-card__excerpt">{$announcement->getLocalizedData('descriptionShort')|strip_tags|truncate:220:"..."}</p>
									{elseif $announcement->getLocalizedData('description')}
										<p class="jkc-announcement-card__excerpt">{$announcement->getLocalizedData('description')|strip_tags|truncate:220:"..."}</p>
									{/if}
									<a class="jkc-announcement-card__more" href="{url page='announcement' op='view' path=$announcementId}">Read announcement</a>
								</div>
							</article>
						{/foreach}
					</div>

					<div class="jkc-home-highlights__footer">
						<a href="{url page='announcement'}" class="jkc-button jkc-button--outline">All Announcements</a>
					</div>
				{else}
					<div class="jkc-announcement-card jkc-announcement-card--empty">
						<div class="jkc-announcement-card__body">
							<h3 class="jkc-announcement-card__title">Announcements unavailable</h3>
							<p class="jkc-announcement-card__excerpt">Aktifkan atau tambahkan announcements di OJS untuk menampilkan pembaruan jurnal pada homepage.</p>
						</div>
					</div>
				{/if}

				<div class="jkc-home-highlights__utility-grid">
					<section class="jkc-utility-card jkc-utility-card--contact" aria-labelledby="jkcContactHeading">
						<div class="jkc-section-heading jkc-section-heading--left">
							<h3 id="jkcContactHeading">Contact</h3>
						</div>
						<div class="jkc-contact-links">
							{foreach from=$jkcHomepageContactCards item=contactCard}
								<a href="{$contactCard.href|escape}" class="jkc-contact-link jkc-contact-link--{$contactCard.name|lower|escape}" target="_blank" rel="noopener noreferrer" aria-label="{$contactCard.label|escape}" title="{$contactCard.label|escape}">
									<span class="jkc-contact-link__icon-wrap" aria-hidden="true">
										{if $contactCard.name == 'WhatsApp'}
											<span class="jkc-contact-link__icon fa fa-whatsapp" aria-hidden="true"></span>
										{else}
											<span class="jkc-contact-link__icon fa fa-envelope-o" aria-hidden="true"></span>
										{/if}
									</span>
									<span class="jkc-contact-link__sr">{$contactCard.label|escape}</span>
								</a>
							{/foreach}
						</div>
					</section>

					<section class="jkc-utility-card jkc-utility-card--stats" aria-labelledby="jkcStatsHeading">
						<div class="jkc-section-heading jkc-section-heading--left">
							<h3 id="jkcStatsHeading">Statistics</h3>
						</div>
						<div class="jkc-stats-chart" role="list" aria-label="Journal statistics chart">
							{foreach from=$jkcHomepageStats item=statItem}
								<div class="jkc-stat-bar jkc-stat-bar--{$statItem.tone|escape}" role="listitem">
									<div class="jkc-stat-bar__topline">
										<span class="jkc-stat-bar__label">{$statItem.label|escape}</span>
										<strong class="jkc-stat-bar__value">{$statItem.value|escape}</strong>
									</div>
									<div class="jkc-stat-bar__track" aria-hidden="true">
										<span class="jkc-stat-bar__fill" style="width: {$statItem.percent|escape}%;"></span>
									</div>
								</div>
							{/foreach}
						</div>
					</section>
				</div>
			</div>

			<aside class="jkc-home-highlights__editorial" aria-labelledby="jkcEditorialPickHeading">
				<div class="jkc-section-heading jkc-section-heading--left">
					<p class="jkc-section-heading__eyebrow">Featured Publications</p>
					<h2 id="jkcEditorialPickHeading">Editorial Pick</h2>
				</div>

				{if !empty($jkcEditorialPickItems)}
					<div class="jkc-editorial-pick-list">
						{foreach from=$jkcEditorialPickItems item=pickItem}
							{assign var=pickArticle value=$pickItem.article}
							{assign var=pickPublication value=$pickArticle->getCurrentPublication()}
							{assign var=pickTitle value=$pickPublication->getLocalizedTitle(null, 'html')|strip_unsafe_html}
							<article class="jkc-editorial-pick-card">
								<a class="jkc-editorial-pick-card__thumb" href="{url page='article' op='view' path=$pickItem.articlePath}">
									<img src="{$pickItem.thumbnailUrl|escape}" alt="{$pickItem.thumbnailAlt|escape}" loading="lazy">
								</a>
								<div class="jkc-editorial-pick-card__body">
									<h3 class="jkc-editorial-pick-card__title">
										<a href="{url page='article' op='view' path=$pickItem.articlePath}">{$pickTitle}</a>
									</h3>
									<div class="jkc-editorial-pick-card__meta">
										{if $pickPublication->getData('datePublished')}
											<span>{$pickPublication->getData('datePublished')|date_format:$dateFormatShort}</span>
										{/if}
										{if $pickItem.authorString}
											<span>{$pickItem.authorString|escape|truncate:60:"..."}</span>
										{/if}
									</div>
								</div>
							</article>
						{/foreach}
					</div>
					<div class="jkc-home-highlights__footer">
						<a href="{url page='search'}" class="jkc-button jkc-button--outline">Browse All Articles</a>
					</div>
				{else}
					<div class="jkc-editorial-pick-card jkc-editorial-pick-card--empty">
						<div class="jkc-editorial-pick-card__body">
							<h3 class="jkc-editorial-pick-card__title">Editorial pick belum tersedia</h3>
							<p class="jkc-announcement-card__excerpt">Section ini akan menampilkan artikel unggulan setelah ada artikel terbit yang bisa dipilih.</p>
						</div>
					</div>
				{/if}
			</aside>
		</section>
	{/if}

	{* Hidden intentionally for layout stabilization.
	   Current additionalHomeContent contains legacy table markup, placeholder metadata,
	   and hardcoded production URLs that conflict with the modern homepage flow. *}
</div>

{assign var=isFullWidth value=true}
{include file="frontend/components/footer.tpl"}
