# == Schema Information
#
# Table name: university_organizations
#
#  id            :uuid             not null, primary key
#  active        :boolean          default(TRUE)
#  address       :string
#  chapo         :text
#  city          :string
#  country       :string
#  description   :text
#  email         :string
#  kind          :integer          default("company")
#  long_name     :string
#  name          :string
#  nic           :string
#  phone         :string
#  siren         :string
#  slug          :string
#  text          :text
#  url           :string
#  zipcode       :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  university_id :uuid             not null, indexed
#
# Indexes
#
#  index_university_organizations_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_35fcd198e0  (university_id => universities.id)
#
require "test_helper"

class University::OrganizationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
