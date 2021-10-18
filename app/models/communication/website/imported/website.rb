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
  belongs_to :website,
             class_name: 'Communication::Website'
  has_many   :pages,
             class_name: 'Communication::Website::Imported::Page'
  has_many   :posts,
             class_name: 'Communication::Website::Imported::Post'

  def run!
    sync_posts
    sync_pages
  end

  protected

  def wordpress
    @wordpress ||= Wordpress.new website.domain_url
  end

  def sync_pages
    wordpress.pages.find_each do |hash|
      page = pages.where(university: university, identifier: hash['id']).first_or_create
      page.url = hash['link']
      page.title = hash['title']['rendered']
      page.excerpt = hash['excerpt']['rendered']
      page.content = hash['content']['rendered']
      page.parent = hash['parent']
      page.save
    end
  end

  def sync_posts
    wordpress.posts.each do |hash|
      identifier = hash['id']
      post = posts.where(university: university, identifier: identifier).first_or_create
      post.url = hash['link']
      post.path = URI(post.url).path
      post.title = hash['title']['rendered']
      post.excerpt = hash['excerpt']['rendered']
      post.content = hash['content']['rendered']
      post.published_at = hash['date']
      post.save
    end
  end
end
