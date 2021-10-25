# == Schema Information
#
# Table name: communication_website_imported_media
#
#  id            :uuid             not null, primary key
#  data          :jsonb
#  file_url      :text
#  filename      :string
#  identifier    :string
#  mime_type     :string
#  created_at    :datetime
#  updated_at    :datetime
#  medium_id     :uuid
#  university_id :uuid             not null
#  website_id    :uuid             not null
#
# Indexes
#
#  index_communication_website_imported_media_on_medium_id      (medium_id)
#  index_communication_website_imported_media_on_university_id  (university_id)
#  index_communication_website_imported_media_on_website_id     (website_id)
#
# Foreign Keys
#
#  fk_rails_...  (medium_id => communication_website_media.id)
#  fk_rails_...  (university_id => universities.id)
#  fk_rails_...  (website_id => communication_website_imported_websites.id)
#
class Communication::Website::Imported::Medium < ApplicationRecord
  belongs_to :university
  belongs_to :website,
             class_name: 'Communication::Website::Imported::Website'
  belongs_to :medium,
             class_name: 'Communication::Website::Medium',
             optional: true
  has_many   :pages,
             class_name: 'Communication::Website::Imported::Page',
             foreign_key: :featured_medium_id
  has_many   :posts,
             class_name: 'Communication::Website::Imported::Post',
             foreign_key: :featured_medium_id

  before_validation :sync

  def data=(value)
    super value
    sanitized_file_url = Addressable::URI.parse(value['source_url']).display_uri.to_s # ASCII-only for URI
    self.file_url = sanitized_file_url
    self.filename = File.basename(URI(file_url).path)
    self.mime_type = value['mime_type']
    self.created_at = value['date_gmt']
    self.updated_at = value['modified_gmt']
  end

  protected

  def sync
    if medium.nil?
      self.medium = Communication::Website::Medium.new  university: university,
                                                        website: website.website # Real website, not imported website
      self.medium.save
    else
      # Continue only if there are remote changes
      # Don't touch if there are local changes (page.updated_at > updated_at)
      # Don't touch if there are no remote changes (page.updated_at == updated_at)
      return unless updated_at > medium.updated_at
    end
    puts "Update medium #{medium.id}"
    medium.file_url = Addressable::URI.parse(file_url).display_uri.to_s # ASCII-only for ActiveStorage
    medium.filename = File.basename(URI(medium.file_url).path)
    medium.mime_type = mime_type
    medium.created_at = created_at
    medium.updated_at = updated_at
    medium.save
  end
end
