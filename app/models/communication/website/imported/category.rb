# == Schema Information
#
# Table name: communication_website_imported_categories
#
#  id            :uuid             not null, primary key
#  data          :jsonb
#  description   :text
#  identifier    :string
#  name          :string
#  parent        :string
#  slug          :string
#  url           :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  category_id   :uuid             not null
#  university_id :uuid             not null
#  website_id    :uuid             not null
#
# Indexes
#
#  idx_communication_website_imported_cat_on_category    (category_id)
#  idx_communication_website_imported_cat_on_university  (university_id)
#  idx_communication_website_imported_cat_on_website     (website_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => communication_website_categories.id)
#  fk_rails_...  (university_id => universities.id)
#  fk_rails_...  (website_id => communication_website_imported_websites.id)
#
class Communication::Website::Imported::Category < ApplicationRecord

  belongs_to :university
  belongs_to :website,
             class_name: 'Communication::Website::Imported::Website'
  belongs_to :category,
             class_name: 'Communication::Website::Category',
             optional: true
  alias_attribute :generated_object, :category

  before_validation :sync

  default_scope { order(:name) }

  def data=(value)
    super value
    self.url = value['link']
    self.slug = value['slug']
    self.name = value['name']
    self.description = value['description']
    self.parent = value['parent']
  end

  def to_s
    "#{name}"
  end

  protected

  def sync
    if category.nil?
      self.category = Communication::Website::Category.new university: university,
                                                   website: website.website # Real website, not imported website
      self.category.name = "Untitled" # No title yet
      self.category.save
    end
    puts "Update category #{category.id}"
    sanitized_name = Wordpress.clean_string self.name.to_s
    category.name = sanitized_name unless sanitized_name.blank? # If there is no title, leave it with "Untitled"
    category.slug = slug
    category.description = Wordpress.clean_string description.to_s
    category.save
  end
end
