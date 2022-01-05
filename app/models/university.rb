# == Schema Information
#
# Table name: universities
#
#  id                :uuid             not null, primary key
#  address           :string
#  city              :string
#  country           :string
#  identifier        :string
#  mail_from_address :string
#  mail_from_name    :string
#  name              :string
#  private           :boolean
#  sms_sender_name   :string
#  zipcode           :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class University < ApplicationRecord
  include WithPeople
  include WithCommunication
  include WithEducation
  include WithIdentifier
  include WithResearch
  include WithUsers

  has_one_attached_deletable :logo

  # Can't use dependent: :destroy because of attachments
  # We use after_destroy to let the attachment go first
  has_many :active_storage_blobs, class_name: 'ActiveStorage::Blob'

  validates_presence_of :name
  validates :sms_sender_name, presence: true, length: { maximum: 11 }

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
