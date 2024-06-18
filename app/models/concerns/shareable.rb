module Shareable
  extend ActiveSupport::Concern

  included do
    has_one_attached_deletable :shared_image

    validates :shared_image, size: { less_than: 500.kilobytes }
  end
end
