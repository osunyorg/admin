class Migrations::DenormalizeMediaExtensions
  def self.migrate
    Communication::Media.find_each(&:save)
  end
end
