# == Schema Information
#
# Table name: administration_qualiopi_criterions
#
#  id          :uuid             not null, primary key
#  description :text
#  name        :text
#  number      :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Administration::Qualiopi::Criterion < ApplicationRecord
  include Sanitizable

  has_many :indicators, dependent: :destroy

  validates :number, uniqueness: true

  def to_s
    "Critère #{number}"
  end
end
