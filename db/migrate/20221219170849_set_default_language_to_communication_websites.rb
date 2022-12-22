class SetDefaultLanguageToCommunicationWebsites < ActiveRecord::Migration[7.0]
  def change
    # From now on, all websites require at least one language.
    default_language = Language.find_by(iso_code: "fr")
    default_language ||= Language.first

    Communication::Website.where.missing(:languages).each do |website|
      website.update(languages: [default_language], default_language: default_language)
    end
  end
end
