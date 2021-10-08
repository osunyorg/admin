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
  has_many :posts, foreign_key: :communication_website_id
  has_one :imported_website,
          class_name: 'Communication::Website::Imported::Website',
          dependent: :destroy

  def self.about_types
    [nil, Research::Journal.name]
  end

  def domain_url
    "https://#{ domain }"
  end

  def import!
    unless imported?
      self.imported_website = Communication::Website::Imported::Website.where(website: self, university: university)
                                                                        .first_or_create

    end
    imported_website.run!
    imported_website
  end

  def imported?
    !imported_website.nil?
  end

  def to_s
    "#{name}"
  end
end
