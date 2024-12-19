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

  def save_search_data
    localizations.each do |l10n|
      search = Search.where(
        university: university,
        about_object: self,
        about_localization: l10n,
        website_id: search_data_website_id,
        extranet_id: search_data_extranet_id,
        language: l10n.language
      ).first_or_create
      search.title = l10n.to_s
      search.text = build_search_text(l10n)
      search.save
    end
  end

  protected

  def search_data_website_id
    return nil if is_a?(Communication::Website) # Websites are not parts of themselves
    return communication_website_id if respond_to?(:communication_website_id)
    return website_id if respond_to?(:website_id)
    nil
  end

  def search_data_extranet_id
    return nil if is_a?(Communication::Extranet) # Extranets are not parts of themselves
    return communication_extranet_id if respond_to?(:communication_extranet_id)
    return extranet_id if respond_to?(:extranet_id)
    nil
  end

  def build_search_text(l10n)
    text = l10n.to_s
    SEARCH_FIELDS_OPTIONAL.each do |property|
      value = l10n.try(property)
      text += " #{value}" if value.present?
    end
    text += " #{l10n.contents_full_text}"
    text
  end
end
