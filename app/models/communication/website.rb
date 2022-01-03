# == Schema Information
#
# Table name: communication_websites
#
#  id                        :uuid             not null, primary key
#  about_type                :string
#  access_token              :string
#  authors_github_directory  :string           default("authors")
#  name                      :string
#  posts_github_directory    :string           default("posts")
#  programs_github_directory :string           default("programs")
#  repository                :string
#  staff_github_directory    :string           default("staff")
#  url                       :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  about_id                  :uuid
#  university_id             :uuid             not null
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
  include WithGitRepository
  include WithCategories

  belongs_to  :university
  belongs_to  :about,
              polymorphic: true,
              optional: true
  has_one     :home,
              class_name: 'Communication::Website::Home',
              foreign_key: :communication_website_id,
              dependent: :destroy
  has_many    :pages,
              foreign_key: :communication_website_id,
              dependent: :destroy
  has_many    :posts,
              foreign_key: :communication_website_id,
              dependent: :destroy
  has_many    :categories,
              class_name: 'Communication::Website::Category',
              foreign_key: :communication_website_id,
              dependent: :destroy
  has_many    :menus,
              class_name: 'Communication::Website::Menu',
              foreign_key: :communication_website_id,
              dependent: :destroy
  has_one     :imported_website,
              class_name: 'Communication::Website::Imported::Website',
              dependent: :destroy
  has_many    :git_files,
              class_name: 'Communication::Website::GitFile',
              dependent: :destroy

  after_create :create_home
  after_save :publish_about_object, if: :saved_change_to_about_id?
  after_save_commit :set_programs_categories!, if: -> (website) { website.about_school? }

  scope :ordered, -> { order(:name) }

  def self.about_types
    [nil, Education::School.name, Research::Journal.name]
  end

  def to_s
    "#{name}"
  end

  def programs
    about_school? ? about.programs : Education::Program.none
  end

  def import!
    imported_website = Communication::Website::Imported::Website.where(
      website: self, university: university
    ).first_or_create unless imported?

    imported_website.run!
    imported_website
  end

  def imported?
    !imported_website.nil?
  end

  def list_of_pages
    all_pages = []
    pages.root.ordered.each do |page|
      all_pages.concat(page.self_and_children(0))
    end
    all_pages
  end

  def list_of_categories
    all_categories = []
    categories.root.ordered.each do |category|
      all_categories.concat(category.self_and_children(0))
    end
    all_categories
  end

  def list_of_programs
    all_programs = []
    programs.root.ordered.each do |program|
      all_programs.concat(program.self_and_children(0))
    end
    all_programs
  end

  protected

  def create_home
    build_home(university_id: university_id).save
  end

  def about_school?
    about_type == 'Education::School'
  end
end
