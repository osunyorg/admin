class Migrations::L10n::University::Organization < Migrations::L10n::Base
  def self.execute
    migrate_localizations
    migrate_category_localizations
  end

  def self.migrate_localizations
    University::Organization.where(self.constraint).find_each do |orga|
      # If "old way" translation, we set the about to the original, else if "old way" master, we take its ID.
      about_id = orga.original_id || orga.id

      next if University::Organization::Localization.where(
        about_id: about_id,
        language_id: orga.language_id
      ).exists?

      l10n = University::Organization::Localization.create(
        address_additional: orga.address_additional,
        address_name: orga.address_name,
        linkedin: orga.linkedin,
        long_name: orga.long_name,
        mastodon: orga.mastodon,
        meta_description: orga.meta_description,
        name: orga.name,
        summary: orga.summary,
        text: orga.text,
        twitter: orga.twitter,
        url: orga.url,
        about_id: about_id,
        language_id: orga.language_id,
        university_id: orga.university_id,
        created_at: orga.created_at
      )

      # Copy from orga (old) to localization (new)
      orga.translate_contents!(l10n)
      orga.translate_other_attachments(l10n)

      duplicate_permalinks(orga, l10n)

      reconnect_git_files(orga, l10n)

      l10n.save
    end
  end

  def self.migrate_category_localizations
    University::Organization::Category.where(self.constraint).find_each do |category|
      about_id = category.original_id || category.id

      next if University::Organization::Category::Localization.where(
        about_id: about_id,
        language_id: category.language_id
      ).exists?

      l10n = University::Organization::Category::Localization.create(
        name: category.name,
        slug: category.slug,
        about_id: about_id,
        language_id: category.language_id,
        university_id: category.university_id,
        created_at: category.created_at
      )

      category.translate_contents!(l10n)

      duplicate_permalinks(category, l10n)
      reconnect_git_files(category, l10n)

      l10n.save

      # If original category, we make sure that the parent is an original category
      if category.original_id.nil? && category.parent.present?
        parent_id = category.parent.original_id || category.parent.id
        category.update_column(:parent_id, parent_id)
      end
    end
  end
end