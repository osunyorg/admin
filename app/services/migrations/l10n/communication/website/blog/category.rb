class Migrations::L10n::Communication::Website::Blog::Category < Migrations::L10n::Base
  def self.execute
    Communication::Website::Post::Category.where(self.constraint).find_each do |object|
      puts "Migration category #{object.id}"

      about_id = object.original_id || object.id
      next if Communication::Website::Post::Category::Localization.where(
        about_id: about_id,
        language_id: object.language_id
      ).exists?

      l10n = Communication::Website::Post::Category::Localization.create(
        featured_image_alt: object.featured_image_alt,
        featured_image_credit: object.featured_image_credit,
        meta_description: object.meta_description,
        slug: object.slug,
        path: object.path,
        summary: object.summary,
        name: object.name,
        about_id: about_id,
        language_id: object.language_id,
        communication_website_id: object.communication_website_id,
        university_id: object.university_id,
        created_at: object.created_at
      )

      object.translate_contents!(l10n)
      object.translate_other_attachments(l10n)

      duplicate_permalinks(object, l10n)
      reconnect_git_files(object, l10n)

      l10n.save

      # If original category, we make sure that the parent is an original category
      if object.original_id.nil? && object.parent.present?
        parent_id = object.parent.original_id || object.parent.id
        object.update_column(:parent_id, parent_id)
      end
    end
  end
end