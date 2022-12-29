# == Schema Information
#
# Table name: university_people
#
#  id                 :uuid             not null, primary key
#  address            :string
#  biography          :text
#  birthdate          :date
#  city               :string
#  country            :string
#  description        :text
#  description_short  :text
#  email              :string
#  first_name         :string
#  gender             :integer
#  habilitation       :boolean          default(FALSE)
#  is_administration  :boolean
#  is_alumnus         :boolean          default(FALSE)
#  is_author          :boolean
#  is_researcher      :boolean
#  is_teacher         :boolean
#  last_name          :string
#  linkedin           :string
#  name               :string
#  phone_mobile       :string
#  phone_personal     :string
#  phone_professional :string
#  slug               :string
#  tenure             :boolean          default(FALSE)
#  twitter            :string
#  url                :string
#  zipcode            :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  university_id      :uuid             not null, indexed
#  user_id            :uuid             indexed
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
  include WithUniversity
  include WithGit
  include WithBlobs
  include WithEducation
  include WithExperiences
  include WithSlug
  include WithPicture
  include WithRoles
  include WithBlocks
  include WithPermalink

  LIST_OF_ROLES = [
    :administration,
    :teacher,
    :researcher,
    :alumnus,
    :author
  ].freeze

  enum gender: { male: 0, female: 1, non_binary: 2 }

  has_summernote :biography

  belongs_to :user, optional: true

  has_and_belongs_to_many :research_journal_papers,
                          class_name: 'Research::Journal::Paper',
                          join_table: :research_journal_papers_researchers,
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

  has_many                :author_websites,
                          -> { distinct },
                          through: :communication_website_posts,
                          source: :website

  has_many                :researcher_websites,
                          -> { distinct },
                          through: :research_journal_papers,
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

  before_validation :sanitize_email, :prepare_name

  scope :ordered,         -> { order(:last_name, :first_name) }
  scope :administration,  -> { where(is_administration: true) }
  scope :teachers,        -> { where(is_teacher: true) }
  scope :researchers,     -> { where(is_researcher: true) }
  scope :alumni,          -> { where(is_alumnus: true) }
  scope :for_role, -> (role) { where("is_#{role}": true) }
  scope :for_program, -> (program_id) {
    left_joins(:education_programs_as_administrator, :education_programs_as_teacher)
      .where(education_programs: { id: program_id })
      .or(
        left_joins(:education_programs_as_administrator, :education_programs_as_teacher)
          .where(education_programs_as_teachers_university_people: { id: program_id })
      )
      .select("university_people.*")
      .distinct
  }
  scope :for_search_term, -> (term) {
    where("
      unaccent(concat(university_people.first_name, ' ', university_people.last_name)) ILIKE unaccent(:term) OR
      unaccent(concat(university_people.last_name, ' ', university_people.first_name)) ILIKE unaccent(:term) OR
      unaccent(university_people.first_name) ILIKE unaccent(:term) OR
      unaccent(university_people.last_name) ILIKE unaccent(:term) OR
      unaccent(university_people.email) ILIKE unaccent(:term) OR
      unaccent(university_people.phone_mobile) ILIKE unaccent(:term) OR
      unaccent(university_people.phone_personal) ILIKE unaccent(:term) OR
      unaccent(university_people.phone_professional) ILIKE unaccent(:term) OR
      unaccent(university_people.biography) ILIKE unaccent(:term) OR
      unaccent(university_people.description) ILIKE unaccent(:term) OR
      unaccent(university_people.description_short) ILIKE unaccent(:term) OR
      unaccent(university_people.twitter) ILIKE unaccent(:term) OR
      unaccent(university_people.linkedin) ILIKE unaccent(:term) OR
      unaccent(university_people.address) ILIKE unaccent(:term) OR
      unaccent(university_people.zipcode) ILIKE unaccent(:term) OR
      unaccent(university_people.city) ILIKE unaccent(:term) OR
      unaccent(university_people.url) ILIKE unaccent(:term)
    ", term: "%#{sanitize_sql_like(term)}%")
  }

  def to_s
    "#{first_name} #{last_name}"
  end

  def to_s_alphabetical
    "#{last_name} #{first_name}"
  end

  def roles
    LIST_OF_ROLES.reject do |role|
      ! send "is_#{role}"
    end
  end

  def websites
    university.communication_websites
  end

  def git_path(website)
    "#{git_path_content_prefix(website)}persons/#{slug}.html" if for_website?(website)
  end

  def git_dependencies(website)
    dependencies = [self]
    dependencies += active_storage_blobs
    dependencies += git_block_dependencies
    dependencies += [administrator, author, researcher, teacher]
    dependencies += communication_website_posts.where(communication_website_id: website.id)
    dependencies += website.menus.to_a
    dependencies += dependencies_through_blocks(website)
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
    teacher.for_website?(website) ||
    in_block_dependencies?(website)
  end

  def full_street_address
    return nil if [address, zipcode, city].all?(&:blank?)
    [address, "#{zipcode} #{city} #{country}".strip].join(', ')
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

  def prepare_name
    self.name = to_s
  end
end
