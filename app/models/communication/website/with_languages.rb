module Communication::Website::WithLanguages
  extend ActiveSupport::Concern

  included do
    attr_accessor :language_was_removed

    belongs_to :default_language, class_name: "Language"
    has_and_belongs_to_many :languages,
                            class_name: 'Language',
                            join_table: 'communication_websites_languages',
                            foreign_key: :communication_website_id,
                            association_foreign_key: :language_id,
                            after_remove: :flag_languages_change

    validates :languages, length: { minimum: 1 }
    validate :languages_must_include_default_language

  end

  def best_language_for(iso_code)
    # We look for the language by the ISO code in the websites languages.
    # If not found, we fallback to the default language.
    languages.find_by(iso_code: iso_code) || default_language
  end

  protected

  def languages_must_include_default_language
    errors.add(:languages, :must_include_default) unless language_ids.include?(default_language_id)
  end

  def flag_languages_change(_)
    @language_was_removed = true
  end

end
