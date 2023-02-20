# == Schema Information
#
# Table name: research_hal_authors
#
#  id                :uuid             not null, primary key
#  docid             :string           indexed
#  first_name        :string
#  form_identifier   :string
#  full_name         :string
#  last_name         :string
#  person_identifier :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_research_hal_authors_on_docid  (docid)
#
require "test_helper"

class Research::Hal::AuthorTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
