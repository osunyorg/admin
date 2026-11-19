# == Schema Information
#
# Table name: server_costs
#
#  id            :uuid             not null, primary key
#  annual_amount :integer          default(0)
#  description   :string
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Server::Cost < ApplicationRecord
  validates :name, :description, :annual_amount, presence: true

  scope :ordered, -> (language = nil) { order(:name, :description) }

  def to_s
    name
  end
end
