class Migrations::PublishMediaAndFiles
  def self.migrate
    Communication::Media::Localization.update_all(published: true, published_at: Time.current)
    Communication::File::Localization.update_all(published: true, published_at: Time.current)
  end
end