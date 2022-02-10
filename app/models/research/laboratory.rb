# == Schema Information
#
# Table name: research_laboratories
#
#  id            :uuid             not null, primary key
#  address       :string
#  city          :string
#  country       :string
#  name          :string
#  zipcode       :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  university_id :uuid             not null, indexed
#
# Indexes
#
#  index_research_laboratories_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_f61d27545f  (university_id => universities.id)
#
class Research::Laboratory < ApplicationRecord
  include WithGit

  belongs_to  :university
  has_many    :axes,
              class_name: "Research::Laboratory::Axis",
              foreign_key: :research_laboratory_id,
              dependent: :destroy

  scope :ordered, -> { order(:name) }

  def to_s
    "#{name}"
  end

  def full_address
    [address, zipcode, city].compact.join ' '
  end

  def git_path(website)
    "data/laboratory.yml"
  end
end
