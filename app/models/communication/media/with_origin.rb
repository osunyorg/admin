module Communication::Media::WithOrigin
  extend ActiveSupport::Concern

  included do
    enum :origin, {
      upload: 1,    # file uploaded (default)
      unsplash: 11, # file imported from Unsplash
      pexels: 12,   # file imported from Pexels
      curator: 50,  # file curated
    }, prefix: :from
  end
end