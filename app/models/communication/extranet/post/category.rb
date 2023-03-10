# == Schema Information
#
# Table name: communication_extranet_post_categories
#
#  id            :uuid             not null, primary key
#  name          :string
#  slug          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  extranet_id   :uuid             not null, indexed
#  university_id :uuid             not null, indexed
#
# Indexes
#
#  index_communication_extranet_post_categories_on_extranet_id    (extranet_id)
#  index_communication_extranet_post_categories_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_aad7b8db63  (university_id => universities.id)
#  fk_rails_e53c2a25fc  (extranet_id => communication_extranets.id)
#
class Communication::Extranet::Post::Category < ApplicationRecord
  include WithSlug
  include WithUniversity

  belongs_to :extranet, class_name: 'Communication::Extranet'
  has_many :posts

  validates :name, presence: true

  scope :ordered, -> { order(:name) }

  def to_s
    "#{name}"
  end

  protected

  def slug_unavailable?(slug)
    self.class.unscoped
              .where(extranet_id: self.extranet_id, slug: slug)
              .where.not(id: self.id)
              .exists?
  end
end
