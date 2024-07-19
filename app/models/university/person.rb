# == Schema Information
#
# Table name: university_people
#
#  id                            :uuid             not null, primary key
#  address                       :string
#  address_visibility            :integer          default("private")
#  biography                     :text
#  birthdate                     :date
#  city                          :string
#  country                       :string
#  email                         :string
#  email_visibility              :integer          default("private")
#  first_name                    :string
#  gender                        :integer
#  habilitation                  :boolean          default(FALSE)
#  is_administration             :boolean
#  is_alumnus                    :boolean          default(FALSE)
#  is_author                     :boolean
#  is_researcher                 :boolean
#  is_teacher                    :boolean
#  last_name                     :string
#  linkedin                      :string
#  linkedin_visibility           :integer          default("private")
#  mastodon                      :string
#  mastodon_visibility           :integer          default("private")
#  meta_description              :text
#  name                          :string
#  phone_mobile                  :string
#  phone_mobile_visibility       :integer          default("private")
#  phone_personal                :string
#  phone_personal_visibility     :integer          default("private")
#  phone_professional            :string
#  phone_professional_visibility :integer          default("private")
#  picture_credit                :text
#  slug                          :string           indexed
#  summary                       :text
#  tenure                        :boolean          default(FALSE)
#  twitter                       :string
#  twitter_visibility            :integer          default("private")
#  url                           :string
#  zipcode                       :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  language_id                   :uuid             indexed
#  original_id                   :uuid             indexed
#  university_id                 :uuid             not null, indexed
#  user_id                       :uuid             indexed
#
# Indexes
#
#  index_university_people_on_language_id    (language_id)
#  index_university_people_on_original_id    (original_id)
#  index_university_people_on_slug           (slug)
#  index_university_people_on_university_id  (university_id)
#  index_university_people_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_08f468090d  (original_id => university_people.id)
#  fk_rails_49a0628c42  (language_id => languages.id)
#  fk_rails_b47a769440  (user_id => users.id)
#  fk_rails_da35e70d61  (university_id => universities.id)
#
class University::Person < ApplicationRecord
  include AsIndirectObject
  include Contentful # TODO L10N : To remove
  include Permalinkable # TODO L10N : To remove
  include Sanitizable
  include Localizable
  include WithBlobs
  include WithCountry
  # WithRoles included before WithEducation because needed for the latter
  include WithRoles
  include WithEducation
  include WithExperiences
  # include WithGitFiles # TODO L10N : To remove
  include WithPersonalData
  include WithPicture
  include WithResearch
  include WithUniversity

  LIST_OF_ROLES = [
    :administration,
    :teacher,
    :researcher,
    :alumnus,
    :author
  ].freeze

  enum gender: { male: 0, female: 1, non_binary: 2 }

  belongs_to :user, optional: true

  has_and_belongs_to_many :categories,
                          class_name: 'University::Person::Category',
                          join_table: :university_people_categories

  has_and_belongs_to_many :research_journal_papers,
                          class_name: 'Research::Journal::Paper',
                          join_table: :research_journal_papers_researchers,
                          foreign_key: :researcher_id

  has_many                :communication_website_posts,
                          class_name: 'Communication::Website::Post',
                          foreign_key: :author_id,
                          dependent: :nullify

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

  validates_uniqueness_of :email,
                          scope: [:university_id, :language_id],
                          allow_blank: true,
                          if: :will_save_change_to_email?
  validates_format_of     :email,
                          with: Devise::email_regexp,
                          allow_blank: true,
                          if: :will_save_change_to_email?

  before_validation :sanitize_email

   # TODO L10N : To adjust
  scope :ordered, -> (language) {
    # Define a raw SQL snippet for the conditional aggregation
    # This selects the name of the localization in the specified language,
    # or falls back to the first localization name if the specified language is not present.
    localization_first_name_select = <<-SQL
      COALESCE(
        MAX(CASE WHEN localizations.language_id = '#{language.id}' THEN localizations.first_name END),
        MAX(localizations.first_name) FILTER (WHERE localizations.rank = 1)
      ) AS localization_first_name
    SQL
    localization_last_name_select = <<-SQL
      COALESCE(
        MAX(CASE WHEN localizations.language_id = '#{language.id}' THEN localizations.last_name END),
        MAX(localizations.last_name) FILTER (WHERE localizations.rank = 1)
      ) AS localization_last_name
    SQL

    # Join the people table with a subquery that ranks localizations
    # The subquery assigns a rank to each localization, with 1 being the first localization for each organization
    joins(sanitize_sql_array([<<-SQL
      LEFT JOIN (
        SELECT
          localizations.*,
          ROW_NUMBER() OVER(PARTITION BY localizations.about_id ORDER BY localizations.created_at ASC) as rank
        FROM
          university_person_localizations as localizations
      ) localizations ON university_people.id = localizations.about_id
    SQL
    ]))
    .select("university_people.*", localization_first_name_select, localization_last_name_select)
    .group("university_people.id")
    .order("localization_last_name ASC, localization_first_name ASC")
  }

  scope :administration,    -> { where(is_administration: true) }
  scope :teachers,          -> { where(is_teacher: true) }
  scope :researchers,       -> { where(is_researcher: true) }
  scope :alumni,            -> { where(is_alumnus: true) }
  scope :with_habilitation, -> { where(habilitation: true) }
  scope :for_role, -> (role) { where("is_#{role}": true) }
  scope :for_category, -> (category_id) { includes(:categories).where(categories: { id: category_id })}
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

   # TODO L10N : To adjust
  scope :for_search_term, -> (term) {
    joins(:localizations)
      # TODO L10N : To add after filters rework @pabois
      .where("
        unaccent(concat(university_person_localizations.first_name, ' ', university_person_localizations.last_name)) ILIKE unaccent(:term) OR
        unaccent(concat(university_person_localizations.last_name, ' ', university_person_localizations.first_name)) ILIKE unaccent(:term) OR
        unaccent(university_person_localizations.first_name) ILIKE unaccent(:term) OR
        unaccent(university_person_localizations.last_name) ILIKE unaccent(:term) OR
        unaccent(university_people.email) ILIKE unaccent(:term) OR
        unaccent(university_people.phone_mobile) ILIKE unaccent(:term) OR
        unaccent(university_people.phone_personal) ILIKE unaccent(:term) OR
        unaccent(university_people.phone_professional) ILIKE unaccent(:term) OR
        unaccent(university_person_localizations.biography) ILIKE unaccent(:term) OR
        unaccent(university_person_localizations.meta_description) ILIKE unaccent(:term) OR
        unaccent(university_person_localizations.summary) ILIKE unaccent(:term) OR
        unaccent(university_person_localizations.twitter) ILIKE unaccent(:term) OR
        unaccent(university_person_localizations.linkedin) ILIKE unaccent(:term) OR
        unaccent(university_person_localizations.mastodon) ILIKE unaccent(:term) OR
        unaccent(university_people.address) ILIKE unaccent(:term) OR
        unaccent(university_people.zipcode) ILIKE unaccent(:term) OR
        unaccent(university_people.city) ILIKE unaccent(:term) OR
        unaccent(university_person_localizations.url) ILIKE unaccent(:term)
      ", term: "%#{sanitize_sql_like(term)}%")
  }

  def roles
    LIST_OF_ROLES.reject do |role|
      ! send "is_#{role}"
    end
  end

  def dependencies
    contents_dependencies +
    categories +
    active_storage_blobs
  end

  def references
    [administrator, author, researcher, teacher]
  end

  def person
    @person ||= University::Person.find(id)
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

  def full_street_address
    return nil if [address, zipcode, city].all?(&:blank?)
    [address, "#{zipcode} #{city} #{country}".strip].join(', ')
  end

  # TODO L10N : to remove
  def translate_other_attachments(translation)
    translate_attachment(translation, :picture) if picture.attached?
  end

  def to_s_with_mail_in(language)
    best_localization_for(language).to_s_with_mail
  end

  def to_s_alphabetical_in(language)
    best_localization_for(language).to_s_alphabetical
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
