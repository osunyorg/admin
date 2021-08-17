# == Schema Information
#
# Table name: features_education_qualiopi_indicators
#
#  id             :uuid             not null, primary key
#  glossary       :text
#  level_expected :text
#  name           :text
#  non_conformity :text
#  number         :integer
#  proof          :text
#  requirement    :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  criterion_id   :uuid             not null
#
# Indexes
#
#  index_features_education_qualiopi_indicators_on_criterion_id  (criterion_id)
#
# Foreign Keys
#
#  fk_rails_...  (criterion_id => features_education_qualiopi_criterions.id)
#
class Administration::Qualiopi::Indicator < ApplicationRecord
  belongs_to :criterion

  validates :number, uniqueness: true

  def to_s
    "Indicateur #{number}"
  end
end
