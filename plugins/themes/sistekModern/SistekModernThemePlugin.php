<?php

/**
 * @file plugins/themes/sistekModern/SistekModernThemePlugin.php
 *
 * @class SistekModernThemePlugin
 *
 * @brief Minimal custom theme foundation for SISTEK modernization phases 0-2.
 */

namespace APP\plugins\themes\sistekModern;

use APP\author\Author;
use APP\core\Application;
use APP\core\Services;
use APP\facades\Repo;
use APP\search\ArticleSearch;
use APP\statistics\StatisticsHelper;
use APP\submission\Collector as SubmissionCollector;
use APP\submission\Submission;
use APP\template\TemplateManager;
use PKP\plugins\Hook;
use PKP\plugins\PluginRegistry;
use PKP\security\Role;
use PKP\submission\PKPSubmission;

class SistekModernThemePlugin extends \PKP\plugins\ThemePlugin
{
    /**
     * Initialize theme assets and parent.
     */
    public function init()
    {
        $this->setParent('defaultthemeplugin');

        $this->addOption('editorialPickPaths', 'FieldTextarea', [
            'label' => 'Editorial Pick Articles',
            'description' => 'Masukkan satu article path atau submission ID per baris. Contoh: 1 atau algoritma-evolusi-untuk-masalah-optimasi',
            'default' => '',
        ]);

        // Minimal visual proof that custom theme is active.
        $this->addStyle('sistekModernStyles20260714g', 'styles/index.less', [
            'priority' => TemplateManager::STYLE_SEQUENCE_LAST,
        ]);
        $this->addScript('jkcHomeArticles', 'assets/js/home-articles.js', ['priority' => 110]);
        $this->addScript('jkcArticleDetail', 'assets/js/article-detail.js', ['priority' => 112]);
        $this->addScript('jkcArticleRecommendations', 'assets/js/article-recommendations.js', ['priority' => 113]);

        Hook::add('TemplateManager::display', [$this, 'injectHomepageArticleData']);
    }

    /**
     * Get display name.
     */
    public function getDisplayName()
    {
        return 'SISTEK Modern Theme';
    }

    /**
     * Get description.
     */
    public function getDescription()
    {
        return 'Custom child theme foundation for Jurnal Sistem Informasi dan Teknologi STMIK Samarinda (OJS 3.5).';
    }

    /**
     * Inject homepage article discovery data for the custom journal index.
     */
    public function injectHomepageArticleData(string $hookName, array $args): int
    {
        $templateManager = $args[0] ?? null;
        $template = $args[1] ?? '';

        if (!$templateManager instanceof TemplateManager) {
            return Hook::CONTINUE;
        }

        $request = Application::get()->getRequest();
        $context = $request->getContext();
        if (!$context) {
            return Hook::CONTINUE;
        }

        $templateManager->assign($this->getSidebarEnhancementData($context, $request));

        if ($template === 'frontend/pages/editorialTeam.tpl') {
            $templateManager->assign([
                'jkcEditorialTeamMembers' => $this->getEditorialTeamMembers($context, $request->getBaseUrl()),
            ]);

            return Hook::CONTINUE;
        }

        if ($template === 'frontend/pages/article.tpl') {
            $article = $templateManager->getTemplateVars('article');
            if ($article instanceof Submission) {
                $dispatcher = $request->getDispatcher();
                $shareUrl = $dispatcher->url(
                    $request,
                    Application::ROUTE_PAGE,
                    $context->getPath(),
                    'article',
                    'view',
                    $article->getBestId()
                );

                $publication = $templateManager->getTemplateVars('publication');
                $authorUserGroups = $this->getAuthorUserGroups((int) $context->getId());

                $coverThumbnail = $this->resolveHomepageArticleThumbnail($article, (int) $context->getId());
                $articlePublication = $publication ?: $article->getCurrentPublication();
                $doiObject = $articlePublication ? $articlePublication->getData('doiObject') : null;
                $articleDoiUrl = $doiObject ? $this->sanitizeHttpUrl((string) $doiObject->getData('resolvingUrl')) : '';

                $templateManager->assign([
                    'jkcArticleShareUrl' => $shareUrl,
                    'jkcArticleDoiUrl' => $articleDoiUrl,
                    'jkcArticleCover' => [
                        'url' => $coverThumbnail['url'],
                        'alt' => $coverThumbnail['alt'],
                        'hasArticleCover' => (bool) ($articlePublication && $articlePublication->getLocalizedData('coverImage')),
                    ],
                    'jkcArticleStats' => $this->getArticleUsageStats((int) $context->getId(), (int) $article->getId()),
                    'jkcArticleRecommendationSliders' => $this->getArticleRecommendationSliders(
                        $article,
                        $publication,
                        (int) $context->getId(),
                        $authorUserGroups,
                        $request
                    ),
                ]);
            }

            return Hook::CONTINUE;
        }

        if (
            in_array($template, [
                'frontend/pages/information.tpl',
                'frontend/pages/navigationMenuItemViewContent.tpl',
            ], true)
            && $request->getRequestedPage() === 'reviewer'
        ) {
            $templateManager->assign([
                'jkcInformationPageMode' => 'reviewer',
                'jkcReviewerMembers' => $this->getReviewerMembers(
                    (string) $templateManager->getTemplateVars('content'),
                    $request->getBaseUrl()
                ),
            ]);

            return Hook::CONTINUE;
        }

        if ($template !== 'frontend/pages/indexJournal.tpl') {
            return Hook::CONTINUE;
        }

        $contextId = $context->getId();
        $authorUserGroups = $this->getAuthorUserGroups((int) $contextId);

        $limit = 6;

        $recentArticles = $this->getRecentHomepageArticles($contextId, $authorUserGroups, $limit);
        $mostViewedArticles = $this->getPopularHomepageArticles(
            $contextId,
            $authorUserGroups,
            [Application::ASSOC_TYPE_SUBMISSION],
            $limit,
            'Views'
        );
        $mostReadArticles = $this->getPopularHomepageArticles(
            $contextId,
            $authorUserGroups,
            [Application::ASSOC_TYPE_SUBMISSION_FILE, Application::ASSOC_TYPE_SUBMISSION_FILE_COUNTER_OTHER],
            $limit,
            'Reads'
        );

        $editorialPickArticles = $this->getEditorialPickHomepageArticles($contextId, $authorUserGroups, 4);
        $editorialPickMode = empty($editorialPickArticles) ? 'recentFallback' : 'manualSelection';
        if (empty($editorialPickArticles)) {
            $editorialPickArticles = array_slice($recentArticles, 0, 4);
        }

        $journalTemplateLink = $this->getJournalTemplateLink($contextId);
        $homepageTools = $this->getHomepageTools($contextId, $request->getBaseUrl());
        $homepageContact = $this->getHomepageContactCards($context, $request->getBaseUrl());
        $homepageStats = $this->getHomepageStats($contextId);

        $templateManager->assign([
            'jkcHomepageArticleSections' => [
                [
                    'key' => 'recent',
                    'title' => 'Recent',
                    'items' => $recentArticles,
                    'emptyMessage' => 'Recent articles will appear here when published.',
                ],
                [
                    'key' => 'mostRead',
                    'title' => 'Most Read',
                    'items' => $mostReadArticles,
                    'emptyMessage' => 'Reading statistics are not yet available.',
                ],
                [
                    'key' => 'mostView',
                    'title' => 'Most View',
                    'items' => $mostViewedArticles,
                    'emptyMessage' => 'View statistics are not yet available.',
                ],
            ],
            'jkcEditorialPickItems' => $editorialPickArticles,
            'jkcEditorialPickMode' => $editorialPickMode,
            'jkcJournalTemplateLink' => $journalTemplateLink,
            'jkcHomepageTools' => $homepageTools,
            'jkcHomepageContactCards' => $homepageContact,
            'jkcHomepageStats' => $homepageStats,
        ]);

        return Hook::CONTINUE;
    }

