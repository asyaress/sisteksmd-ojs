<?php

/**
 * Setup SISTEK Modern theme, primary navigation, and custom journal pages.
 *
 * Run from the OJS root:
 * php tools/setupSistekModern.php
 */

$root = dirname(__DIR__);
$configPath = $root . DIRECTORY_SEPARATOR . 'config.inc.php';

if (!is_file($configPath)) {
    fwrite(STDERR, "config.inc.php not found. Run this script from an OJS installation.\n");
    exit(1);
}

$config = parse_ini_file($configPath, true, INI_SCANNER_RAW);
if (!$config || empty($config['database'])) {
    fwrite(STDERR, "Unable to read database settings from config.inc.php.\n");
    exit(1);
}

$db = $config['database'];
$mysqli = @new mysqli(
    $db['host'] ?? 'localhost',
    $db['username'] ?? '',
    $db['password'] ?? '',
    $db['name'] ?? ''
);

if ($mysqli->connect_error) {
    fwrite(STDERR, "Database connection failed: {$mysqli->connect_error}\n");
    exit(1);
}

$mysqli->set_charset('utf8mb4');

function q(mysqli $mysqli, string $sql): void
{
    if (!$mysqli->query($sql)) {
        throw new RuntimeException($mysqli->error . "\nSQL: " . $sql);
    }
}

function one(mysqli $mysqli, string $sql): ?string
{
    $result = $mysqli->query($sql);
    if (!$result) {
        throw new RuntimeException($mysqli->error . "\nSQL: " . $sql);
    }

    $row = $result->fetch_row();
    return $row ? (string) $row[0] : null;
}

function esc(mysqli $mysqli, ?string $value): string
{
    return "'" . $mysqli->real_escape_string((string) $value) . "'";
}

function getOrCreateMenuItem(mysqli $mysqli, int $journalId, ?string $path, string $type): int
{
    $pathWhere = $path === null ? 'path IS NULL' : 'path = ' . esc($mysqli, $path);
    $id = one(
        $mysqli,
        "SELECT navigation_menu_item_id FROM navigation_menu_items
         WHERE context_id = {$journalId} AND type = " . esc($mysqli, $type) . " AND {$pathWhere}
         ORDER BY navigation_menu_item_id LIMIT 1"
    );

    if ($id !== null) {
        return (int) $id;
    }

    $pathValue = $path === null ? 'NULL' : esc($mysqli, $path);
    q(
        $mysqli,
        "INSERT INTO navigation_menu_items (context_id, path, type)
         VALUES ({$journalId}, {$pathValue}, " . esc($mysqli, $type) . ")"
    );

    return (int) $mysqli->insert_id;
}

