# == Schema Information
#
# Table name: server_evolutions
#
#  id          :uuid             not null, primary key
#  released_at :date
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Server::Evolution < ApplicationRecord

  has_many :localizations, dependent: :destroy
  accepts_nested_attributes_for :localizations

  validates_presence_of :released_at
  validates_associated :localizations
  
  scope :ordered, -> { order(released_at: :desc) }
  scope :planned, -> { where('released_at > ?', Date.current) }

  def original_localization
    french = Language.find_by(iso_code: :fr)
    localizations.find_by(language: french)
  end

  def localization_for(language)
    localizations.find_by(language_id: language.id)
  end

  def best_localization_for(language)
    localization_for(language) || original_localization
  end

  def to_s
    original_localization.to_s
  end
end
