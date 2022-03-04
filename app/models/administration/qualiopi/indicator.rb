# == Schema Information
#
# Table name: administration_qualiopi_indicators
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
#  criterion_id   :uuid             not null, indexed
#
# Indexes
#
#  index_administration_qualiopi_indicators_on_criterion_id  (criterion_id)
#
# Foreign Keys
#
#  fk_rails_31f1a0a2c9  (criterion_id => administration_qualiopi_criterions.id)
#
class Administration::Qualiopi::Indicator < ApplicationRecord
  include Sanitizable

  belongs_to :criterion

  validates :number, uniqueness: true

  def to_s
    "Indicateur #{number}"
  end
end
