# == Schema Information
#
# Table name: university_people
#
#  id                :uuid             not null, primary key
#  biography         :text
#  description       :text
#  email             :string
#  first_name        :string
#  habilitation      :boolean          default(FALSE)
#  is_administration :boolean
#  is_researcher     :boolean
#  is_teacher        :boolean
#  last_name         :string
#  phone             :string
#  slug              :string
#  tenure            :boolean          default(FALSE)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  university_id     :uuid             not null, indexed
#  user_id           :uuid             indexed
#
# Indexes
#
#  index_university_people_on_university_id  (university_id)
#  index_university_people_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_b47a769440  (user_id => users.id)
#  fk_rails_da35e70d61  (university_id => universities.id)
#
class University::Person < ApplicationRecord
  include Sanitizable
  include WithGit
  include WithBlobs
  include WithSlug
  include WithPicture
  include WithEducation

  has_summernote :biography

  belongs_to :university
  belongs_to :user, optional: true

  has_and_belongs_to_many :research_journal_articles,
                          class_name: 'Research::Journal::Article',
                          join_table: :research_journal_articles_researchers,
                          foreign_key: :researcher_id

  has_many                :communication_website_posts,
                          class_name: 'Communication::Website::Post',
                          foreign_key: :author_id,
                          dependent: :nullify

  has_many                :communication_website_imported_authors,
                          class_name: "Communication::Website::Imported::Author",
                          foreign_key: :author_id,
                          dependent: :destroy

  has_many                :involvements,
                          class_name: 'University::Person::Involvement',
                          dependent: :destroy

  has_many                :involvements_as_administrator,
                          -> { where(kind: 'administrator') },
                          class_name: 'University::Person::Involvement',
                          dependent: :destroy

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

  accepts_nested_attributes_for :involvements

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
    dependencies = website.menus
    if for_website?(website)
      dependencies << self
      dependencies.concat active_storage_blobs
    end
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

  def in_block_dependencies?(website)
    website.blocks.find_each do |block|
      return true if in? block.git_dependencies
    end
  end

  def for_website?(website)
    in_block_dependencies?(website) ||
    administrator.for_website?(website) ||
    author.for_website?(website) ||
    researcher.for_website?(website) ||
    teacher.for_website?(website)
  end

  protected

  def explicit_blob_ids
    [picture&.blob_id]
  end

  def inherited_blob_ids
    [best_picture&.blob_id]
  end

  def sanitize_email
    self.email = self.email.to_s.downcase.strip
  end
end
