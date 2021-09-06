# == Schema Information
#
# Table name: communication_websites
#
#  id            :uuid             not null, primary key
#  access_token  :string
#  domain        :string
#  name          :string
#  repository    :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  university_id :uuid             not null
#
# Indexes
#
#  index_communication_websites_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_...  (university_id => universities.id)
#
class Communication::Website < ApplicationRecord
  belongs_to :university
  has_many :pages, foreign_key: :communication_website_id

  def self.with_host(host)
    find_by domain: extract_domain_from(host)
  end

  # Website domain
  # Production with domain    www.iut.u-bordeaux-montaigne.fr
  # Production without        www.iut.u-bordeaux-montaigne.fr.websites.osuny.org
  # Staging                   www.iut.u-bordeaux-montaigne.fr.websites.osuny.dev
  # Dev                       www.iut.u-bordeaux-montaigne.fr.websites.osuny
  def self.extract_domain_from(host)
    host.remove('.websites.osuny.org')
        .remove('.websites.osuny.dev')
        .remove('.websites.osuny')
  end

  def domain_url
    case Rails.env
    when 'development'
      "http://#{domain}.websites.osuny:3000"
    when 'staging'
      "https://#{domain}.websites.osuny.dev"
    when 'production'
      "https://#{domain}"
    end
  end

  def to_s
    "#{name}"
  end
end
