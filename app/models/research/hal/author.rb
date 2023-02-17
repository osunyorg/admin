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
class Research::Hal::Author < ApplicationRecord
  has_and_belongs_to_many :publications
end