    /**
     * Get author user groups in the OJS 3.5 repository API.
     */
    protected function getAuthorUserGroups(int $contextId): \Traversable
    {
        return Repo::userGroup()->getByRoleIds([Role::ROLE_ID_AUTHOR], $contextId);
    }

    /**
     * Get the latest published submissions for the homepage.
     *
     * @param \Traversable $authorUserGroups
     */
    protected function getRecentHomepageArticles(int $contextId, \Traversable $authorUserGroups, int $limit): array
    {
        $submissions = Repo::submission()->getCollector()
            ->filterByContextIds([$contextId])
            ->filterByStatus([Submission::STATUS_PUBLISHED])
            ->orderBy(SubmissionCollector::ORDERBY_DATE_PUBLISHED, SubmissionCollector::ORDER_DIR_DESC)
            ->limit($limit)
            ->getMany();

        return $this->prepareHomepageArticleCards($submissions, $contextId, $authorUserGroups);
    }

    /**
     * Get editorial pick articles from theme settings.
     *
     * Accepts either numeric submission ids or public article paths/best ids.
     *
     * @param \Traversable $authorUserGroups
     */
    protected function getEditorialPickHomepageArticles(int $contextId, \Traversable $authorUserGroups, int $limit): array
    {
        $rawValue = (string) $this->getOption('editorialPickPaths');
        if ($rawValue === '') {
            return [];
        }

        $tokens = preg_split('/[\r\n,]+/', $rawValue) ?: [];
        $tokens = array_values(array_filter(array_map(
            static fn ($item) => trim((string) $item),
            $tokens
        )));

        if (empty($tokens)) {
            return [];
        }

        $publishedSubmissions = Repo::submission()->getCollector()
            ->filterByContextIds([$contextId])
            ->filterByStatus([Submission::STATUS_PUBLISHED])
            ->limit(200)
            ->getMany();

        $byBestId = [];
        foreach ($publishedSubmissions as $submission) {
            $byBestId[(string) $submission->getBestId()] = $submission;
        }

        $cards = [];
        $seenSubmissionIds = [];

        foreach ($tokens as $token) {
            $submission = null;
            if (ctype_digit($token)) {
                $submission = Repo::submission()->get((int) $token, $contextId);
            }

            if (!$submission && isset($byBestId[$token])) {
                $submission = $byBestId[$token];
            }

            if (
                !$submission
                || (int) $submission->getData('status') !== Submission::STATUS_PUBLISHED
                || isset($seenSubmissionIds[$submission->getId()])
            ) {
                continue;
            }

            $seenSubmissionIds[$submission->getId()] = true;
            $card = $this->prepareHomepageArticleCard($submission, $contextId, $authorUserGroups);
            if ($card) {
                $cards[] = $card;
            }

            if (count($cards) >= $limit) {
                break;
            }
        }

        return $cards;
    }

    /**
     * Get homepage articles ordered by real OJS publication stats.
     *
     * @param \Traversable $authorUserGroups
     */
    protected function getPopularHomepageArticles(
        int $contextId,
        \Traversable $authorUserGroups,
        array $assocTypes,
        int $limit,
        string $metricLabel
    ): array {
        $rows = Services::get('publicationStats')->getTotals([
            'contextIds' => [$contextId],
            'assocTypes' => $assocTypes,
            'count' => $limit,
        ]);

        if (empty($rows)) {
            return [];
        }

        $cards = [];
        $seenSubmissionIds = [];

        foreach ($rows as $row) {
            $submissionId = (int) ($row->submission_id ?? 0);
            if (!$submissionId || isset($seenSubmissionIds[$submissionId])) {
                continue;
            }

            $submission = Repo::submission()->get($submissionId, $contextId);
            if (!$submission || (int) $submission->getData('status') !== Submission::STATUS_PUBLISHED) {
                continue;
            }

            $seenSubmissionIds[$submissionId] = true;

            $card = $this->prepareHomepageArticleCard(
                $submission,
                $contextId,
                $authorUserGroups,
                (int) round((float) ($row->metric ?? 0)),
                $metricLabel
            );

            if ($card) {
                $cards[] = $card;
            }

            if (count($cards) >= $limit) {
                break;
            }
        }

        return $cards;
    }

    /**
     * Normalize a list of submissions into template-friendly cards.
     *
     * @param iterable<Submission> $submissions
     * @param \Traversable $authorUserGroups
     */
    protected function prepareHomepageArticleCards(iterable $submissions, int $contextId, \Traversable $authorUserGroups): array
    {
        $cards = [];

        foreach ($submissions as $submission) {
            $card = $this->prepareHomepageArticleCard($submission, $contextId, $authorUserGroups);
            if ($card) {
                $cards[] = $card;
            }
        }

        return $cards;
    }

