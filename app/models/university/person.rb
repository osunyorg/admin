# == Schema Information
#
# Table name: university_people
#
#  id                            :uuid             not null, primary key
#  address                       :string
#  address_visibility            :integer          default("private")
#  birthdate                     :date
#  city                          :string
#  country                       :string
#  email                         :string
#  email_visibility              :integer          default("private")
#  gender                        :integer
#  habilitation                  :boolean          default(FALSE)
#  is_administration             :boolean
#  is_alumnus                    :boolean          default(FALSE)
#  is_author                     :boolean
#  is_researcher                 :boolean
#  is_teacher                    :boolean
#  linkedin_visibility           :integer          default("private")
#  mastodon_visibility           :integer          default("private")
#  phone_mobile                  :string
#  phone_mobile_visibility       :integer          default("private")
#  phone_personal                :string
#  phone_personal_visibility     :integer          default("private")
#  phone_professional            :string
#  phone_professional_visibility :integer          default("private")
#  tenure                        :boolean          default(FALSE)
#  twitter_visibility            :integer          default("private")
#  zipcode                       :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  created_by_id                 :uuid             indexed
#  university_id                 :uuid             not null, indexed
#  user_id                       :uuid             indexed
#
# Indexes
#
#  index_university_people_on_created_by_id  (created_by_id)
#  index_university_people_on_university_id  (university_id)
#  index_university_people_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_6e77b14f8b  (created_by_id => users.id)
#  fk_rails_b47a769440  (user_id => users.id)
#  fk_rails_da35e70d61  (university_id => universities.id)
#
class University::Person < ApplicationRecord
  include AsIndirectObject
  include Filterable
  include Categorizable # Must be loaded after Filterable to be filtered by categories
  include GeneratesGitFiles
  include Localizable
  include MentionableByBlocks
  include Sanitizable
  include Searchable
  include WithAlumnus
  include WithBlobs
  include WithCountry
  include WithFacets
  include WithInvolvements
  include WithPersonalData
  include WithPicture
  include WithRealmAdministration
  include WithRealmCommunication
  include WithRealmEducation
  include WithRealmResearch
  include WithUniversity

  enum :gender, { male: 0, female: 1, non_binary: 2 }

  belongs_to  :created_by,
              class_name: "User",
              optional: true
  belongs_to :user, optional: true

  validates :email,
            uniqueness: { scope: :university_id },
            allow_blank: true,
            if: :will_save_change_to_email?
  validates :email,
            format: { with: Devise::email_regexp },
            allow_blank: true,
            if: :will_save_change_to_email?

  before_validation :sanitize_email

  scope :ordered, -> (language) {
    localization_first_name_select = <<-SQL
      COALESCE(
        MAX(CASE WHEN localizations.language_id = '#{language.id}' THEN TRIM(LOWER(UNACCENT(localizations.first_name))) END),
        MAX(TRIM(LOWER(UNACCENT(localizations.first_name)))) FILTER (WHERE localizations.rank = 1)
      ) AS localization_first_name
    SQL
    localization_last_name_select = <<-SQL
      COALESCE(
        MAX(CASE WHEN localizations.language_id = '#{language.id}' THEN TRIM(LOWER(UNACCENT(localizations.last_name))) END),
        MAX(TRIM(LOWER(UNACCENT(localizations.last_name)))) FILTER (WHERE localizations.rank = 1)
      ) AS localization_last_name
    SQL

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

  scope :for_program, -> (program_id, language = nil) {
    left_joins(:education_programs_as_administrator, :education_programs_as_teacher)
      .where(education_programs: { id: program_id })
      .or(
        left_joins(:education_programs_as_administrator, :education_programs_as_teacher)
          .where(education_programs_as_teachers_university_people: { id: program_id })
      )
      .select("university_people.*")
      .distinct
  }
  scope :for_search_term, -> (term, language) {
    joins(:localizations)
      .where(university_person_localizations: { language_id: language.id })
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

  def dependencies
    localizations +
    categories +
    active_storage_blobs
  end

  def references
    super +
    mentions_by_blocks
  end

  def full_street_address
    return nil if [address, zipcode, city].all?(&:blank?)
    [address, "#{zipcode} #{city} #{country}".strip].join(', ')
  end

  def to_s_with_mail_in(language)
    best_localization_for(language).to_s_with_mail
  end

  def to_s_alphabetical_in(language)
    best_localization_for(language).to_s_alphabetical
  end

  protected

  def blocks_mentioning_self
    @blocks_mentioning_self ||= university.communication_blocks
                                          .template_persons
                                          .select { |block| block.template.persons.include?(self) }
  end

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
