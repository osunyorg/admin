class Migrations::DenormalizeFileExtensions
  def self.migrate
    Communication::File::Localization.find_each(&:save)
  end
end