    /**
     * Normalize a submission for homepage article discovery cards.
     *
     * @param \Traversable $authorUserGroups
     */
    protected function prepareHomepageArticleCard(
        Submission $submission,
        int $contextId,
        \Traversable $authorUserGroups,
        ?int $metricValue = null,
        ?string $metricLabel = null
    ): ?array {
        $publication = $submission->getCurrentPublication();
        if (!$publication) {
            return null;
        }

        $articlePath = $submission->getBestId();
        $thumbnail = $this->resolveHomepageArticleThumbnail($submission, $contextId);

        $issueIdentification = '';
        $issueId = (int) ($publication->getData('issueId') ?: 0);
        if ($issueId) {
            $issue = Repo::issue()->get($issueId);
            if ($issue) {
                $issueIdentification = (string) $issue->getIssueIdentification();
            }
        }

        $doiObject = $publication->getData('doiObject');
        $doiUrl = $doiObject ? $this->sanitizeHttpUrl((string) $doiObject->getData('resolvingUrl')) : '';

        return [
            'article' => $submission,
            'articlePath' => $articlePath,
            'authorString' => $publication->getAuthorString($authorUserGroups),
            'thumbnailUrl' => $thumbnail['url'],
            'thumbnailAlt' => $thumbnail['alt'],
            'issueIdentification' => $issueIdentification,
            'doiUrl' => $doiUrl,
            'metricValue' => $metricValue,
            'metricLabel' => $metricLabel,
        ];
    }

    /**
     * Resolve thumbnail fallback: article cover -> issue cover -> theme placeholder.
     */
    protected function resolveHomepageArticleThumbnail(Submission $submission, int $contextId): array
    {
        $publication = $submission->getCurrentPublication();
        $request = Application::get()->getRequest();
        $baseUrl = rtrim($request->getBaseUrl(), '/');

        if ($publication && $publication->getLocalizedData('coverImage')) {
            $coverImage = $publication->getLocalizedData('coverImage');
            return [
                'url' => (string) $publication->getLocalizedCoverImageUrl($contextId),
                'alt' => (string) ($coverImage['altText'] ?? $publication->getLocalizedTitle()),
            ];
        }

        if ($publication) {
            $issueId = (int) ($publication->getData('issueId') ?: 0);
            if ($issueId) {
                $issue = Repo::issue()->get($issueId);
                if ($issue && $issue->getLocalizedCoverImageUrl()) {
                    return [
                        'url' => (string) $issue->getLocalizedCoverImageUrl(),
                        'alt' => (string) ($issue->getLocalizedCoverImageAltText() ?: $issue->getIssueIdentification()),
                    ];
                }
            }
        }

        return [
            'url' => $baseUrl . '/plugins/themes/sistekModern/assets/images/article-placeholder.svg',
            'alt' => (string) ($publication?->getLocalizedTitle() ?: 'Article placeholder'),
        ];
    }

    /**
     * Read the current journal template link from the existing custom block.
     */
    protected function getJournalTemplateLink(int $contextId): ?string
    {
        $pluginSettingsDao = \DAORegistry::getDAO('PluginSettingsDAO');
        if (!$pluginSettingsDao) {
            return null;
        }

        $blockContent = $pluginSettingsDao->getSetting($contextId, 'template', 'blockContent');
        if (is_array($blockContent)) {
            $blockContent = (string) reset($blockContent);
        }

        if (!is_string($blockContent) || trim($blockContent) === '') {
            return null;
        }

        if (!preg_match('/href=["\']([^"\']+)["\']/i', $blockContent, $matches)) {
            return null;
        }

        $href = html_entity_decode(trim((string) $matches[1]), ENT_QUOTES | ENT_HTML5, 'UTF-8');
        if ($href === '') {
            return null;
        }

        $href = $this->sanitizeHttpUrl($href);

        return $href !== '' ? $href : null;
    }

    /**
     * Build a local-image + dynamic-link tools list for the homepage.
     */
    protected function getHomepageTools(int $contextId, string $baseUrl): array
    {
        $pluginSettingsDao = \DAORegistry::getDAO('PluginSettingsDAO');
        if (!$pluginSettingsDao) {
            return [];
        }

        $blockContent = $pluginSettingsDao->getSetting($contextId, 'tools', 'blockContent');
        if (is_array($blockContent)) {
            $blockContent = (string) reset($blockContent);
        }

        $hrefs = [];
        if (is_string($blockContent) && preg_match_all('/href=["\']([^"\']+)["\']/i', $blockContent, $matches)) {
            $hrefs = array_values(array_unique(array_filter(array_map(
                fn ($href) => $this->sanitizeHttpUrl(html_entity_decode(trim((string) $href), ENT_QUOTES | ENT_HTML5, 'UTF-8')),
                $matches[1]
            ))));
        }

        $toolsDir = __DIR__ . DIRECTORY_SEPARATOR . 'assets' . DIRECTORY_SEPARATOR . 'images' . DIRECTORY_SEPARATOR . 'tools' . DIRECTORY_SEPARATOR;
        $tools = [
            [
                'name' => 'Mendeley',
                'href' => $hrefs[0] ?? 'https://www.mendeley.com/',
                'filename' => 'mendeley.png',
            ],
            [
                'name' => 'Grammarly',
                'href' => $hrefs[1] ?? 'https://www.grammarly.com/',
                'filename' => 'grammarly.png',
            ],
            [
                'name' => 'Turnitin',
                'href' => $hrefs[2] ?? 'https://www.turnitin.com/',
                'filename' => 'turnitin.png',
            ],
        ];

        foreach ($tools as &$tool) {
            $tool['imageUrl'] = rtrim($baseUrl, '/') . '/plugins/themes/sistekModern/assets/images/tools/' . $tool['filename'];
            $tool['imageExists'] = file_exists($toolsDir . $tool['filename']);
        }
        unset($tool);

        return $tools;
    }