function setItemSetting(mysqli $mysqli, int $itemId, string $locale, string $name, string $value, string $type = 'string'): void
{
    q(
        $mysqli,
        "DELETE FROM navigation_menu_item_settings
         WHERE navigation_menu_item_id = {$itemId}
           AND locale = " . esc($mysqli, $locale) . "
           AND setting_name = " . esc($mysqli, $name)
    );

    q(
        $mysqli,
        "INSERT INTO navigation_menu_item_settings
         (navigation_menu_item_id, locale, setting_name, setting_value, setting_type)
         VALUES ({$itemId}, " . esc($mysqli, $locale) . ', ' . esc($mysqli, $name) . ', ' . esc($mysqli, $value) . ', ' . esc($mysqli, $type) . ')'
    );
}

function setAssignmentSetting(mysqli $mysqli, int $assignmentId, string $locale, string $name, string $value, string $type = 'string'): void
{
    q(
        $mysqli,
        "DELETE FROM navigation_menu_item_assignment_settings
         WHERE navigation_menu_item_assignment_id = {$assignmentId}
           AND locale = " . esc($mysqli, $locale) . "
           AND setting_name = " . esc($mysqli, $name)
    );

    q(
        $mysqli,
        "INSERT INTO navigation_menu_item_assignment_settings
         (navigation_menu_item_assignment_id, locale, setting_name, setting_value, setting_type)
         VALUES ({$assignmentId}, " . esc($mysqli, $locale) . ', ' . esc($mysqli, $name) . ', ' . esc($mysqli, $value) . ', ' . esc($mysqli, $type) . ')'
    );
}

function setLocalizedItemSetting(mysqli $mysqli, int $itemId, string $name, string $value, string $type = 'string'): void
{
    foreach (['id', 'id_ID', 'en', 'en_US'] as $locale) {
        setItemSetting($mysqli, $itemId, $locale, $name, $value, $type);
    }
}

function clearItemSetting(mysqli $mysqli, int $itemId, string $name): void
{
    q(
        $mysqli,
        "DELETE FROM navigation_menu_item_settings
         WHERE navigation_menu_item_id = {$itemId}
           AND setting_name = " . esc($mysqli, $name)
    );
}

function setLocalizedAssignmentSetting(mysqli $mysqli, int $assignmentId, string $name, string $value, string $type = 'string'): void
{
    foreach (['id', 'id_ID', 'en', 'en_US'] as $locale) {
        setAssignmentSetting($mysqli, $assignmentId, $locale, $name, $value, $type);
    }
}

try {
    $journalId = (int) one($mysqli, "SELECT journal_id FROM journals WHERE path = 'sistek-smd' LIMIT 1");
    if (!$journalId) {
        throw new RuntimeException("Journal path 'sistek-smd' not found.");
    }

    $baseUrl = rtrim($config['general']['base_url'] ?? 'https://sisteksmd.org', '/');
    $journalUrl = $baseUrl . '/index.php/sistek-smd';

    $mysqli->begin_transaction();

    q($mysqli, "DELETE FROM versions WHERE product_type = 'plugins.themes' AND product = 'sistekModern'");
    q(
        $mysqli,
        "INSERT INTO versions
        (major, minor, revision, build, date_installed, current, product_type, product, product_class_name, lazy_load, sitewide)
        VALUES
        (1, 0, 0, 0, NOW(), 1, 'plugins.themes', 'sistekModern', 'SistekModernThemePlugin', 1, 0)"
    );

    q($mysqli, "DELETE FROM journal_settings WHERE journal_id = {$journalId} AND setting_name = 'themePluginPath'");
    q(
        $mysqli,
        "INSERT INTO journal_settings (journal_id, locale, setting_name, setting_value)
         VALUES ({$journalId}, '', 'themePluginPath', 'sistekModern')"
    );

    q(
        $mysqli,
        "DELETE FROM plugin_settings
         WHERE plugin_name = 'sistekmodernthemeplugin'
           AND setting_name = 'enabled'
           AND (context_id = {$journalId} OR context_id IS NULL)"
    );
    q(
        $mysqli,
        "INSERT INTO plugin_settings (plugin_name, context_id, setting_name, setting_value, setting_type)
         VALUES
         ('sistekmodernthemeplugin', NULL, 'enabled', '1', 'bool'),
         ('sistekmodernthemeplugin', {$journalId}, 'enabled', '1', 'bool')"
    );

    $menuId = one($mysqli, "SELECT navigation_menu_id FROM navigation_menus WHERE context_id = {$journalId} AND area_name = 'primary' LIMIT 1");
    if ($menuId === null) {
        q(
            $mysqli,
            "INSERT INTO navigation_menus (context_id, area_name, title)
             VALUES ({$journalId}, 'primary', 'Primary Navigation Menu')"
        );
        $menuId = (string) $mysqli->insert_id;
    }
    $menuId = (int) $menuId;

    $home = getOrCreateMenuItem($mysqli, $journalId, '', 'NMI_TYPE_REMOTE_URL');
    setLocalizedItemSetting($mysqli, $home, 'title', 'HOME');
    setLocalizedItemSetting($mysqli, $home, 'remoteUrl', $journalUrl);

    $customPages = [
        'reviewer' => [
            'Reviewer',
            '<p>Reviewer atau mitra bestari SISTEK-SMD berperan menjaga kualitas ilmiah, objektivitas penilaian, dan integritas akademik setiap naskah yang diterima.</p><p>Daftar reviewer dapat diperbarui secara berkala sesuai perkembangan tim penelaah dan kebutuhan bidang keilmuan jurnal.</p>',
        ],
        'focusnscope' => [
            'Focus and Scope',
            '<p>Jurnal Sistem Informasi dan Teknologi STMIK Samarinda (SISTEK-SMD) berfokus pada publikasi hasil penelitian, kajian ilmiah, dan inovasi di bidang Sistem Informasi, Teknologi Informasi, dan Ilmu Komputer.</p><p>Ruang lingkup jurnal mencakup pengembangan sistem informasi, rekayasa perangkat lunak, analisis dan perancangan sistem, basis data, kecerdasan buatan, jaringan komputer, keamanan siber, e-government, e-commerce, digitalisasi UMKM, serta aplikasi teknologi informasi dalam berbagai bidang.</p>',
        ],
        'ethics' => [
            'Publication Ethics',
            '<p>Kebijakan etika publikasi SISTEK-SMD mengacu pada prinsip-prinsip COPE. Penulis, editor, reviewer, dan penerbit wajib menjaga integritas akademik, objektivitas, transparansi, serta menghindari plagiarisme, fabrikasi data, falsifikasi, duplikasi publikasi, dan konflik kepentingan.</p>',
        ],
        'peer-review' => [
            'Peer-Review Process',
            '<p>SISTEK-SMD menerapkan proses double-blind peer review. Identitas penulis dan reviewer dijaga selama proses penelaahan untuk mendukung objektivitas penilaian.</p><p>Alur editorial dimulai dari submit naskah, pemeriksaan awal oleh editor, pemeriksaan fokus dan scope, pengecekan similaritas, review, keputusan editorial, revisi, copyediting, layout, proofreading, hingga publikasi.</p>',
        ],
        'publication-charge' => [
            'Article Publication Charge',
            '<p>Jurnal Sistem Informasi dan Teknologi STMIK Samarinda (SISTEK-SMD) tidak mengenakan biaya kepada penulis untuk proses submit, review, maupun publikasi artikel.</p><p>Kebijakan ini disebut No Article Processing Charge (No APC).</p>',
        ],
        'open-access' => [
            'Open-Access Policy',
            '<p>SISTEK-SMD adalah jurnal akses terbuka. Semua artikel yang diterbitkan dapat diakses secara gratis oleh pembaca tanpa biaya berlangganan.</p>',
        ],
        'plagiarism' => [
            'Plagiarism Policy',
            '<p>SISTEK-SMD memiliki kebijakan anti-plagiarisme. Setiap naskah yang masuk dapat diperiksa tingkat similaritasnya menggunakan perangkat lunak pendeteksi plagiasi seperti Turnitin atau perangkat lain yang relevan.</p>',
        ],
        'indexing' => [
            'Indexing',
            '<p>SISTEK-SMD melakukan pengelolaan metadata, pengarsipan, dan kesiapan indeksasi secara bertahap sesuai standar jurnal ilmiah elektronik.</p><p>Jurnal menyiapkan dukungan untuk Google Scholar, GARUDA, Crossref, Dimensions, WorldCat, PKP Preservation Network, dan pengindeks relevan lain.</p>',
        ],
    ];

    foreach ($customPages as $path => [$title, $content]) {
        $itemId = getOrCreateMenuItem($mysqli, $journalId, $path, 'NMI_TYPE_CUSTOM');
        setLocalizedItemSetting($mysqli, $itemId, 'title', $title);
        setLocalizedItemSetting($mysqli, $itemId, 'content', $content);
    }

    $standardTypes = [
        'submissions' => 'NMI_TYPE_SUBMISSIONS',
        'current' => 'NMI_TYPE_CURRENT',
        'archives' => 'NMI_TYPE_ARCHIVES',
        'announcements' => 'NMI_TYPE_ANNOUNCEMENTS',
        'aboutParent' => 'NMI_TYPE_ABOUT',
        'masthead' => 'NMI_TYPE_MASTHEAD',
        'privacy' => 'NMI_TYPE_PRIVACY',
        'contact' => 'NMI_TYPE_CONTACT',
    ];

    foreach ($standardTypes as $key => $type) {
        $$key = getOrCreateMenuItem($mysqli, $journalId, null, $type);
    }

    $aboutIds = [];
    $result = $mysqli->query("SELECT navigation_menu_item_id FROM navigation_menu_items WHERE context_id = {$journalId} AND type = 'NMI_TYPE_ABOUT' ORDER BY navigation_menu_item_id");
    while ($row = $result->fetch_row()) {
        $aboutIds[] = (int) $row[0];
    }
    $aboutChild = $aboutIds[0] ?? $aboutParent;
    $aboutParent = count($aboutIds) > 1 ? end($aboutIds) : $aboutParent;

    $titles = [
        $submissions => 'SUBMISSIONS',
        $current => 'CURRENT',
        $archives => 'ARCHIVES',
        $announcements => 'ANNOUNCEMENTS',
        $aboutParent => 'ABOUT',
        $aboutChild => 'About the Journal',
        $masthead => 'Editorial Team',
        $privacy => 'Privacy Statement',
        $contact => 'Contact',
    ];
    foreach ($titles as $itemId => $title) {
        $itemId = (int) $itemId;
        clearItemSetting($mysqli, $itemId, 'titleLocaleKey');
        setLocalizedItemSetting($mysqli, $itemId, 'title', $title);
    }

    q($mysqli, "DELETE FROM navigation_menu_item_assignments WHERE navigation_menu_id = {$menuId}");
    $assignments = [
        [$home, 'NULL', 0],
        [$submissions, 'NULL', 1],
        [$current, 'NULL', 2],
        [$archives, 'NULL', 3],
        [$announcements, 'NULL', 4],
        [$aboutParent, 'NULL', 5],
        [$aboutChild, (string) $aboutParent, 0],
        [$masthead, (string) $aboutParent, 1],
        [$privacy, (string) $aboutParent, 2],
        [$contact, (string) $aboutParent, 3],
    ];

    $assignmentTitles = [
        $home => 'HOME',
        $submissions => 'SUBMISSIONS',
        $current => 'CURRENT',
        $archives => 'ARCHIVES',
        $announcements => 'ANNOUNCEMENTS',
        $aboutParent => 'ABOUT',
        $aboutChild => 'About the Journal',
        $masthead => 'Editorial Team',
        $privacy => 'Privacy Statement',
        $contact => 'Contact',
    ];

    foreach ($assignments as [$itemId, $parentId, $seq]) {
        q(
            $mysqli,
            "INSERT INTO navigation_menu_item_assignments
             (navigation_menu_id, navigation_menu_item_id, parent_id, seq)
             VALUES ({$menuId}, {$itemId}, {$parentId}, {$seq})"
        );

        $assignmentId = (int) $mysqli->insert_id;
        if (isset($assignmentTitles[$itemId])) {
            setLocalizedAssignmentSetting($mysqli, $assignmentId, 'title', $assignmentTitles[$itemId]);
        }
    }

    $mysqli->commit();

    foreach (['cache/t_compile', 'cache/t_cache', 'cache/_db'] as $cacheDir) {
        $dir = $root . DIRECTORY_SEPARATOR . str_replace('/', DIRECTORY_SEPARATOR, $cacheDir);
        if (is_dir($dir)) {
            $files = new RecursiveIteratorIterator(
                new RecursiveDirectoryIterator($dir, FilesystemIterator::SKIP_DOTS),
                RecursiveIteratorIterator::CHILD_FIRST
            );
            foreach ($files as $file) {
                $file->isDir() ? @rmdir($file->getPathname()) : @unlink($file->getPathname());
            }
        }
    }

    echo "SISTEK Modern setup complete for journal_id {$journalId}.\n";
    echo "Primary menu id: {$menuId}\n";
    echo "Theme: sistekModern\n";
} catch (Throwable $e) {
    $mysqli->rollback();
    fwrite(STDERR, "Setup failed: " . $e->getMessage() . "\n");
    exit(1);
}
