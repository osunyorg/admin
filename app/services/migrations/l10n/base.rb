class Migrations::L10n::Base

  protected

  def self.constraint
    "university_id IS NOT NULL"
  end

  def self.reconnect_objects_to_categories(model)
    puts
    puts model.model_name.human(count: 2)
    puts "Categories"
    model.find_each do |object|
      puts "#{object.id}"
      if object.categories.any?
        object.categories.each do |category|
          if category.original_id.present?
            puts "Fixing category (#{category.id} > #{category.original_id})"
            object.categories.delete(category)
            object.categories << category.original
          end
        end
      end
    end
  end

  # Get permalinks (for aliases)
  def self.duplicate_permalinks(object, l10n)
    object.permalinks.each do |permalink|
      new_permalink = permalink.dup
      new_permalink.about = l10n
      new_permalink.save
    end
  end

  # Communication::Website::Post(id: xxx) => Communication::Website::Post::Localization(id: yyy)
  def self.reconnect_git_files(object, l10n)
    Communication::Website::GitFile.where(about: object).each do |git_file|
      git_file.update(about: l10n)
    end
  end
end
