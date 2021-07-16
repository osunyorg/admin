# == Schema Information
#
# Table name: qualiopi_indicators
#
#  id             :uuid             not null, primary key
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
#  index_qualiopi_indicators_on_criterion_id  (criterion_id)
#
# Foreign Keys
#
#  fk_rails_...  (criterion_id => qualiopi_criterions.id)
#
class Qualiopi::Indicator < ApplicationRecord
  belongs_to :criterion

  def to_s
    "Indicateur #{number}"
  end
end
