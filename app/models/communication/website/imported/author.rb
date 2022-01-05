# == Schema Information
#
# Table name: communication_website_imported_authors
#
#  id            :uuid             not null, primary key
#  data          :jsonb
#  description   :text
#  identifier    :string
#  name          :string
#  slug          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  author_id     :uuid
#  university_id :uuid             not null
#  website_id    :uuid             not null
#
# Indexes
#
#  idx_communication_website_imported_auth_on_author      (author_id)
#  idx_communication_website_imported_auth_on_university  (university_id)
#  idx_communication_website_imported_auth_on_website     (website_id)
#
# Foreign Keys
#
#  fk_rails_...  (author_id => university_people.id)
#  fk_rails_...  (university_id => universities.id)
#  fk_rails_...  (website_id => communication_website_imported_websites.id)
#
class Communication::Website::Imported::Author < ApplicationRecord

  belongs_to :university
  belongs_to :website,
             class_name: 'Communication::Website::Imported::Website'
  belongs_to :author,
             class_name: 'University::Person',
             optional: true

  before_validation :sync

  default_scope { order(:name) }

  def data=(value)
    super value
    self.slug = value['slug']
    self.name = value['name']
    self.description = value['description']
  end

  def to_s
    "#{name}"
  end

  protected

  def sync
    if author.nil?
      self.author = University::Person.new university: university
      self.author.last_name = "Doe" # No title yet
      self.author.first_name = "John" # No title yet
      self.is_author = true
      self.author.save
    end
    puts "Update author #{author.id}"
    sanitized_name = Wordpress.clean_string(self.name.to_s).split(' ')
    sanitized_biography = Wordpress.clean_string description.to_s
    unless sanitized_name.blank?
      author.first_name = sanitized_name.first
      author.last_name = sanitized_name[1..10].join(' ')
    end
    author.slug = slug
    author.biography = sanitized_biography unless sanitized_biography.blank?
    author.save
  end
end
