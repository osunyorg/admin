# == Schema Information
#
# Table name: communication_website_imported_media
#
#  id                :uuid             not null, primary key
#  data              :jsonb
#  file_url          :text
#  identifier        :string
#  remote_created_at :datetime
#  remote_updated_at :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  university_id     :uuid             not null
#  website_id        :uuid             not null
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

  has_one_attached :file

  after_commit :download_file_from_file_url, on: [:create, :update], if: :saved_change_to_file_url

  def data=(value)
    super value
    escaped_source_url = Addressable::URI.parse(value['source_url']).display_uri.to_s
    self.file_url = escaped_source_url
    self.filename = File.basename(URI(escaped_source_url).path)
    self.remote_created_at = DateTime.parse(value['date_gmt'])
    self.remote_updated_at = DateTime.parse(value['modified_gmt'])
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
    tempfile = Tempfile.open("Osuny-ImportedMedium-#{SecureRandom.hex}", Dir.tmpdir)
    begin
      tempfile.binmode
      tempfile.write(response.body)
      tempfile.flush
      tempfile.rewind
      file.attach(io: tempfile, filename: filename, content_type: data['mime_type'])
    ensure
      tempfile.close!
    end
  end
  handle_asynchronously :download_file_from_file_url, queue: 'default'
end
