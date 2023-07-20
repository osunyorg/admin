# == Schema Information
#
# Table name: universities
#
#  id                         :uuid             not null, primary key
#  address                    :string
#  city                       :string
#  country                    :string
#  has_sso                    :boolean          default(FALSE)
#  identifier                 :string
#  invoice_amount             :string
#  invoice_date               :date
#  invoice_date_yday          :integer
#  is_really_a_university     :boolean          default(TRUE)
#  mail_from_address          :string
#  mail_from_name             :string
#  name                       :string
#  private                    :boolean
#  sms_sender_name            :string
#  sso_button_label           :string
#  sso_cert                   :text
#  sso_mapping                :jsonb
#  sso_name_identifier_format :string
#  sso_provider               :integer          default("saml")
#  sso_target_url             :string
#  zipcode                    :string
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  default_language_id        :uuid             not null, indexed
#
# Indexes
#
#  index_universities_on_default_language_id  (default_language_id)
#
# Foreign Keys
#
#  fk_rails_a8022b1c3f  (default_language_id => languages.id)
#
class University < ApplicationRecord
  self.filter_attributes += [:sso_cert]

  # We don't include Sanitizable because too many complex attributes. We handle it below.
  include WithPeopleAndOrganizations
  include WithCommunication
  include WithCountry
  include WithEducation
  include WithIdentifier
  include WithInvoice
  include WithResearch
  include WithSso
  include WithUsers

  has_one_attached_deletable :logo

  # Can't use dependent: :destroy because of attachments
  # We use after_destroy to let the attachment go first
  has_many :active_storage_blobs, class_name: 'ActiveStorage::Blob'
  has_many :imports, dependent: :destroy
  belongs_to :default_language, class_name: "Language"

  validates_presence_of :name
  validates :sms_sender_name, presence: true, length: { maximum: 11 }
  validates :logo, size: { less_than: 1.megabytes }

  before_validation :sanitize_fields
  after_destroy :destroy_remaining_blobs

  scope :ordered, -> { order(:name) }

  def self.parts
    [
      [University::Person, :admin_university_people_path],
      [University::Organization, :admin_university_organizations_path],
      [User, :admin_users_path],
    ]
  end

  def to_s
    "#{name}"
  end

  def mail_from
    address = mail_from_address.blank? ? ENV['MAIL_FROM_DEFAULT_ADDRESS'] : mail_from_address
    name = mail_from_name.blank? ? ENV['MAIL_FROM_DEFAULT_NAME'] : mail_from_name
    {
      address: address,
      name: name,
      full: "#{name} <#{address}>"
    }
  end

  private

  def sanitize_fields
    self.address = Osuny::Sanitizer.sanitize(self.address, 'string')
    self.city = Osuny::Sanitizer.sanitize(self.city, 'string')
    self.country = Osuny::Sanitizer.sanitize(self.country, 'string')
    self.identifier = Osuny::Sanitizer.sanitize(self.identifier, 'string')
    self.invoice_amount = Osuny::Sanitizer.sanitize(self.invoice_amount, 'string')
    self.mail_from_address = Osuny::Sanitizer.sanitize(self.mail_from_address, 'string')
    self.mail_from_name = Osuny::Sanitizer.sanitize(self.mail_from_name, 'string')
    self.name = Osuny::Sanitizer.sanitize(self.name, 'string')
    self.sms_sender_name = Osuny::Sanitizer.sanitize(self.sms_sender_name, 'string')
    self.sso_button_label = Osuny::Sanitizer.sanitize(self.sso_button_label, 'string')
    self.zipcode = Osuny::Sanitizer.sanitize(self.zipcode, 'string')
  end

  def destroy_remaining_blobs
    active_storage_blobs.delete_all
  end
end