    /**
     * Accept only ordinary web URLs from configurable content.
     */
    protected function sanitizeHttpUrl(string $url): string
    {
        $url = trim($url);
        if ($url === '') {
            return '';
        }

        if (preg_match('/[\x00-\x1F\x7F]/', $url)) {
            return '';
        }

        $scheme = strtolower((string) parse_url($url, PHP_URL_SCHEME));
        if (!in_array($scheme, ['http', 'https'], true)) {
            return '';
        }

        $host = parse_url($url, PHP_URL_HOST);
        if (!is_string($host) || trim($host) === '') {
            return '';
        }

        return $url;
    }

    /**
     * Keep mailto links from configurable journal contact data well-formed.
     */
    protected function sanitizeEmailAddress(string $email): string
    {
        $email = trim($email);
        if ($email === '' || preg_match('/[\r\n\x00-\x1F\x7F]/', $email)) {
            return '';
        }

        return filter_var($email, FILTER_VALIDATE_EMAIL) ? $email : '';
    }

    /**
     * Build compact contact cards for homepage utility area.
     */
    protected function getHomepageContactCards($context, string $baseUrl): array
    {
        $contactPageUrl = rtrim($baseUrl, '/') . '/index.php/' . $context->getPath() . '/about/contact';
        $journalName = (string) ($context->getLocalizedName() ?: 'Jurnal Sistem Informasi dan Teknologi STMIK Samarinda');
        $contactEmail = $this->sanitizeEmailAddress((string) ($context->getData('contactEmail') ?: $context->getData('supportEmail') ?: ''));
        $contactPhone = (string) ($context->getData('contactPhone') ?: $context->getData('supportPhone') ?: '');

        $whatsAppHref = $contactPageUrl;
        $digits = preg_replace('/\D+/', '', $contactPhone);
        if ($digits && preg_match('/^0\d+$/', $digits)) {
            $digits = '62' . substr($digits, 1);
        }
        if ($digits && preg_match('/^62\d+$/', $digits)) {
            $whatsAppMessage = rawurlencode(
                "Halo tim editorial {$journalName}, saya ingin menanyakan informasi terkait jurnal dan proses submission. Terima kasih."
            );
            $whatsAppHref = 'https://wa.me/' . $digits . '?text=' . $whatsAppMessage;
        }

        $emailHref = $contactPageUrl;
        if ($contactEmail) {
            $subject = rawurlencode("Inquiry about {$journalName}");
            $body = rawurlencode(
                "Dear Editorial Team,\n\nI would like to request information regarding {$journalName} and its submission process.\n\nThank you.\n"
            );
            $emailHref = 'mailto:' . $contactEmail . '?subject=' . $subject . '&body=' . $body;
        }

        $items = [
            [
                'name' => 'WhatsApp',
                'href' => $whatsAppHref,
                'filenames' => ['whatsapp-banner.svg', 'whatsapp-banner.png', 'whatsapp.svg', 'whatsapp.png'],
                'label' => 'WhatsApp Contact',
            ],
            [
                'name' => 'Email',
                'href' => $emailHref,
                'filenames' => ['email-banner.svg', 'email-banner.png', 'email.svg', 'email.png'],
                'label' => $contactEmail ?: 'Email Contact',
            ],
        ];

        $contactDir = __DIR__ . DIRECTORY_SEPARATOR . 'assets' . DIRECTORY_SEPARATOR . 'images' . DIRECTORY_SEPARATOR . 'contact' . DIRECTORY_SEPARATOR;
        foreach ($items as &$item) {
            $selectedFilename = '';
            foreach ($item['filenames'] as $candidateFilename) {
                if (file_exists($contactDir . $candidateFilename)) {
                    $selectedFilename = $candidateFilename;
                    break;
                }
            }

            $item['imageExists'] = $selectedFilename !== '';
            $item['imageUrl'] = $item['imageExists']
                ? rtrim($baseUrl, '/') . '/plugins/themes/sistekModern/assets/images/contact/' . $selectedFilename
                : '';
        }
        unset($item);

        return $items;
    }

    /**
     * Parse the masthead editorial HTML into structured member cards.
     */
    protected function getEditorialTeamMembers($context, string $baseUrl): array
    {
        $rawHtml = trim((string) $context->getLocalizedData('editorialTeam'));
        if ($rawHtml === '') {
            return [];
        }

        $document = new \DOMDocument('1.0', 'UTF-8');
        $internalErrors = libxml_use_internal_errors(true);
        $loaded = $document->loadHTML(
            '<?xml encoding="utf-8" ?><div class="jkc-editorial-source">' . $rawHtml . '</div>',
            \LIBXML_HTML_NOIMPLIED | \LIBXML_HTML_NODEFDTD | \LIBXML_NOERROR | \LIBXML_NOWARNING
        );
        libxml_clear_errors();
        libxml_use_internal_errors($internalErrors);

        if (!$loaded) {
            return [];
        }

        $wrapper = $document->getElementsByTagName('div')->item(0);
        if (!$wrapper instanceof \DOMElement) {
            return [];
        }

        $members = [];
        $currentRole = 'Editorial Team';

        foreach ($wrapper->childNodes as $childNode) {
            if (!$childNode instanceof \DOMElement) {
                continue;
            }

            if (preg_match('/^h[1-6]$/i', $childNode->tagName)) {
                $currentRole = $this->normalizeEditorialRole($childNode->textContent);
                continue;
            }

            if ($childNode->tagName === 'div' && strpos(' ' . $childNode->getAttribute('class') . ' ', ' member ') !== false) {
                $members = array_merge($members, $this->extractEditorialMembersFromBlock($childNode, $currentRole, $baseUrl));
            }
        }

        return $members;
    }

