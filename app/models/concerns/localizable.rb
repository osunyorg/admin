module Localizable
  extend ActiveSupport::Concern

  included do
    # Depracted ?
    attr_accessor :newly_translated

    has_many    :localizations,
                foreign_key: :about_id,
                inverse_of: :about,
                dependent: :destroy

    # TODO L10N : Deprecated
    belongs_to  :language,
                optional: true
    belongs_to  :original,
                class_name: base_class.to_s,
                optional: true
    has_many    :translations,
                class_name: base_class.to_s,
                foreign_key: :original_id,
                dependent: :destroy if connection.column_exists?(table_name, :original_id)
    # /Deprecated

    accepts_nested_attributes_for :localizations

    # TODO L10N : remove
    # on cherche les objets pour cette langue (original ou pas) + les objets originaux dans une autre langue s'il n'en existe pas de traduction
    # scope :in_closest_language_id, -> (language_id) {
    #   # Records with correct language (Original or Translation)
    #   # OR Records originals which does not have any translation matching the language
    #   for_language_id(language_id).or(
    #     where(original_id: nil)
    #       .where.not(language_id: language_id)
    #       .where(
    #         "NOT EXISTS (SELECT 1 FROM #{table_name} AS translations WHERE translations.original_id = #{table_name}.id AND translations.language_id = ?)",
    #         language_id
    #       )
    #   )
    # }

    # TODO L10N : remove after data cleanup
    scope :tmp_original, -> { where(original_id: nil) }

    scope :for_language, -> (language) { for_language_id(language.id) }
    # The for_language_id scope can be used when you have the ID without needing to load the Language itself
    scope :for_language_id, -> (language_id) {
      # We get the table name of the localizations association to filter the language correctly
      localizations_table_name = _reflect_on_association(:localizations).klass.table_name
      joins(:localizations).where(localizations_table_name => { language_id: language_id })
    }

  end

  def localizable?
    true
  end

  def available_languages
    @available_languages ||= begin
      languages = is_direct_object? && !is_a?(Communication::Website) ? website.languages : university.languages
      languages.ordered
    end
  end

  def localization_for(language)
    localizations.find_by(language_id: language.id)
  end

  def original_localization
    @original_localization ||= localizations.order(:created_at).first
  end

  def best_localization_for(language)
    localization_for(language) || original_localization
  end

  def localize_in!(language)
    original_localization.localize_in!(language)
  end

  def exists_in_language?(language)
    localization_for(language).present?
  end
  alias :localized_in? :exists_in_language?

  def published_in?(language)
    l10n = localization_for(language)
    if l10n.respond_to?(:published?)
      l10n.published?
    else
      # La localisation n'a pas de statut de publication, on vérifie seulement son existence
      l10n.present?
    end
  end

  def to_s_in(language)
    best_localization_for(language).to_s
  end

  # TODO L10N : to remove
  ### DEPRECATED METHODS - has to be removed when cleaning L10N

  # On déclare l'objet syncable pour que l'analyse puisse se poursuivre jusqu'aux localisations.
  # Il n'y aura pas d'effet lié à la page elle-même.
  # Peut-être faudrait-il travailler directement sur les localisations, mais c'est une grosse refonte.
  def syncable?
    true
  end

  # TODO L10N : Used in migration, to remove
  def translate_contents!(translation)
    blocks.without_heading.ordered.each do |block|
      block.localize_for!(translation)
    end

    headings.root.ordered.each do |heading|
      heading.localize_for!(translation)
    end
  end

  # deprecated
  # Utility method to duplicate attachments
  # TODO L10N : Used in migration (via translate_other_attachments), to remove
  def translate_attachment(translation, attachment_name)
    translation.public_send(attachment_name).attach(
      io: URI.open(public_send(attachment_name).url),
      filename: public_send(attachment_name).filename.to_s,
      content_type: public_send(attachment_name).content_type
    )
  rescue
    # Missing attachment
  end

  # deprecated
  # can be overwritten in model
  # TODO L10N : Used in migration, to remove
  def translate_other_attachments(translation)
  end

end