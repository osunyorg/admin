module University::WithUsers
  extend ActiveSupport::Concern

  included do
    has_many :users, dependent: :destroy
  end
end
