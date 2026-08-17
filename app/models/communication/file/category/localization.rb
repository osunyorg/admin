# == Schema Information
#
# Table name: communication_file_category_localizations
#
#  id                    :uuid             not null, primary key
#  featured_image_credit :text
#  featured_media_alt    :text
#  meta_description      :text
#  name                  :string
#  slug                  :string
#  summary               :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  about_id              :uuid             uniquely indexed => [language_id], indexed
#  featured_media_id     :uuid             indexed
#  language_id           :uuid             uniquely indexed => [about_id], indexed
#  university_id         :uuid             indexed
#
# Indexes
#
#  idx_on_about_id_language_id_f3d63b2051                          (about_id,language_id) UNIQUE
#  idx_on_featured_media_id_f22926f084                             (featured_media_id)
#  idx_on_university_id_7bebff08b4                                 (university_id)
#  index_communication_file_category_localizations_on_about_id     (about_id)
#  index_communication_file_category_localizations_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_085826a452  (university_id => universities.id)
#  fk_rails_2c79b1360f  (featured_media_id => communication_medias.id) ON DELETE => nullify
#  fk_rails_cbf5631003  (language_id => languages.id)
#  fk_rails_dbc01ccb51  (about_id => communication_file_categories.id)
#
class Communication::File::Category::Localization < ApplicationRecord
  include AsCategoryLocalization
end
