# == Schema Information
#
# Table name: communication_website_connections
#
#  id                   :uuid             not null, primary key
#  direct_source_type   :string           indexed => [direct_source_id]
#  indirect_object_type :string           not null, indexed => [indirect_object_id]
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  direct_source_id     :uuid             indexed => [direct_source_type]
#  indirect_object_id   :uuid             not null, indexed => [indirect_object_type]
#  university_id        :uuid             not null, indexed
#  website_id           :uuid             not null, indexed
#
# Indexes
#
#  index_communication_website_connections_on_object         (indirect_object_type,indirect_object_id)
#  index_communication_website_connections_on_source         (direct_source_type,direct_source_id)
#  index_communication_website_connections_on_university_id  (university_id)
#  index_communication_website_connections_on_website_id     (website_id)
#
# Foreign Keys
#
#  fk_rails_728034883b  (website_id => communication_websites.id)
#  fk_rails_bd1ac8383b  (university_id => universities.id)
#
class Communication::Website::Connection < ApplicationRecord
  belongs_to :university
  belongs_to :website, class_name: "Communication::Website"
  belongs_to :indirect_object, polymorphic: true
  belongs_to :direct_source, polymorphic: true

  scope :for_object, -> (object) { where(indirect_object: object) }
  scope :in_website, -> (website) { where(website: website) }
  scope :ordered, -> { order(updated_at: :desc) }

  def self.websites_for(object)
    for_object(object).distinct(:website).collect(&:website).uniq
  end

  def to_s
    "#{id.split('-').first}"
  end
end
