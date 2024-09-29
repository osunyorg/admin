class Migrations::L10n::Communication::Website::Blog::Post < Migrations::L10n::Base
  def self.execute
    Communication::Website::Post.where(self.constraint).find_each do |post|
      puts "Migration post #{post.id}"

      about_id = post.original_id || post.id
      next if Communication::Website::Post::Localization.where(
        about_id: about_id,
        language_id: post.language_id
      ).exists?

      l10n = Communication::Website::Post::Localization.create(
        featured_image_alt: post.featured_image_alt,
        featured_image_credit: post.featured_image_credit,
        meta_description: post.meta_description,
        migration_identifier: post.migration_identifier,
        pinned: post.pinned,
        published: post.published,
        published_at: post.published_at,
        slug: post.slug,
        summary: post.summary,
        text: post.text,
        title: post.title,
        about_id: about_id,
        language_id: post.language_id,
        communication_website_id: post.communication_website_id,
        university_id: post.university_id,
        created_at: post.created_at
      )

      post.translate_contents!(l10n)
      post.translate_attachment(l10n, :featured_image)
      post.translate_other_attachments(l10n)

      duplicate_permalinks(post, l10n)
      reconnect_git_files(post, l10n)

      l10n.save
    end
  end
end