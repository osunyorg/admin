# == Schema Information
#
# Table name: communication_website_connections
#
#  id            :uuid             not null, primary key
#  object_type   :string           not null, indexed => [object_id]
#  source_type   :string           indexed => [source_id]
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  object_id     :uuid             not null, indexed => [object_type]
#  source_id     :uuid             indexed => [source_type]
#  university_id :uuid             not null, indexed
#  website_id    :uuid             not null, indexed
#
# Indexes
#
#  index_communication_website_connections_on_object         (object_type,object_id)
#  index_communication_website_connections_on_source         (source_type,source_id)
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
  belongs_to :website
  belongs_to :object, polymorphic: true
  belongs_to :source, polymorphic: true

  scope :for_object, -> (object) { where(object: object) }
  scope :in_website, -> (website) { where(website: website) }
  scope :ordered, -> { order(updated_at: :desc, )}

  def self.websites_for(object)
    for_object(object).distinct(:website).collect(&:website).uniq
  end

  def for_same_object
    self.class.where( university: university, 
                      website: website,
                      object: object)
              .where.not(id: id)
  end

  def to_s
    "#{id.split('-').first}"
  end
end
