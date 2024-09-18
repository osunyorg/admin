module Searchable
  extend ActiveSupport::Concern

  SEARCH_FIELDS_OPTIONAL = [
    :biography,
    :text,
    :long_name
  ]

  included do
    after_save :save_search_data
  end

  protected

  def save_search_data
    localizations.each do |l10n|
      search = Search.where(
        university: university,
        about_object: self,
        about_localization: l10n,
        language: l10n.language
      ).first_or_create
      search.title = l10n.to_s
      search.text = build_search_text(l10n)
      search.save
    end
  end

  def build_search_text(l10n)
    text = l10n.to_s
    SEARCH_FIELDS_OPTIONAL.each do |property|
      next unless l10n.respond_to? property
      value = l10n.send property
      next unless value.present?
      text += "#{value} "
    end
    text += l10n.contents_full_text
    text
  end
end
