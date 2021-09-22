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
class Language < ApplicationRecord

  validates_uniqueness_of :iso_code

  def to_s
    "#{name}"
  end
end