    /**
     * Parse reviewer information HTML into structured profile cards.
     */
    protected function getReviewerMembers(string $rawHtml, string $baseUrl): array
    {
        $rawHtml = trim($rawHtml);
        if ($rawHtml === '') {
            return [];
        }

        // Split stacked reviewer records that were manually entered with <br>.
        $rawHtml = preg_replace('/<br\s*\/?>/i', '</div><div class="member">', $rawHtml) ?: $rawHtml;

        $document = new \DOMDocument('1.0', 'UTF-8');
        $internalErrors = libxml_use_internal_errors(true);
        $loaded = $document->loadHTML(
            '<?xml encoding="utf-8" ?><div class="jkc-reviewer-source">' . $rawHtml . '</div>',
            \LIBXML_HTML_NOIMPLIED | \LIBXML_HTML_NODEFDTD | \LIBXML_NOERROR | \LIBXML_NOWARNING
        );
        libxml_clear_errors();
        libxml_use_internal_errors($internalErrors);

        if (!$loaded) {
            return [];
        }

        $xpath = new \DOMXPath($document);
        $memberNodes = $xpath->query('//div[contains(concat(" ", normalize-space(@class), " "), " member ")]');
        if (!$memberNodes) {
            return [];
        }

        $members = [];
        $seen = [];

        foreach ($memberNodes as $memberNode) {
            if (!$memberNode instanceof \DOMElement) {
                continue;
            }

            // Skip wrapper blocks that only contain nested member items.
            $nestedMembers = $xpath->query('.//div[contains(concat(" ", normalize-space(@class), " "), " member ")]', $memberNode);
            if ($nestedMembers && $nestedMembers->length > 0) {
                continue;
            }

            $nameAnchor = $xpath->query('.//a[not(@href) or normalize-space(@href)=""]', $memberNode)?->item(0);
            if (!$nameAnchor instanceof \DOMElement) {
                continue;
            }

            $name = $this->normalizeEditorialName($nameAnchor->textContent);
            if ($name === '') {
                continue;
            }

            $scopusAnchor = $xpath->query('.//a[@href and normalize-space(@href)!=""]', $memberNode)?->item(0);
            $scopusId = '';
            $scopusUrl = '';
            if ($scopusAnchor instanceof \DOMElement) {
                $scopusId = trim(html_entity_decode($scopusAnchor->textContent, ENT_QUOTES | ENT_HTML5, 'UTF-8'));
                $scopusUrl = $this->sanitizeHttpUrl(trim((string) $scopusAnchor->getAttribute('href')));
            }

            $memberHtml = $this->getNodeInnerHtml($memberNode);
            $memberHtml = preg_replace('/<a\b(?![^>]*href)[^>]*>.*?<\/a>/isu', '', $memberHtml, 1) ?: $memberHtml;
            $memberHtml = preg_replace('/SCOPUS\s*ID\s*:?\s*<a\b[^>]*>.*?<\/a>/isu', '', $memberHtml, 1) ?: $memberHtml;
            $affiliation = html_entity_decode(strip_tags($memberHtml), ENT_QUOTES | ENT_HTML5, 'UTF-8');
            $affiliation = preg_replace('/\s+/u', ' ', trim($affiliation)) ?: '';
            $affiliation = preg_replace('/^[,\s]+/u', '', $affiliation) ?: '';
            $affiliation = trim($affiliation, ", \t\n\r\0\x0B");

            $slug = $this->slugifyEditorialName($name);
            $image = $this->resolveReviewerImage($slug, $baseUrl);
            $signature = md5($name . '|' . $scopusId . '|' . $affiliation);
            if (isset($seen[$signature])) {
                continue;
            }
            $seen[$signature] = true;

            $members[] = [
                'name' => $name,
                'role' => 'Reviewer',
                'affiliation' => $affiliation,
                'scopusId' => $scopusId,
                'scopusUrl' => $scopusUrl,
                'imageUrl' => $image['url'],
                'imageExists' => $image['exists'],
                'imageAlt' => $name,
            ];
        }

        return $members;
    }

    /**
     * Recursively parse member blocks from the editorial HTML structure.
     *
     * @return array<int, array<string, string|bool>>
     */
    protected function extractEditorialMembersFromBlock(\DOMElement $block, string $defaultRole, string $baseUrl): array
    {
        $members = [];
        $currentRole = $defaultRole;

        foreach ($block->childNodes as $childNode) {
            if (!$childNode instanceof \DOMElement) {
                continue;
            }

            if ($childNode->tagName === 'p') {
                if ($this->isEditorialRoleParagraph($childNode)) {
                    $currentRole = $this->normalizeEditorialRole($childNode->textContent);
                    continue;
                }

                $members = array_merge(
                    $members,
                    $this->parseEditorialMemberParagraph($this->getNodeInnerHtml($childNode), $currentRole, $baseUrl)
                );
                continue;
            }

            if ($childNode->tagName === 'div' && strpos(' ' . $childNode->getAttribute('class') . ' ', ' member ') !== false) {
                $members = array_merge($members, $this->extractEditorialMembersFromBlock($childNode, $currentRole, $baseUrl));
            }
        }

        return $members;
    }

    /**
     * Turn one HTML paragraph into one or more editorial member entries.
     *
     * @return array<int, array<string, string|bool>>
     */
    protected function parseEditorialMemberParagraph(string $paragraphHtml, string $role, string $baseUrl): array
    {
        $lines = preg_split('/<br\s*\/?>/i', $paragraphHtml) ?: [];
        $members = [];

        foreach ($lines as $lineHtml) {
            $lineHtml = trim($lineHtml);
            if ($lineHtml === '') {
                continue;
            }

            $fragment = new \DOMDocument('1.0', 'UTF-8');
            $internalErrors = libxml_use_internal_errors(true);
            $loaded = $fragment->loadHTML(
                '<?xml encoding="utf-8" ?><div>' . $lineHtml . '</div>',
                \LIBXML_HTML_NOIMPLIED | \LIBXML_HTML_NODEFDTD | \LIBXML_NOERROR | \LIBXML_NOWARNING
            );
            libxml_clear_errors();
            libxml_use_internal_errors($internalErrors);

            if (!$loaded) {
                continue;
            }

            $container = $fragment->getElementsByTagName('div')->item(0);
            if (!$container instanceof \DOMElement) {
                continue;
            }

            $plainText = html_entity_decode($container->textContent, ENT_QUOTES | ENT_HTML5, 'UTF-8');
            $plainText = preg_replace('/\s+/u', ' ', trim($plainText)) ?: '';
            if ($plainText === '') {
                continue;
            }

            $anchors = $container->getElementsByTagName('a');
            $name = '';
            $scopusId = '';
            $scopusUrl = '';

            if ($anchors->length > 0) {
                $name = trim((string) $anchors->item(0)?->textContent);
            }

            foreach ($anchors as $anchor) {
                $href = trim((string) $anchor->getAttribute('href'));
                $anchorText = trim((string) $anchor->textContent);
                if ($href !== '' && stripos($href, 'scopus.com') !== false) {
                    $scopusUrl = $this->sanitizeHttpUrl($href);
                    $scopusId = $anchorText;
                }
            }

            if ($name === '' && preg_match('/^([^,]+),/u', $plainText, $matches)) {
                $name = trim((string) $matches[1]);
            }

            if ($name === '') {
                continue;
            }

            if ($scopusId === '' && preg_match('/SCOPUS ID:\s*([0-9]+)/i', $plainText, $matches)) {
                $scopusId = trim((string) $matches[1]);
            }

            $affiliation = preg_replace('/^\s*' . preg_quote($name, '/') . '\s*,?\s*/u', '', $plainText, 1) ?: '';
            if ($scopusId !== '') {
                $affiliation = preg_replace('/^SCOPUS ID:\s*' . preg_quote($scopusId, '/') . '\s*,?\s*/iu', '', $affiliation, 1) ?: $affiliation;
                $affiliation = preg_replace('/,\s*SCOPUS ID:\s*' . preg_quote($scopusId, '/') . '\s*/iu', ', ', $affiliation, 1) ?: $affiliation;
            }
            $affiliation = trim($affiliation, ", \t\n\r\0\x0B");

            $slug = $this->slugifyEditorialName($name);
            $image = $this->resolveEditorialTeamImage($slug, $baseUrl);

            $members[] = [
                'name' => $name,
                'role' => $this->normalizeEditorialRole($role),
                'affiliation' => $affiliation,
                'scopusId' => $scopusId,
                'scopusUrl' => $scopusUrl,
                'imageUrl' => $image['url'],
                'imageExists' => $image['exists'],
                'imageAlt' => $name,
            ];
        }

        return $members;
    }

