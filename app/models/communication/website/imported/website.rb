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
  has_many   :authors,
             class_name: 'Communication::Website::Imported::Author',
             dependent: :destroy
  has_many   :categories,
             class_name: 'Communication::Website::Imported::Category',
             dependent: :destroy
  has_many   :media,
             class_name: 'Communication::Website::Imported::Medium',
             dependent: :destroy
  has_many   :pages,
             class_name: 'Communication::Website::Imported::Page',
             dependent: :destroy
  has_many   :posts,
             class_name: 'Communication::Website::Imported::Post',
             dependent: :destroy

  def run!
    sync_authors
    sync_categories
    sync_media
    sync_pages
    sync_posts
  end
  handle_asynchronously :run!, queue: 'default'

  def uploads_url
    @uploads_url ||= "#{website.url}/wp-content/uploads"
  end

  protected

  def wordpress
    @wordpress ||= Wordpress.new website.url
  end

  def sync_authors
    begin
      skip_publish_callback(Administration::Member)
      wordpress.authors.each do |data|
        author = authors.where(university: university, identifier: data['id']).first_or_initialize
        author.data = data
        author.save
      end
      # Batch update all changes (1 query only, good for github API limits)
      website.publish_members!
    ensure
      set_publish_callback(Administration::Member)
    end
  end

  def sync_categories
    begin
      skip_publish_callback(Communication::Website::Category)
      wordpress.categories.each do |data|
        category = categories.where(university: university, identifier: data['id']).first_or_initialize
        category.data = data
        category.save
      end
      sync_tree(categories)
      # Batch update all changes (1 query only, good for github API limits)
      website.publish_categories!
    ensure
      set_publish_callback(Communication::Website::Category)
    end
  end

  def sync_media
    wordpress.media.each do |data|
      medium = media.where(university: university, identifier: data['id']).first_or_initialize
      medium.data = data
      medium.save
    end
  end

  def sync_pages
    begin
      skip_publish_callback(Communication::Website::Page)
      wordpress.pages.each do |data|
        page = pages.where(university: university, identifier: data['id']).first_or_initialize
        page.data = data
        page.save
      end
      sync_tree(pages)
      # Batch update all changes (1 query only, good for github API limits)
      website.publish_pages!
    ensure
      set_publish_callback(Communication::Website::Page)
    end
  end

  def sync_posts
    begin
      skip_publish_callback(Communication::Website::Post)
      wordpress.posts.each do |data|
        post = posts.where(university: university, identifier: data['id']).first_or_initialize
        post.data = data
        post.save
      end
      # Batch update all changes (1 query only, good for github API limits)
      website.publish_posts!
    ensure
      set_publish_callback(Communication::Website::Post)
    end
  end

  def sync_tree(elements)
    # The order will treat parents before children
    elements.order(:url).find_each do |element|
      next if element.parent.blank?
      parent = elements.where(identifier: element.parent).first
      next if parent.nil?
      generated_element = element.generated_object
      generated_element.parent = parent.generated_object
      generated_element.save
    end
  end

  def skip_publish_callback(model)
    model.skip_callback(:commit, :after, :publish_github_files, on: [:create, :update])
  end


  def set_publish_callback(model)
    model.set_callback(:commit, :after, :publish_github_files, on: [:create, :update])
  end
end
