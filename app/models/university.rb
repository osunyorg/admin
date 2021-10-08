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
#  zipcode           :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class University < ApplicationRecord
  validates_presence_of :name
  scope :ordered, -> { order(:name) }

  include WithIdentifier
  include WithUsers
  include WithEducation
  include WithResearch
  include WithCommunication

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
