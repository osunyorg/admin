module Communication::Website::WithLanguages
  extend ActiveSupport::Concern

  included do
    attr_accessor :language_was_removed

    belongs_to :default_language, class_name: "Language"
    has_and_belongs_to_many :languages,
                            class_name: 'Language',
                            join_table: :communication_websites_languages,
                            foreign_key: :communication_website_id,
                            association_foreign_key: :language_id,
                            after_remove: :flag_languages_change
    has_many  :localizations,
              foreign_key: :communication_website_id,
              dependent: :destroy

    validates :languages, length: { minimum: 1 }
    validate :languages_must_include_default_language

  end

  def languages_except_default
    languages.where.not(id: default_language_id)
  end

  def best_language_for(iso_code)
    # We look for the language by the ISO code in the websites languages.
    # If not found, we fallback to the default language.
    languages.find_by(iso_code: iso_code) || default_language
  end

  def localization_for(language)
    return self if language.id == default_language_id
    localization = localizations.find_by(language_id: language.id)
    localization ||= self
    localization
  end

  def find_or_create_localization_for(language)
    return self if language.id == default_language_id
    localizations.find_or_create_by(language_id: language.id)
  end

  protected

  def languages_must_include_default_language
    errors.add(:languages, :must_include_default) unless language_ids.include?(default_language_id)
  end

  def flag_languages_change(_)
    @language_was_removed = true
  end

end
