# == Schema Information
#
# Table name: research_hal_authors
#
#  id                :uuid             not null, primary key
#  doc_identifier    :string
#  first_name        :string
#  form_identifier   :string
#  full_name         :string
#  last_name         :string
#  person_identifier :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
require "test_helper"

class Research::Hal::AuthorTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