    /**
     * Resolve a local editorial photo by slug, with safe placeholder fallback.
     *
     * @return array{url:string,exists:bool}
     */
    protected function resolveEditorialTeamImage(string $slug, string $baseUrl): array
    {
        $imageDir = __DIR__ . DIRECTORY_SEPARATOR . 'assets' . DIRECTORY_SEPARATOR . 'images' . DIRECTORY_SEPARATOR . 'editorial-team' . DIRECTORY_SEPARATOR;
        $baseAssetUrl = rtrim($baseUrl, '/') . '/plugins/themes/sistekModern/assets/images/editorial-team/';

        foreach (['png', 'jpg', 'jpeg', 'webp'] as $extension) {
            $filename = $slug . '.' . $extension;
            if (file_exists($imageDir . $filename)) {
                return [
                    'url' => $baseAssetUrl . $filename,
                    'exists' => true,
                ];
            }
        }

        return [
            'url' => $baseAssetUrl . 'editorial-placeholder.svg',
            'exists' => false,
        ];
    }

    /**
     * Resolve a local reviewer photo by slug, with safe placeholder fallback.
     *
     * @return array{url:string,exists:bool}
     */
    protected function resolveReviewerImage(string $slug, string $baseUrl): array
    {
        $reviewerImageDir = __DIR__ . DIRECTORY_SEPARATOR . 'assets' . DIRECTORY_SEPARATOR . 'images' . DIRECTORY_SEPARATOR . 'reviewers' . DIRECTORY_SEPARATOR;
        $reviewerAssetUrl = rtrim($baseUrl, '/') . '/plugins/themes/sistekModern/assets/images/reviewers/';

        foreach (['png', 'jpg', 'jpeg', 'webp'] as $extension) {
            $filename = $slug . '.' . $extension;
            if (file_exists($reviewerImageDir . $filename)) {
                return [
                    'url' => $reviewerAssetUrl . $filename,
                    'exists' => true,
                ];
            }
        }

        return [
            'url' => rtrim($baseUrl, '/') . '/plugins/themes/sistekModern/assets/images/editorial-team/editorial-placeholder.svg',
            'exists' => false,
        ];
    }

    /**
     * Detect paragraphs that only label the next member role section.
     */
    protected function isEditorialRoleParagraph(\DOMElement $paragraph): bool
    {
        return $paragraph->getElementsByTagName('a')->length === 0
            && $paragraph->getElementsByTagName('strong')->length > 0;
    }

    /**
     * Read the raw HTML inside a DOM element.
     */
    protected function getNodeInnerHtml(\DOMElement $element): string
    {
        $html = '';
        foreach ($element->childNodes as $childNode) {
            $html .= $element->ownerDocument->saveHTML($childNode);
        }

        return $html;
    }

    /**
     * Normalize role names for cleaner UI labels.
     */
    protected function normalizeEditorialRole(string $role): string
    {
        $role = html_entity_decode(strip_tags($role), ENT_QUOTES | ENT_HTML5, 'UTF-8');
        $role = preg_replace('/\s+/u', ' ', trim($role)) ?: '';

        $roleMap = [
            'Editorial Board Member' => 'Editorial Board',
            'Editorial Board Members' => 'Editorial Board',
        ];

        return $roleMap[$role] ?? $role;
    }

    /**
     * Convert a member name into a filesystem-safe photo slug.
     */
    protected function slugifyEditorialName(string $name): string
    {
        $value = strtolower(trim($name));
        $value = html_entity_decode($value, ENT_QUOTES | ENT_HTML5, 'UTF-8');

        $transliterated = @iconv('UTF-8', 'ASCII//TRANSLIT//IGNORE', $value);
        if (is_string($transliterated) && $transliterated !== '') {
            $value = $transliterated;
        }

        $value = preg_replace('/[^a-z0-9]+/', '-', $value) ?: '';
        $value = trim($value, '-');

        return $value !== '' ? $value : 'editor';
    }

