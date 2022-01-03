# == Schema Information
#
# Table name: communication_website_categories
#
#  id                       :uuid             not null, primary key
#  description              :text
#  github_path              :text
#  is_programs_root         :boolean          default(FALSE)
#  name                     :string
#  path                     :string
#  position                 :integer
#  slug                     :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  communication_website_id :uuid             not null
#  parent_id                :uuid
#  program_id               :uuid
#  university_id            :uuid             not null
#
# Indexes
#
#  idx_communication_website_post_cats_on_communication_website_id  (communication_website_id)
#  index_communication_website_categories_on_parent_id              (parent_id)
#  index_communication_website_categories_on_program_id             (program_id)
#  index_communication_website_categories_on_university_id          (university_id)
#
# Foreign Keys
#
#  fk_rails_...  (communication_website_id => communication_websites.id)
#  fk_rails_...  (parent_id => communication_website_categories.id)
#  fk_rails_...  (program_id => education_programs.id)
#  fk_rails_...  (university_id => universities.id)
#
class Communication::Website::Category < ApplicationRecord
  include WithGit
  include WithMenuItemTarget
  include WithSlug # We override slug_unavailable? method
  include WithTree

  has_one :imported_category,
          class_name: 'Communication::Website::Imported::Category',
          dependent: :destroy
  belongs_to :university
  belongs_to :website,
             foreign_key: :communication_website_id
  belongs_to :parent,
            class_name: 'Communication::Website::Category',
            optional: true
  belongs_to :program,
            class_name: 'Education::Program',
            optional: true
  has_one :imported_category,
          class_name: 'Communication::Website::Imported::Category',
          dependent: :destroy
  has_many :children,
           class_name: 'Communication::Website::Category',
           foreign_key: :parent_id,
           dependent: :destroy
  has_and_belongs_to_many :posts,
                          class_name: 'Communication::Website::Post',
                          join_table: 'communication_website_categories_posts',
                          foreign_key: 'communication_website_category_id',
                          association_foreign_key: 'communication_website_post_id'

  validates :name, presence: true

  after_save :update_children_paths, if: :saved_change_to_path?

  scope :ordered, -> { order(:position) }

  before_create :set_position

  def list_of_other_categories
    new_record? ? website.list_of_categories
                : website.list_of_categories.reject! { |p| p[:id] == id }
  end

  def to_s
    "#{name}"
  end

  def git_path_static
    "content/categories/#{path}/_index.html".gsub(/\/+/, '/')
  end

  def update_children_paths
    children.each do |child|
      child.update_column :path, child.generated_path
      child.update_children_paths
    end
  end

  protected

  def set_position
    last_element = website.categories.where(parent_id: parent_id).ordered.last

    unless last_element.nil?
      self.position = last_element.position + 1
    else
      self.position = 1
    end
  end

  def slug_unavailable?(slug)
    self.class.unscoped.where(communication_website_id: self.communication_website_id, slug: slug).where.not(id: self.id).exists?
  end
end
