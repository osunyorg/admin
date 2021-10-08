# == Schema Information
#
# Table name: communication_website_imported_websites
#
#  id            :uuid             not null, primary key
#  status        :integer          default(0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  university_id :uuid             not null
#  website_id    :uuid             not null
#
# Indexes
#
#  index_communication_website_imported_websites_on_university_id  (university_id)
#  index_communication_website_imported_websites_on_website_id     (website_id)
#
# Foreign Keys
#
#  fk_rails_...  (university_id => universities.id)
#  fk_rails_...  (website_id => communication_websites.id)
#
class Communication::Website::Imported::Website < ApplicationRecord
  belongs_to :university
  belongs_to :website, class_name: 'Communication::Website'
  has_many :pages, class_name: 'Communication::Website::Imported::Page'

  def run!
    load("#{website.domain_url}/wp-json/wp/v2/pages").each do |hash|
      url = hash['link']
      path = URI(url).path
      title = hash['title']['rendered']
      content = hash['content']['rendered']
      page = pages.where(university: university, path: path).first_or_create
      page.title = title
      page.content = content
      page.save
    end
  end

  protected

  def load(url)
    uri = URI(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    # IUT Bordeaux Montaigne pb with certificate
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    JSON.parse(response.body)
  end
end
