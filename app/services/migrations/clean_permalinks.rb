class Migrations::CleanPermalinks
  def self.migrate
    puts 'Migrations::CleanPermalinks'
    new
  end

  def initialize
    all_triplets.each do |about_type, about_id, website_id|
      there_should_be_only_one_current(about_type, about_id, website_id)
    end
    clean_currents.each do |permalink|
      remove_aliases_conflicting_with_current(permalink)
    end
    remaining_aliases_pairs.each do |path, website_id|
      remove_duplicate_aliases(path, website_id)
    end
  end

  def all_triplets
    Communication::Website::Permalink.distinct.pluck(:about_type, :about_id, :website_id)
  end

  def clean_currents
    Communication::Website::Permalink.where(is_current: true)
  end

  def remaining_aliases_pairs
    Communication::Website::Permalink.where(is_current: false).distinct.pluck(:path, :website_id)
  end

  def there_should_be_only_one_current(about_type, about_id, website_id)
    current_permalinks = Communication::Website::Permalink.where(
        about_type: about_type,
        about_id: about_id,
        website_id: website_id,
        is_current: true
      ).order(created_at: :desc)
    return unless current_permalinks.many?
    current_permalinks.where.not(id: current_permalinks.first.id)
                      .delete_all
  end

  def remove_aliases_conflicting_with_current(permalink)
    Communication::Website::Permalink.where(
        path: permalink.path,
        website_id: permalink.website_id,
        is_current: false
      ).delete_all
  end

  def remove_duplicate_aliases(path, website_id)
    aliases = Communication::Website::Permalink.where(
      path: path,
      website_id: website_id,
      is_current: false
    ).order(created_at: :desc)
    if aliases.many?
      aliases.where.not(id: aliases.first.id)
             .delete_all
    end
  end
end
