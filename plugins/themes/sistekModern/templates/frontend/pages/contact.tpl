{**
 * plugins/themes/sistekModern/templates/frontend/pages/contact.tpl
 *
 * Minimal contact page override for the SISTEK Modern theme.
 * Keeps OJS contact data intact while presenting it in a cleaner layout.
 *}
{include file="frontend/components/header.tpl" pageTitle="about.contact"}

<div class="page page_contact jkc-contact-page">
	{include file="frontend/components/breadcrumbs.tpl" currentTitleKey="about.contact"}

	<section class="jkc-contact-shell">
		<p class="jkc-contact-shell__eyebrow">Journal Information</p>
		<h1>{translate key="about.contact"}</h1>
		<p class="jkc-contact-shell__summary">Reach the editorial office for manuscript communication, technical support, and general journal coordination.</p>
		{include file="frontend/components/editLink.tpl" page="management" op="settings" path="context" anchor="contact" sectionTitleKey="about.contact"}

		<div class="jkc-contact-grid">
			{if $contactTitle || $contactName || $contactAffiliation || $contactPhone || $contactEmail}
				<article class="jkc-contact-card jkc-contact-card--primary">
					<div class="jkc-contact-card__header">
						<span class="jkc-contact-card__icon fa fa-user-circle-o" aria-hidden="true"></span>
						<div>
							<p class="jkc-contact-card__eyebrow">Editorial Office</p>
							<h2>{translate key="about.contact.principalContact"}</h2>
						</div>
					</div>

					<div class="jkc-contact-card__body">
						{if $contactName}
							<p class="jkc-contact-card__name">{$contactName|escape}</p>
						{/if}

						{if $contactTitle}
							<p class="jkc-contact-card__role">{$contactTitle|escape}</p>
						{/if}

						{if $contactAffiliation}
							<p class="jkc-contact-card__detail">{$contactAffiliation|strip_unsafe_html}</p>
						{/if}

						{if $contactPhone}
							<p class="jkc-contact-card__detail"><strong>Phone</strong> {$contactPhone|escape}</p>
						{/if}

						{if $contactEmail}
							<p class="jkc-contact-card__detail"><strong>Email</strong> {mailto address=$contactEmail encode='javascript'}</p>
						{/if}
					</div>
				</article>
			{/if}

			{if $supportName || $supportPhone || $supportEmail}
				<article class="jkc-contact-card jkc-contact-card--support">
					<div class="jkc-contact-card__header">
						<span class="jkc-contact-card__icon fa fa-life-ring" aria-hidden="true"></span>
						<div>
							<p class="jkc-contact-card__eyebrow">Technical Assistance</p>
							<h2>{translate key="about.contact.supportContact"}</h2>
						</div>
					</div>

					<div class="jkc-contact-card__body">
						{if $supportName}
							<p class="jkc-contact-card__name">{$supportName|escape}</p>
						{/if}

						{if $supportPhone}
							<p class="jkc-contact-card__detail"><strong>Phone</strong> {$supportPhone|escape}</p>
						{/if}

						{if $supportEmail}
							<p class="jkc-contact-card__detail"><strong>Email</strong> {mailto address=$supportEmail encode='javascript'}</p>
						{/if}
					</div>
				</article>
			{/if}

			{if $mailingAddress}
				<article class="jkc-contact-card jkc-contact-card--address">
					<div class="jkc-contact-card__header">
						<span class="jkc-contact-card__icon fa fa-map-marker" aria-hidden="true"></span>
						<div>
							<p class="jkc-contact-card__eyebrow">Postal Address</p>
							<h2>Mailing Address</h2>
						</div>
					</div>

					<div class="jkc-contact-card__body">
						<p class="jkc-contact-card__detail jkc-contact-card__detail--address">{$mailingAddress|nl2br|strip_unsafe_html}</p>
					</div>
				</article>
			{/if}
		</div>
	</section>
</div>

{include file="frontend/components/footer.tpl"}
