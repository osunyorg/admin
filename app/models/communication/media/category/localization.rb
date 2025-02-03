# == Schema Information
#
# Table name: communication_media_category_localizations
#
#  id                    :uuid             not null, primary key
#  featured_image_alt    :text
#  featured_image_credit :text
#  meta_description      :text
#  name                  :string
#  slug                  :string
#  summary               :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  about_id              :uuid             indexed
#  language_id           :uuid             indexed
#  university_id         :uuid             indexed
#
# Indexes
#
#  idx_on_language_id_b744f004d4                                 (language_id)
#  idx_on_university_id_0e75cba3b7                               (university_id)
#  index_communication_media_category_localizations_on_about_id  (about_id)
#
# Foreign Keys
#
#  fk_rails_d356e586b9  (about_id => communication_media_categories.id)
#  fk_rails_d37936c983  (university_id => universities.id)
#  fk_rails_ff7bdfc3a7  (language_id => languages.id)
#
class Communication::Media::Category::Localization < ApplicationRecord
  include AsCategoryLocalization
end
