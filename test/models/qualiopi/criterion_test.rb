# == Schema Information
#
# Table name: qualiopi_criterions
#
#  id          :uuid             not null, primary key
#  description :text
#  name        :text
#  number      :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require "test_helper"

class Qualiopi::CriterionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
