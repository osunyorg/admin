# == Schema Information
#
# Table name: languages
#
#  id         :uuid             not null, primary key
#  iso_code   :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class LanguageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
