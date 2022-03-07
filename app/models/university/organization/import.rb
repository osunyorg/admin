# == Schema Information
#
# Table name: university_organization_imports
#
#  id            :uuid             not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  university_id :uuid             not null, indexed
#  user_id       :uuid             not null, indexed
#
# Indexes
#
#  index_university_organization_imports_on_university_id  (university_id)
#  index_university_organization_imports_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_31152af0cd  (university_id => universities.id)
#  fk_rails_da057ff44d  (user_id => users.id)
#
class University::Organization::Import < ApplicationRecord
  include WithUniversity

  belongs_to :user

  has_one_attached :file

  after_save :parse

  def lines
    csv.count
  rescue
    'NA'
  end

  def to_s
    "#{user}, #{I18n.l created_at}"
  end

  protected

  def parse
    csv.each do |row|
      university.organizations.where(university: university, name: row['name']).first_or_create do |o|
        [
          :long_name,
          :kind,
          :sirene,
          :description,
          :address,
          :zipcode,
          :city,
          :country,
          :mail,
          :phone,
          :url,
        ].each do |property|
          o[property] = row[property.to_s]
        end
        o.kind ||= :company
      end
    end
  end
  handle_asynchronously :parse, queue: 'default'

  def csv
    @csv ||= CSV.parse file.blob.download, headers: true
  end
end
