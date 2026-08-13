class Migrations::DenormalizeWebsitesInFileContexts
  def self.migrate
    Communication::File::Context.find_each(&:save)
  end
end
