# == Schema Information
#
# Table name: communication_file_categories
#
#  id               :uuid             not null, primary key
#  bodyclass        :string
#  is_taxonomy      :boolean          default(FALSE)
#  position         :integer          default(0)
#  position_in_tree :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  parent_id        :uuid             indexed
#  university_id    :uuid             not null, indexed
#
# Indexes
#
#  index_communication_file_categories_on_parent_id      (parent_id)
#  index_communication_file_categories_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_00fa9503c3  (university_id => universities.id)
#  fk_rails_061315a91c  (parent_id => communication_file_categories.id)
#
class Communication::File::Category < ApplicationRecord
  include AsCategory
  include HasUniversity
  include Localizable

  has_and_belongs_to_many :files
  alias                   :category_objects :files
end
