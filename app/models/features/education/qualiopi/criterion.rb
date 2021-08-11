# == Schema Information
#
# Table name: features_education_qualiopi_criterions
#
#  id          :uuid             not null, primary key
#  description :text
#  name        :text
#  number      :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Features::Education::Qualiopi::Criterion < ApplicationRecord
  has_many :indicators

  def to_s
    "Critère #{number}"
  end
end
