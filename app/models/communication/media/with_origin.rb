module Communication::Media::WithOrigin
  extend ActiveSupport::Concern

  included do
    enum :origin, {
      upload: 1,    # file uploaded (default)
      unsplash: 11, # file imported from Unsplash
      pexels: 12    # file imported from Pexels
    }, prefix: :from
  end
end