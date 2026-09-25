class Migrations::DenormalizeMediaContexts
  def self.migrate
    Communication::Media::Context.find_each(&:save)
  end
end
