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

  def to_s
    "#{name}"
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

  def force_publish!
    publish_authors!
    publish_categories!
    publish_pages!
    publish_posts!
  end
  handle_asynchronously :force_publish!, queue: 'default'

  def publish_authors!
    publish_objects(Communication::Website::Author, authors)
  end

  def publish_categories!
    publish_objects(Communication::Website::Category, categories)
  end

  def publish_pages!
    publish_objects_with_blobs(Communication::Website::Page, pages)
  end

  def publish_posts!
    publish_objects_with_blobs(Communication::Website::Post, posts)
  end

  protected

  def publish_objects(model, objects)
    begin
      had_callback = model.__callbacks[:save].find { |c| c.matches?(:after, :publish_to_github) }
      model.skip_callback(:save, :after, :publish_to_github) if had_callback
      github = Github.with_site self
      return unless github.valid?
      objects.each do |object|
        github.add_to_batch path: object.github_path_generated,
                            previous_path: object.github_path,
                            data: object.to_jekyll
        yield(github, object) if block_given?
      end
      github.commit_batch "[#{model.name.demodulize}] Batch update from import"
    ensure
      model.set_callback(:save, :after, :publish_to_github) if had_callback
    end
  end

  def publish_objects_with_blobs(model, objects)
    publish_objects(model, objects) { |github, object|
      object.active_storage_blobs.each do |blob|
        blob.analyze unless blob.analyzed?
        github.add_to_batch path: object.blob_github_path_generated(blob),
                            data: object.blob_to_jekyll(blob)
      end
    }
  end
end
