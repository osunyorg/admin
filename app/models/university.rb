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
  include WithCommunication
  include WithEducation
  include WithIdentifier
  include WithResearch
  include WithUsers

  has_one_attached_deletable :logo

  validates_presence_of :name
  validates :sms_sender_name, presence: true, length: { maximum: 11 }

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
end
