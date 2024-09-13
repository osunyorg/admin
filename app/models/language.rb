# == Schema Information
#
# Table name: languages
#
#  id                :uuid             not null, primary key
#  iso_code          :string
#  name              :string
#  summernote_locale :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class Language < ApplicationRecord
  AVAILABLE_IN_LIBRETRANSLATE = [
    "ar", "az", "bg", "bn", "ca", "cs", "da", "de", "el", "en", "eo", "es",
    "et", "fa", "fi", "fr", "ga", "he", "hi", "hu", "id", "it", "ja", "ko",
    "lt", "lv", "ms", "nb", "nl", "pl", "pt", "ro", "ru", "sk", "sl", "sq",
    "sr", "sv", "th", "tl", "tr", "uk", "ur", "vi", "zh", "zt"
  ].freeze

  include Sanitizable

  has_many :users
  has_and_belongs_to_many :universities
  has_and_belongs_to_many :communication_websites,
                          class_name: 'Communication::Website',
                          join_table: :communication_websites_languages,
                          association_foreign_key: :communication_website_id

  validates :iso_code, presence: true
  validates :iso_code, uniqueness: true

  scope :available_for_interface, -> { where(iso_code: I18n.available_locales) }
  scope :ordered, -> (language = nil) { order(name: :asc) }

  def supported_by_libretranslate?
    AVAILABLE_IN_LIBRETRANSLATE.include?(iso_code)
  end

  def to_s
    "#{name}"
  end

  def to_param
    iso_code
  end
end
