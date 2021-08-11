# == Schema Information
#
# Table name: features_websites_sites
#
#  id            :uuid             not null, primary key
#  domain        :string
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  university_id :uuid             not null
#
# Indexes
#
#  index_features_websites_sites_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_...  (university_id => universities.id)
#
class Features::Websites::Site < ApplicationRecord
  belongs_to :university

  def domain_url
    case Rails.env
    when 'development'
      "http://#{domain}.#{university.identifier}.osuny:3000"
    when 'staging'
      "https://#{domain}.#{university.identifier}.osuny.dev"
    when 'production'
      "https://#{domain}"
    end
  end

  def to_s
    "#{name}"
  end
end