    /**
     * Valid homepage statistics sourced from current journal data.
     */
    protected function getHomepageStats(int $contextId): array
    {
        try {
            $publishedArticles = Repo::submission()->getCollector()
                ->filterByContextIds([$contextId])
                ->filterByStatus([Submission::STATUS_PUBLISHED])
                ->getCount();

            $publishedIssues = Repo::issue()->getCollector()
                ->filterByContextIds([$contextId])
                ->filterByPublished(true)
                ->getCount();

            $announcements = Repo::announcement()->getCollector()
                ->filterByContextIds([$contextId])
                ->getCount();

            $sections = Repo::section()->getCollector()
                ->filterByContextIds([$contextId])
                ->getCount();
        } catch (\Throwable $exception) {
            $publishedArticles = 0;
            $publishedIssues = 0;
            $announcements = 0;
            $sections = 0;
        }

        $stats = [
            [
                'value' => (int) $publishedArticles,
                'label' => 'Published Articles',
                'tone' => 'articles',
            ],
            [
                'value' => (int) $publishedIssues,
                'label' => 'Published Issues',
                'tone' => 'issues',
            ],
            [
                'value' => (int) $announcements,
                'label' => 'Announcements',
                'tone' => 'announcements',
            ],
            [
                'value' => (int) $sections,
                'label' => 'Sections',
                'tone' => 'sections',
            ],
        ];

        $maxValue = max(array_map(static fn ($stat) => (int) $stat['value'], $stats));
        foreach ($stats as &$stat) {
            $value = (int) $stat['value'];
            $stat['percent'] = $maxValue > 0 ? max(8, (int) round(($value / $maxValue) * 100)) : 8;
            $stat['value'] = (string) $value;
        }
        unset($stat);

        return $stats;
    }

    /**
     * Build cover-card sliders for article recommendation blocks.
     *
     * @param \Traversable $authorUserGroups
     */
    protected function getArticleRecommendationSliders(
        Submission $article,
        $publication,
        int $contextId,
        \Traversable $authorUserGroups,
        $request
    ): array {
        $sliders = [];
        $limit = 10;

        $sameAuthorPlugin = PluginRegistry::loadPlugin('generic', 'recommendByAuthor', $contextId);
        if ($sameAuthorPlugin && $sameAuthorPlugin->getEnabled($contextId)) {
            $sameAuthorIds = $this->getSameAuthorSubmissionIds($article, $publication, $contextId);
            $sameAuthorCards = $this->prepareHomepageArticleCards(
                $this->submissionIdsToPublishedList($sameAuthorIds, $contextId, $limit),
                $contextId,
                $authorUserGroups
            );
            if (!empty($sameAuthorCards)) {
                $sliders[] = [
                    'key' => 'sameAuthor',
                    'title' => __('plugins.generic.recommendByAuthor.heading'),
                    'items' => $sameAuthorCards,
                ];
            }
        }

        $similarityPlugin = PluginRegistry::loadPlugin('generic', 'recommendBySimilarity', $contextId);
        if ($similarityPlugin && $similarityPlugin->getEnabled($contextId)) {
            $similarData = $this->getSimilarSubmissionIds($article, $contextId, $limit);
            if (!empty($similarData['ids'])) {
                $similarCards = $this->prepareHomepageArticleCards(
                    $this->submissionIdsToPublishedList($similarData['ids'], $contextId, $limit),
                    $contextId,
                    $authorUserGroups
                );
                if (!empty($similarCards)) {
                    $searchUrl = $request->getDispatcher()->url(
                        $request,
                        Application::ROUTE_PAGE,
                        $request->getContext()->getPath(),
                        'search',
                        'search',
                        null,
                        ['query' => $similarData['query']]
                    );
                    $sliders[] = [
                        'key' => 'similarity',
                        'title' => __('plugins.generic.recommendBySimilarity.heading'),
                        'items' => $similarCards,
                        'searchUrl' => $searchUrl,
                        'searchQuery' => $similarData['query'],
                    ];
                }
            }
        }

        return $sliders;
    }

    /**
     * Resolve submission IDs for articles by the same author(s).
     */
    protected function getSameAuthorSubmissionIds(Submission $displayedArticle, $publication, int $contextId): array
    {
        if (!$publication) {
            return [];
        }

        $foundArticles = [];
        foreach ($publication->getData('authors') as $author) {
            if (!$author instanceof Author) {
                continue;
            }

            $authorsIterator = Repo::author()
                ->getCollector()
                ->filterByContextIds([$contextId])
                ->filterByName($author->getLocalizedGivenName(), $author->getLocalizedFamilyName())
                ->getMany();

            $publicationIds = [];
            foreach ($authorsIterator as $matchedAuthor) {
                $publicationIds[] = $matchedAuthor->getData('publicationId');
            }

            $submissionIds = array_map(function ($publicationId) {
                $matchedPublication = Repo::publication()->get((int) $publicationId);
                if (
                    !$matchedPublication
                    || (int) $matchedPublication->getData('status') !== PKPSubmission::STATUS_PUBLISHED
                ) {
                    return null;
                }

                return (int) $matchedPublication->getData('submissionId');
            }, array_unique($publicationIds));

            $foundArticles = array_merge($foundArticles, array_filter($submissionIds));
        }

        $results = array_values(array_unique(array_filter(
            $foundArticles,
            static fn ($submissionId) => (int) $submissionId !== (int) $displayedArticle->getId()
        )));

        if (empty($results)) {
            return [];
        }

        $statsReport = Services::get('publicationStats')->getTotals([
            'contextIds' => [$contextId],
            'submissionIds' => $results,
            'assocTypes' => [Application::ASSOC_TYPE_SUBMISSION, Application::ASSOC_TYPE_SUBMISSION_FILE],
        ]);

        $orderedResults = [];
        foreach ($statsReport as $reportRow) {
            $orderedResults[] = (int) $reportRow->{StatisticsHelper::STATISTICS_DIMENSION_SUBMISSION_ID};
        }

        $remainingResults = array_values(array_diff($results, $orderedResults));
        sort($remainingResults);

        return array_merge($orderedResults, $remainingResults);
    }

    /**
     * Resolve submission IDs for similar articles from keyword search.
     *
     * @return array{ids: array<int>, query: string}
     */
    protected function getSimilarSubmissionIds(Submission $article, int $contextId, int $limit): array
    {
        $searchPhrase = implode(' ', (new ArticleSearch())->getSimilarityTerms((int) $article->getId()));
        $searchPhrase = trim($searchPhrase);
        if ($searchPhrase === '') {
            return ['ids' => [], 'query' => ''];
        }

        $submissions = Repo::submission()->getCollector()
            ->excludeIds([(int) $article->getId()])
            ->filterByContextIds([$contextId])
            ->filterByStatus([Submission::STATUS_PUBLISHED])
            ->searchPhrase($searchPhrase, 20)
            ->limit($limit)
            ->orderBy(SubmissionCollector::ORDERBY_SEARCH_RANKING)
            ->getMany();

        $ids = [];
        foreach ($submissions as $submission) {
            $ids[] = (int) $submission->getId();
        }

        return [
            'ids' => $ids,
            'query' => $searchPhrase,
        ];
    }

