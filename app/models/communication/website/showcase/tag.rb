# == Schema Information
#
# Table name: communication_website_showcase_tags
#
#  id         :uuid             not null, primary key
#  name       :string
#  slug       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Communication::Website::Showcase::Tag < ApplicationRecord
  include Sluggable

  has_and_belongs_to_many :websites,
                          class_name: 'Communication::Website',
                          join_table: :communication_website_showcase_tags_websites,
                          foreign_key: :communication_website_showcase_tag_id,
                          association_foreign_key: :communication_website_id

  scope :ordered, -> (language = nil) { order(:name) }

  def to_s
    "#{name}"
  end
end
