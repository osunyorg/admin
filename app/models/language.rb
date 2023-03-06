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
  include Sanitizable

  has_many :users
  has_and_belongs_to_many :communication_websites,
                          class_name: 'Communication::Website',
                          join_table: 'communication_websites_languages',
                          association_foreign_key: 'communication_website_id'

  validates_presence_of :iso_code
  validates_uniqueness_of :iso_code

  scope :ordered, -> { order(name: :asc) }

  def to_s
    "#{name}"
  end
end
