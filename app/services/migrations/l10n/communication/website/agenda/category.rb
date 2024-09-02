class Migrations::L10n::Communication::Website::Agenda::Category < Migrations::L10n::Base
  def self.execute
    Communication::Website::Agenda::Category.find_each do |category|
      about_id = category.original_id || category.id
      next if Communication::Website::Agenda::Category::Localization.where(
        about_id: about_id,
        language_id: category.language_id
      ).exists?

      l10n = Communication::Website::Agenda::Category::Localization.create(
        featured_image_alt: category.featured_image_alt,
        featured_image_credit: category.featured_image_credit,
        meta_description: category.meta_description,
        name: category.name,
        slug: category.slug,
        path: category.path,

        about_id: about_id,
        language_id: category.language_id,
        communication_website_id: category.communication_website_id,
        university_id: category.university_id,
        created_at: category.created_at
      )

      category.translate_contents!(l10n)
      category.translate_attachment(l10n, :featured_image)

      duplicate_permalinks(category, l10n)

      l10n.save
    end
  end
end