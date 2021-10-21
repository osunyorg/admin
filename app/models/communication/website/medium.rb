# == Schema Information
#
# Table name: communication_website_media
#
#  id            :uuid             not null, primary key
#  file_url      :text
#  filename      :string
#  identifier    :string
#  mime_type     :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  university_id :uuid             not null
#  website_id    :uuid             not null
#
# Indexes
#
#  index_communication_website_media_on_university_id  (university_id)
#  index_communication_website_media_on_website_id     (website_id)
#
# Foreign Keys
#
#  fk_rails_...  (university_id => universities.id)
#  fk_rails_...  (website_id => communication_websites.id)
#
class Communication::Website::Medium < ApplicationRecord
  belongs_to :university
  belongs_to :website
  has_one    :imported_medium,
             class_name: 'Communication::Website::Imported::Medium',
             foreign_key: :medium_id,
             dependent: :destroy

  has_one_attached_deletable :file

  after_commit :download_file_from_file_url, on: [:create, :update], if: :saved_change_to_file_url

  protected

  def download_file_from_file_url
    uri = URI(file_url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    # IUT Bordeaux Montaigne pb with certificate
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    tempfile = Tempfile.open("Osuny-CommunicationWebsiteMedium-#{SecureRandom.hex}", Dir.tmpdir)
    begin
      tempfile.binmode
      tempfile.write(response.body)
      tempfile.flush
      tempfile.rewind
      file.attach(io: tempfile, filename: filename, content_type: mime_type)
      set_featured_images
    ensure
      tempfile.close!
    end
  end
  handle_asynchronously :download_file_from_file_url, queue: 'default'

  def set_featured_images
    posts = Communication::Website::Post.joins(:imported_post)
                                        .where(communication_website_imported_posts: { featured_medium_id: imported_medium.id })
    posts.each do |post|
      post.featured_image.attach(io: URI.open(file.url), filename: filename, content_type: mime_type)
    end
  end
end
