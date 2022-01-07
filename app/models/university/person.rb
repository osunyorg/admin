# == Schema Information
#
# Table name: university_people
#
#  id                :uuid             not null, primary key
#  email             :string
#  first_name        :string
#  is_administrative :boolean
#  is_author         :boolean
#  is_researcher     :boolean
#  is_teacher        :boolean
#  last_name         :string
#  phone             :string
#  slug              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  university_id     :uuid             not null
#  user_id           :uuid
#
# Indexes
#
#  index_university_people_on_university_id  (university_id)
#  index_university_people_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (university_id => universities.id)
#  fk_rails_...  (user_id => users.id)
#
class University::Person < ApplicationRecord
  include WithGit
  include WithSlug

  has_rich_text :biography

  belongs_to :university
  belongs_to :user, optional: true

  has_and_belongs_to_many :research_journal_articles,
                          class_name: 'Research::Journal::Article',
                          join_table: :research_journal_articles_researchers,
                          foreign_key: :researcher_id

  has_many                :education_program_teachers,
                          class_name: 'Education::Program::Teacher',
                          foreign_key: :person_id,
                          dependent: :destroy

  has_many                :education_programs,
                          through: :education_program_teachers,
                          source: :program

  has_many                :communication_website_posts,
                          class_name: 'Communication::Website::Post',
                          foreign_key: :author_id,
                          dependent: :nullify

  has_many                :author_websites,
                          -> { distinct },
                          through: :communication_website_posts,
                          source: :website

  has_many                :researcher_websites,
                          -> { distinct },
                          through: :research_journal_articles,
                          source: :websites

  has_many                :teacher_websites,
                          -> { distinct },
                          through: :education_programs,
                          source: :websites

  validates_presence_of   :first_name, :last_name
  validates_uniqueness_of :email,
                          scope: :university_id,
                          allow_blank: true,
                          if: :will_save_change_to_email?
  validates_format_of     :email,
                          with: Devise::email_regexp,
                          allow_blank: true,
                          if: :will_save_change_to_email?

  before_validation :sanitize_email

  scope :ordered,         -> { order(:last_name, :first_name) }
  scope :administratives, -> { where(is_administrative: true) }
  scope :authors,         -> { where(is_author: true) }
  scope :teachers,        -> { where(is_teacher: true) }
  scope :researchers,     -> { where(is_researcher: true) }

  def to_s
    "#{first_name} #{last_name}"
  end

  def websites
    Communication::Website.where(id: [
      author_website_ids,
      researcher_website_ids,
      teacher_website_ids
    ].flatten.uniq)
  end

  def identifiers(website: nil)
    website_id = website&.id
    list = []
    # TODO :administrator
    [:author, :researcher, :teacher].each do |role|
      list << role if send("#{role.to_s}_websites").pluck(:id).include?(website_id)
    end
    list << :static unless list.empty?
    list
  end

  def git_path_static
    "content/persons/#{slug}.html"
  end

  def git_path_author
    "content/authors/#{slug}/_index.html"
  end

  def git_path_researcher
    "content/researchers/#{slug}/_index.html"
  end

  def git_path_teacher
    "content/teachers/#{slug}/_index.html"
  end

  def git_path_administrator
    "content/administrators/#{slug}/_index.html"
  end

  def git_dependencies_static
    []
  end

  def git_dependencies_author
    []
  end

  def git_dependencies_researcher
    []
  end

  def git_dependencies_teacher
    []
  end

  def git_dependencies_administrator
    []
  end

  protected

  def sanitize_email
    self.email = self.email.downcase.strip
  end
end
