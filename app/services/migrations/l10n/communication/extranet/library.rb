class Migrations::L10n::Communication::Extranet::Library < Migrations::L10n::Base
  def self.execute
    migrate_documents
    migrate_categories
    migrate_kinds
  end

  def self.migrate_documents
    Communication::Extranet::Document.find_each do |object|
      # Les documents ne sont pas localisés
      about_id = object.id

      l10n = Communication::Extranet::Document::Localization.create(
        name: object.name,
        published: object.published,
        published_at: object.published_at,
        
        about_id: about_id,
        language_id: object.university.default_language_id,
        extranet_id: object.extranet_id,
        university_id: object.university_id,
        created_at: object.created_at
      )

      object.translate_attachment(l10n, :file)

      l10n.save
    end
  end

  def self.migrate_categories
    Communication::Extranet::Document::Category.find_each do |object|
      about_id = object.id

      l10n = Communication::Extranet::Document::Category::Localization.create(
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

  def self.migrate_kinds
    Communication::Extranet::Document::Kind.find_each do |object|
      about_id = object.id

      l10n = Communication::Extranet::Document::Kind::Localization.create(
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