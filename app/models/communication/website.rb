# == Schema Information
#
# Table name: communication_websites
#
#  id            :uuid             not null, primary key
#  about_type    :string
#  access_token  :string
#  domain        :string
#  name          :string
#  repository    :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  about_id      :uuid
#  university_id :uuid             not null
#
# Indexes
#
#  index_communication_websites_on_about          (about_type,about_id)
#  index_communication_websites_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_...  (university_id => universities.id)
#
class Communication::Website < ApplicationRecord
  belongs_to :university
  belongs_to :about, polymorphic: true, optional: true
  has_many :pages, foreign_key: :communication_website_id

  def self.about_types
    [nil, :research_journal, :school]
  end

  def domain_url
    "https://#{ domain }"
  end

  def to_s
    "#{name}"
  end
end
