module Localizable
  extend ActiveSupport::Concern

  included do
    include GeneratesGitFiles

    has_many    :localizations,
                foreign_key: :about_id,
                inverse_of: :about,
                dependent: :destroy

    accepts_nested_attributes_for :localizations
    validates_associated :localizations

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
      for_language(language).merge(l10n_klass.published_now)
    }

  end

  def localizable?
    true
  end

  def available_languages
    @available_languages ||= begin
      if try(:is_direct_object?) && !is_a?(Communication::Website)
        languages = website.languages
      elsif respond_to?(:extranet)
        languages = extranet.languages
      else
        languages = university.languages
      end
      languages.ordered
    end
  end

  def localization_for(language)
    localizations.find_by(language_id: language.id)
  end
  alias :localized_in :localization_for

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

  protected

  def set_first_localization_as_published
    localizations.first.assign_attributes(
      published: true,
      published_at: Time.zone.now
    )
  end

end