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
#  university_id :uuid             not null
#  website_id    :uuid             not null
#
# Indexes
#
#  index_communication_website_imported_media_on_university_id  (university_id)
#  index_communication_website_imported_media_on_website_id     (website_id)
#
# Foreign Keys
#
#  fk_rails_...  (university_id => universities.id)
#  fk_rails_...  (website_id => communication_website_imported_websites.id)
#
class Communication::Website::Imported::Medium < ApplicationRecord
  belongs_to :university
  belongs_to :website,
             class_name: 'Communication::Website::Imported::Website'
  has_many   :pages,
             class_name: 'Communication::Website::Imported::Page',
             foreign_key: :featured_medium_id
  has_many   :posts,
             class_name: 'Communication::Website::Imported::Post',
             foreign_key: :featured_medium_id

  has_one_attached_deletable :file

  after_commit :download_file_from_file_url, on: [:create, :update], if: :saved_change_to_file_url

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

  def download_file_from_file_url
    uri = URI(file_url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    # IUT Bordeaux Montaigne pb with certificate
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    file.attach(io: StringIO.new(response.body), filename: filename, content_type: mime_type)
  end
  handle_asynchronously :download_file_from_file_url, queue: 'default'
end
