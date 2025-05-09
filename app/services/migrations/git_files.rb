class Migrations::GitFiles
  def self.migrate_all
    Communication::Website::GitFile.desynchronized.find_each do |git_file|
      Communication::Website::GitFile::MigrateJob.perform_later git_file
    end
  end
end