module Localizable
  extend ActiveSupport::Concern

  included do
    has_many    :localizations,
                foreign_key: :about_id,
                inverse_of: :about,
                dependent: :destroy

    accepts_nested_attributes_for :localizations

    scope :for_language, -> (language) { for_language_id(language.id) }
    # The for_language_id scope can be used when you have the ID without needing to load the Language itself
    scope :for_language_id, -> (language_id) {
      # We get the table name of the localizations association to filter the language correctly
      l10n_table_name = _reflect_on_association(:localizations).klass.table_name
      joins(:localizations).where(l10n_table_name => { language_id: language_id })
    }

    scope :published_now_in, -> (language) {
      l10n_klass = _reflect_on_association(:localizations).klass
      return for_language(language) unless l10n_klass.respond_to?(:published_now)
      # TODO L10N : Use this when base models are cleaned from publication attributes (published && published_at)
      # for_language(language).merge(l10n_klass.published_now)
      # instead of big joins below
      l10n_table_name = l10n_klass.table_name
      for_language(language)
        .where(l10n_table_name => { published: true })
        .where("#{l10n_table_name}.published_at <= ?", Time.zone.now)
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