# == Schema Information
#
# Table name: communication_extranets
#
#  id                             :uuid             not null, primary key
#  about_type                     :string           indexed => [about_id]
#  allow_experiences_modification :boolean          default(TRUE)
#  color                          :string
#  cookies_policy                 :text
#  css                            :text
#  feature_alumni                 :boolean          default(FALSE)
#  feature_contacts               :boolean          default(FALSE)
#  feature_jobs                   :boolean          default(FALSE)
#  feature_library                :boolean          default(FALSE)
#  feature_posts                  :boolean          default(FALSE)
#  has_sso                        :boolean          default(FALSE)
#  home_sentence                  :text
#  host                           :string
#  name                           :string
#  privacy_policy                 :text
#  registration_contact           :string
#  sass                           :text
#  sso_button_label               :string
#  sso_cert                       :text
#  sso_mapping                    :jsonb
#  sso_name_identifier_format     :string
#  sso_provider                   :integer          default("saml")
#  sso_target_url                 :string
#  terms                          :text
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  about_id                       :uuid             indexed => [about_type]
#  university_id                  :uuid             not null, indexed
#
# Indexes
#
#  index_communication_extranets_on_about          (about_type,about_id)
#  index_communication_extranets_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_c2268c7ebd  (university_id => universities.id)
#
class Communication::Extranet < ApplicationRecord
  self.filter_attributes += [:sso_cert]

  # We don't include Sanitizable because too many complex attributes. We handle it below.
  include WithAbouts
  include WithConnectedObjects
  include WithFeatures
  include WithLegal
  include WithSso
  include WithStyle
  include WithUniversity

  has_summernote :home_sentence
  has_summernote :terms
  has_summernote :privacy_policy
  has_summernote :cookies_policy

  has_one_attached_deletable :logo
  has_one_attached_deletable :favicon do |attachable|
    attachable.variant :thumb, resize_to_limit: [228, 228]
  end

  has_many :posts
  has_many :post_categories, class_name: 'Communication::Extranet::Post::Category'
  has_many :documents
  has_many :document_categories, class_name: 'Communication::Extranet::Document::Category'
  has_many :document_kinds, class_name: 'Communication::Extranet::Document::Kind'

  validates_presence_of :name, :host
  validates :logo, size: { less_than: 1.megabytes }
  validates :favicon, size: { less_than: 1.megabytes }
  validates_presence_of :about_type, :about_id, if: :feature_alumni

  before_validation :sanitize_fields

  scope :ordered, -> { order(:name) }
  scope :for_search_term, -> (term) {
    where("
      unaccent(communication_extranets.host) ILIKE unaccent(:term) OR
      unaccent(communication_extranets.name) ILIKE unaccent(:term)
    ", term: "%#{sanitize_sql_like(term)}%")
  }

  def self.with_host(host)
    find_by host: host
  end

  def should_show_years?
    # For a single program, year is like cohort
    return false if about.nil? || about&.is_a?(Education::Program)
    # if a school has a single program, same thing
    about&.programs&.many?
  end

  def alumni
    about&.university_person_alumni
  end

  def users
    if feature_alumni?
      university.users.where(person: alumni)
    elsif feature_contacts?
      university.users.where(person: connected_people)
    else
      university.users.none
    end
  end

  def cohorts
    about&.cohorts
  end

  def years
    about&.academic_years
  end
  alias academic_years years

  def organizations
    if about.present? && about.respond_to?(:alumni_organizations)
      about.alumni_organizations
    else
      connected_organizations
    end
  end

  def experiences
    if about.present? && about.respond_to?(:alumni_experiences)
      about.alumni_experiences
    else
      experiences_through_connections
    end
  end

  def url
    @url ||= Rails.env.development? ? "http://#{host}:3000" : "https://#{host}"
  end

  def to_s
    "#{name}"
  end

  private

  def sanitize_fields
    self.color = Osuny::Sanitizer.sanitize(self.color, 'string')
    self.cookies_policy = Osuny::Sanitizer.sanitize(self.cookies_policy, 'text')
    self.host = Osuny::Sanitizer.sanitize(self.host, 'string')
    self.name = Osuny::Sanitizer.sanitize(self.name, 'string')
    self.privacy_policy = Osuny::Sanitizer.sanitize(self.privacy_policy, 'text')
    self.registration_contact = Osuny::Sanitizer.sanitize(self.registration_contact, 'string')
    self.terms = Osuny::Sanitizer.sanitize(self.terms, 'text')
  end
end
