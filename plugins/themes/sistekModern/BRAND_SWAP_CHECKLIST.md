# SISTEK Brand Swap Checklist

Theme clone lives in `plugins/themes/sistekModern`.

## OJS Settings

- Appearance > Journal Logo: upload SISTEK logo. The theme reads `pageHeaderLogoImage` automatically.
- Appearance > Favicon: upload SISTEK favicon.
- Masthead: set journal name, description, publisher, online ISSN, print ISSN, and contact details.
- Website > Navigation Menus: review links copied from the source journal content.
- Website > Sidebar / Custom Blocks: review blocks named template, indexing, tools, visitor/stat counter, and any external image URLs.
- Workflow > Submission: update author guidelines, checklist, copyright notice, and template links.

## Theme Assets

- `assets/images/sistek-logo-placeholder.svg`: fallback logo only; replace through OJS settings when possible.
- `assets/images/current-issue-cover.png`: fallback issue cover.
- `assets/images/feature-slide-1.png`, `feature-slide-2.png`, `feature-slide-3.png`: homepage feature visuals.
- `assets/images/indexing/`: indexing logos.
- `assets/images/tools/`: Grammarly, Mendeley, Turnitin visuals.
- `assets/images/contact/`: contact card banners.
- `assets/images/editorial-team/`: editorial profile photos.
- `assets/images/reviewers/`: reviewer profile photos.
- `assets/images/publisher/publisher.png`: optional publisher logo. If absent, the placeholder is used.

## Notes

- CSS classes still use the `jkc-` prefix intentionally to keep the copied design stable.
- Plugin identity, PHP namespace, asset paths, and display name have been renamed to `sistekModern`.
- Clear OJS cache after activation or after changing LESS/template files.
