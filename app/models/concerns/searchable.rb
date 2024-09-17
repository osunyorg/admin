module Searchable
  extend ActiveSupport::Concern

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
      search.text = build_search_text(l10n)
      search.save
    end
  end

  def build_search_text(l10n)
    text = l10n.to_s
    self.class::SEARCH_FIELDS.each do |property|
      text += l10n.send property
      text += ' '
    end
    # TODO add blocks
    text
  end
end
