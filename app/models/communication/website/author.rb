# == Schema Information
#
# Table name: communication_website_authors
#
#  id                       :uuid             not null, primary key
#  first_name               :string
#  last_name                :string
#  slug                     :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  communication_website_id :uuid             not null
#  university_id            :uuid             not null
#  user_id                  :uuid
#
# Indexes
#
#  idx_comm_website_authors_on_communication_website_id  (communication_website_id)
#  index_communication_website_authors_on_university_id  (university_id)
#  index_communication_website_authors_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (communication_website_id => communication_websites.id)
#  fk_rails_...  (university_id => universities.id)
#  fk_rails_...  (user_id => users.id)
#
class Communication::Website::Author < ApplicationRecord
  include WithSlug

  has_rich_text :biography

  belongs_to :university
  belongs_to :user, optional: true
  belongs_to :website,
             foreign_key: :communication_website_id

  scope :ordered, -> { order(:last_name, :first_name) }

  def to_s
    "#{last_name} #{first_name}"
  end

end
