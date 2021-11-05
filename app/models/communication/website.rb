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
  has_many :pages,
           foreign_key: :communication_website_id,
           dependent: :destroy
  has_many :posts,
           foreign_key: :communication_website_id,
           dependent: :destroy
  has_many :categories,
           class_name: 'Communication::Website::Category',
           foreign_key: :communication_website_id,
           dependent: :destroy
  has_many :authors,
           class_name: 'Communication::Website::Author',
           foreign_key: :communication_website_id,
           dependent: :destroy
  has_many :menus,
           class_name: 'Communication::Website::Menu',
           foreign_key: :communication_website_id,
           dependent: :destroy
  has_one :imported_website,
          class_name: 'Communication::Website::Imported::Website',
          dependent: :destroy

  def self.about_types
    [nil, Education::School.name, Research::Journal.name]
  end

  def domain_url
    "https://#{domain}"
  end

  def uploads_url
    "#{domain_url}/wp-content/uploads"
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

  def list_of_pages
    all_pages = []
    pages.where.not(id: id).root.ordered.each do |page|
      all_pages.concat(page.self_and_children(0))
    end
    all_pages
  end

  def to_s
    "#{name}"
  end
end
