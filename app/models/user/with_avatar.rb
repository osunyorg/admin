module User::WithAvatar
  extend ActiveSupport::Concern

  included do
    has_one_attached_deletable :picture
  end
end
