module University::WithLanguages
  extend ActiveSupport::Concern

  included do

    belongs_to :default_language, class_name: "Language"
    has_and_belongs_to_many :languages

    scope :for_language, -> (language_ids, language = nil) { joins(:languages).where(languages: { id: language_ids } ).distinct }

  end

  def best_language_for(iso_code)
    # if iso_code provided check if university contains current language
    # else fallback to the default university language.
    if iso_code.present?
      languages.find_by!(iso_code: iso_code)
    else
      default_language
    end
  end


end
