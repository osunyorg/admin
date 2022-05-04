module WithUnsplash
  extend ActiveSupport::Concern

  def add_unsplash_image(id)
    photo = Unsplash::Photo.find id
    url = photo['links']['download']
    filename = "#{photo['id']}.jpg"
    begin
      file = URI.open url
      featured_image.attach(io: file, filename: filename)
      photo.track_download
    rescue
    end
  end
end
