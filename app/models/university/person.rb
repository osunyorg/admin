# == Schema Information
#
# Table name: university_people
#
#  id                :uuid             not null, primary key
#  email             :string
#  first_name        :string
#  is_administration :boolean
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
                          dependent: :destroy

  has_many                :education_program_role_people,
                          class_name: 'Education::Program::Role::Person',
                          dependent: :destroy

  has_many                :education_programs,
                          through: :education_program_teachers,
                          source: :program

  has_many                :education_school_administrators,
                          class_name: 'Education::School::Administrator',
                          dependent: :destroy

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
  scope :administration, -> { where(is_administration: true) }
  scope :teachers,        -> { where(is_teacher: true) }
  scope :researchers,     -> { where(is_researcher: true) }

  def to_s
    "#{first_name} #{last_name}"
  end

  def websites
    university.communication_websites
  end

  def git_path(website)
    "content/persons/#{slug}.html" if for_website?(website)
  end

  def git_dependencies(website)
    dependencies = []
    dependencies << self if for_website?(website)
    dependencies << administrator if administrator.for_website?(website)
    dependencies << author if author.for_website?(website)
    dependencies << researcher if researcher.for_website?(website)
    dependencies << teacher if teacher.for_website?(website)
    dependencies
  end

  def administrator
    @administrator ||= University::Person::Administrator.find(id)
  end

  def author
    @author ||= University::Person::Author.find(id)
  end

  def researcher
    @researcher ||= University::Person::Researcher.find(id)
  end

  def teacher
    @teacher ||= University::Person::Teacher.find(id)
  end

  def for_website?(website)
    administrator.for_website?(website) ||
    author.for_website?(website) ||
    researcher.for_website?(website) ||
    teacher.for_website?(website)
  end

  protected

  def sanitize_email
    self.email = self.email.downcase.strip
  end
end
