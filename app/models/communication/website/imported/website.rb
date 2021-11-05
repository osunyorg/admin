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

  protected

  def wordpress
    @wordpress ||= Wordpress.new website.domain_url
  end

  def sync_authors
    wordpress.authors.each do |data|
      author = authors.where(university: university, identifier: data['id']).first_or_initialize
      author.data = data
      author.save
    end
  end

  def sync_categories
    wordpress.categories.each do |data|
      category = categories.where(university: university, identifier: data['id']).first_or_initialize
      category.data = data
      category.save
    end
    sync_tree(categories)
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
      Communication::Website::Page.skip_callback(:save, :after, :publish_to_github)
      wordpress.pages.each do |data|
        page = pages.where(university: university, identifier: data['id']).first_or_initialize
        page.data = data
        page.save
      end
      sync_tree(pages)
      # Batch update all changes (1 query only, good for github API limits)
      github = Github.with_site website
      if github.valid?
        website.pages.find_each do |page|
          github.add_to_batch path: page.github_path_generated,
                              previous_path: page.github_path,
                              data: page.to_jekyll
          page.active_storage_blobs.each do |blob|
            blob.analyze unless blob.analyzed?
            github.add_to_batch path: page.blob_github_path_generated(blob),
                                data: page.blob_to_jekyll(blob)
          end
        end
        github.commit_batch '[Page] Batch update from import'
      end
    ensure
      Communication::Website::Page.set_callback(:save, :after, :publish_to_github)
    end
  end

  def sync_posts
    begin
      Communication::Website::Post.skip_callback(:save, :after, :publish_to_github)
      github = Github.with_site website
      wordpress.posts.each do |data|
        post = posts.where(university: university, identifier: data['id']).first_or_initialize
        post.data = data
        post.save
        generated_post = post.post
        if github.valid?
          github.add_to_batch path: generated_post.github_path_generated,
                              previous_path: generated_post.github_path,
                              data: generated_post.to_jekyll
          generated_post.active_storage_blobs.each do |blob|
            blob.analyze unless blob.analyzed?
            github.add_to_batch path: generated_post.blob_github_path_generated(blob),
                                data: generated_post.blob_to_jekyll(blob)
          end
        end
      end
      github.commit_batch '[Post] Batch update from import' if github.valid?
    ensure
      Communication::Website::Post.set_callback(:save, :after, :publish_to_github)
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
end
