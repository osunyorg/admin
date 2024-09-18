# == Schema Information
#
# Table name: search
#
#  id                      :uuid             not null, primary key
#  about_localization_type :string           not null, indexed => [about_localization_id]
#  about_object_type       :string           not null, indexed => [about_object_id]
#  text                    :text
#  title                   :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  about_localization_id   :uuid             not null, indexed => [about_localization_type]
#  about_object_id         :uuid             not null, indexed => [about_object_type]
#  extranet_id             :uuid             indexed
#  language_id             :uuid             not null, indexed
#  university_id           :uuid             not null, indexed
#  website_id              :uuid             indexed
#
# Indexes
#
#  index_search_on_about_localization  (about_localization_type,about_localization_id)
#  index_search_on_about_object        (about_object_type,about_object_id)
#  index_search_on_extranet_id         (extranet_id)
#  index_search_on_language_id         (language_id)
#  index_search_on_university_id       (university_id)
#  index_search_on_website_id          (website_id)
#
# Foreign Keys
#
#  fk_rails_06e4ffc38b  (website_id => communication_websites.id)
#  fk_rails_62a3af3969  (extranet_id => communication_extranets.id)
#  fk_rails_bab17fceaa  (university_id => universities.id)
#
class Search < ApplicationRecord
  self.table_name = 'search'

  belongs_to :university
  belongs_to :language
  belongs_to :about_object, polymorphic: true
  belongs_to :about_localization, polymorphic: true
  belongs_to :website, optional: true
  belongs_to :extranet, optional: true

  scope :for_text, -> (term) { 
    where(
      "unaccent(text) ILIKE unaccent(:term)", 
      term: "%#{sanitize_sql_like(term)}%"
    )
  }
  scope :for_title, -> (term) { 
    where(
      "unaccent(title) ILIKE unaccent(:term)", 
      term: "%#{sanitize_sql_like(term)}%"
    )
  }
  scope :in, -> (language) {
    where(language: language)
  }
end
