# == Schema Information
#
# Table name: universities
#
#  id                :uuid             not null, primary key
#  address           :string
#  city              :string
#  country           :string
#  identifier        :string
#  mail_from_address :string
#  mail_from_name    :string
#  name              :string
#  private           :boolean
#  zipcode           :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
require "test_helper"

class UniversityTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
