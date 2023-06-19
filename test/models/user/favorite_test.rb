# == Schema Information
#
# Table name: user_favorites
#
#  id         :uuid             not null, primary key
#  about_type :string           not null, indexed => [about_id]
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  about_id   :uuid             not null, indexed => [about_type]
#  user_id    :uuid             not null, indexed
#
# Indexes
#
#  index_user_favorites_on_about    (about_type,about_id)
#  index_user_favorites_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_25ed4cb388  (user_id => users.id)
#
require "test_helper"

class User::FavoriteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
