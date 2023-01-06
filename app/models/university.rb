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
#
class University < ApplicationRecord
  self.filter_attributes += [:sso_cert]

  include WithPeopleAndOrganizations
  include WithCommunication
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

  validates_presence_of :name
  validates :sms_sender_name, presence: true, length: { maximum: 11 }
  validates :logo, size: { less_than: 5.megabytes }

  after_destroy :destroy_remaining_blobs

  scope :ordered, -> { order(:name) }

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

  def destroy_remaining_blobs
    active_storage_blobs.delete_all
  end
end
