class Migrations::CleanGitFiles
  def self.migrate
    puts 'Migrations::CleanGitFiles'
    new
  end

  def initialize
    all_triplets.each do |about_type, about_id, website_id|
      there_should_be_only_one(about_type, about_id, website_id)
    end
  end

  def all_triplets
    Communication::Website::GitFile.distinct.pluck(:about_type, :about_id, :website_id)
  end

  def there_should_be_only_one(about_type, about_id, website_id)
    git_files = Communication::Website::GitFile.where(
        about_type: about_type,
        about_id: about_id,
        website_id: website_id
      ).order(updated_at: :desc)
    return unless git_files.many?
    git_files.where.not(id: git_files.first.id)
             .destroy_all # We want to trigger callbacks to remove the content attachment
  end

end