    /**
     * Fetch published submissions by ID while preserving order.
     *
     * @param array<int> $submissionIds
     * @return Submission[]
     */
    protected function submissionIdsToPublishedList(array $submissionIds, int $contextId, int $limit): array
    {
        $items = [];
        foreach ($submissionIds as $submissionId) {
            if (count($items) >= $limit) {
                break;
            }

            $submission = Repo::submission()->get((int) $submissionId, $contextId);
            if (!$submission || (int) $submission->getData('status') !== Submission::STATUS_PUBLISHED) {
                continue;
            }

            $items[] = $submission;
        }

        return $items;
    }

    /**
     * Read real usage statistics for a single article page.
     */
    protected function getArticleUsageStats(int $contextId, int $submissionId): array
    {
        $views = 0;
        $downloads = 0;

        try {
            $metrics = Services::get('publicationStats')->getTotalsByType($submissionId, $contextId, null, null);
            $views = (int) ($metrics['abstract'] ?? 0);
            $downloads = (int) ($metrics['pdf'] ?? 0) + (int) ($metrics['html'] ?? 0) + (int) ($metrics['other'] ?? 0);
        } catch (\Throwable $exception) {
            $views = 0;
            $downloads = 0;
        }

        return [
            'views' => $views,
            'downloads' => $downloads,
            'hasStats' => ($views > 0 || $downloads > 0),
        ];
    }

    /**
     * Shared sidebar data for inner pages.
     */
    protected function getSidebarEnhancementData($context, $request): array
    {
        $baseUrl = $request->getBaseUrl();
        $contextId = (int) $context->getId();
        $editorialMembers = array_slice($this->getEditorialTeamMembers($context, $baseUrl), 0, 3);

        return [
            'jkcSidebarRenderEnhancements' => true,
            'jkcSidebarEditorialMembers' => $editorialMembers,
            'jkcSidebarEditorialUrl' => rtrim($baseUrl, '/') . '/index.php/' . $context->getPath() . '/about/editorialMasthead',
            'jkcSidebarTools' => $this->getHomepageTools($contextId, $baseUrl),
            'jkcSidebarTemplateLink' => $this->getJournalTemplateLink($contextId),
            'jkcSidebarPublisher' => $this->getSidebarPublisherData($context, $baseUrl),
            'jkcSidebarStats' => $this->getHomepageStats($contextId),
            'jkcSidebarVolumes' => $this->getSidebarPublishedVolumes($context, $request),
            'jkcSidebarKeywords' => $this->getSidebarKeywords(),
        ];
    }

    /**
     * Publisher panel data with local PNG fallback.
     */
    protected function getSidebarPublisherData($context, string $baseUrl): array
    {
        $imageDir = __DIR__ . DIRECTORY_SEPARATOR . 'assets' . DIRECTORY_SEPARATOR . 'images' . DIRECTORY_SEPARATOR . 'publisher' . DIRECTORY_SEPARATOR;
        $imageUrl = rtrim($baseUrl, '/') . '/plugins/themes/sistekModern/assets/images/publisher/publisher-placeholder.svg';
        $imageExists = false;

        if (file_exists($imageDir . 'publisher.png')) {
            $imageUrl = rtrim($baseUrl, '/') . '/plugins/themes/sistekModern/assets/images/publisher/publisher.png';
            $imageExists = true;
        }

        return [
            'name' => (string) ($context->getData('publisherInstitution') ?: 'SISTEK Editorial Office'),
            'imageUrl' => $imageUrl,
            'imageExists' => $imageExists,
        ];
    }

    /**
     * Published issues grouped by year for sidebar accordion.
     *
     * @return array<int, array<string, mixed>>
     */
    protected function getSidebarPublishedVolumes($context, $request): array
    {
        try {
            $issues = Repo::issue()->getCollector()
                ->filterByContextIds([(int) $context->getId()])
                ->filterByPublished(true)
                ->getMany();
        } catch (\Throwable $exception) {
            return [];
        }

        $groups = [];
        foreach ($issues as $issue) {
            $year = trim((string) $issue->getYear());
            if ($year === '' && $issue->getDatePublished()) {
                $year = date('Y', strtotime((string) $issue->getDatePublished()));
            }
            if ($year === '') {
                $year = 'Published';
            }

            if (!isset($groups[$year])) {
                $groups[$year] = [];
            }

            $groups[$year][] = [
                'title' => (string) ($issue->getIssueSeries() ?: $issue->getLocalizedTitle() ?: 'Issue'),
                'url' => $request->getDispatcher()->url(
                    $request,
                    Application::ROUTE_PAGE,
                    $context->getPath(),
                    'issue',
                    'view',
                    [$issue->getBestIssueId()]
                ),
            ];
        }

        uksort($groups, static function ($left, $right) {
            if (ctype_digit((string) $left) && ctype_digit((string) $right)) {
                return (int) $right <=> (int) $left;
            }

            return strcmp((string) $right, (string) $left);
        });

        $result = [];
        $isFirst = true;
        foreach ($groups as $year => $items) {
            $result[] = [
                'year' => $year,
                'open' => $isFirst,
                'items' => $items,
            ];
            $isFirst = false;
        }

        return $result;
    }

    /**
     * Scope keywords used as a compact sidebar reference.
     */
    protected function getSidebarKeywords(): array
    {
        return [
            'Sistem Informasi',
            'Teknologi Informasi',
            'Rekayasa Perangkat Lunak',
            'Analisis dan Perancangan Sistem',
            'Basis Data',
            'Kecerdasan Buatan',
            'Jaringan Komputer',
            'Keamanan Siber',
            'E-Government',
            'E-Commerce',
            'Digitalisasi UMKM',
        ];
    }
}

if (!PKP_STRICT_MODE) {
    class_alias('\\APP\\plugins\\themes\\sistekModern\\SistekModernThemePlugin', '\\SistekModernThemePlugin');
}
