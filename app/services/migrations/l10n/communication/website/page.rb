class Migrations::L10n::Communication::Website::Page < Migrations::L10n::Base
  def self.execute
    Communication::Website::Page.where(self.constraint).find_each do |page|
      puts "Migration page #{page.id}"

      about_id = page.original_id || page.id
      next if Communication::Website::Page::Localization.where(
        about_id: about_id,
        language_id: page.language_id
      ).exists?

      l10n = Communication::Website::Page::Localization.create(
        breadcrumb_title: page.breadcrumb_title,
        featured_image_alt: page.featured_image_alt,
        featured_image_credit: page.featured_image_credit,
        header_cta: page.header_cta,
        header_cta_label: page.header_cta_label,
        header_cta_url: page.header_cta_url,
        header_text: page.header_text,
        meta_description: page.meta_description,
        migration_identifier: page.migration_identifier,
        published: page.published,
        published_at: page.published_at,
        slug: page.slug,
        summary: page.summary,
        text: page.text,
        title: page.title,
        about_id: about_id,
        language_id: page.language_id,
        communication_website_id: page.communication_website_id,
        university_id: page.university_id,
        created_at: page.created_at
      )

      page.translate_contents!(l10n)
      page.translate_attachment(l10n, :featured_image)
      page.translate_other_attachments(l10n)

      duplicate_permalinks(page, l10n)
      reconnect_git_files(page, l10n)

      l10n.save

      # If original page, we make sure that the parent is an original page
      if page.original_id.nil? && page.parent.present?
        parent_id = page.parent.original_id || page.parent.id
        page.update_column(:parent_id, parent_id)
      end
    end
  end
end