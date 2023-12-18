module Favoritable
  extend ActiveSupport::Concern

  included do
    has_many :user_favorites, as: :about, class_name: 'User::Favorite', dependent: :destroy
  end
end
