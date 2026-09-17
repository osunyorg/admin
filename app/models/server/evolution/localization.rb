# == Schema Information
#
# Table name: server_evolution_localizations
#
#  id           :uuid             not null, primary key
#  text         :text
#  title        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  evolution_id :uuid             not null, uniquely indexed => [language_id], indexed
#  language_id  :uuid             not null, uniquely indexed => [evolution_id], indexed
#
# Indexes
#
#  idx_on_evolution_id_language_id_7cb24cbc2b            (evolution_id,language_id) UNIQUE
#  index_server_evolution_localizations_on_evolution_id  (evolution_id)
#  index_server_evolution_localizations_on_language_id   (language_id)
#
# Foreign Keys
#
#  fk_rails_8d71546882  (evolution_id => server_evolutions.id)
#  fk_rails_ccbc6da0db  (language_id => languages.id)
#
class Server::Evolution::Localization < ApplicationRecord
  belongs_to :evolution
  belongs_to :language

  validates_presence_of :title
  validates :language_id, uniqueness: { scope: :evolution_id }

  def to_s
    "#{title}"
  end
end
