class Server::Cost < ApplicationRecord
  validates :name, :description, :annual_amount, presence: true

  scope :ordered, -> (language = nil) { order(name: :asc) }

  def to_s
    name
  end
end
