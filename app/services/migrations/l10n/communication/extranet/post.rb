class Migrations::L10n::Communication::Extranet::Post < Migrations::L10n::Base
  def self.execute
    migrate_posts
    migrate_categories
  end

  def self.migrate_posts
    Communication::Extranet::Post.find_each do |object|
      about_id = object.id

      l10n = Communication::Extranet::Post::Localization.create(
        featured_image_alt: object.featured_image_alt,
        featured_image_credit: object.featured_image_credit,
        pinned: object.pinned,
        published: object.published,
        published_at: object.published_at,
        slug: object.slug,
        summary: object.summary,
        title: object.title,
        
        about_id: about_id,
        language_id: object.university.default_language_id,
        extranet_id: object.extranet_id,
        university_id: object.university_id,
        created_at: object.created_at
      )

      object.translate_contents!(l10n)
      object.translate_attachment(l10n, :featured_image)

      l10n.save
    end
  end

  def self.migrate_categories
    Communication::Extranet::Post::Category.find_each do |object|
      about_id = object.id

      l10n = Communication::Extranet::Post::Category::Localization.create(
        name: object.name,
        slug: object.slug,
        
        about_id: about_id,
        language_id: object.university.default_language_id,
        extranet_id: object.extranet_id,
        university_id: object.university_id,
        created_at: object.created_at
      )

      l10n.save
    end
  end
end