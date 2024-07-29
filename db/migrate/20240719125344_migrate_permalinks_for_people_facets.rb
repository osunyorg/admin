class MigratePermalinksForPeopleFacets < ActiveRecord::Migration[7.1]
  def up
    # Before, we had
    # - A1 : John Doe (Uni::Person FR) with his facets
    # - A2 : John Doe (Uni::Person EN, original: FR) with his facets
    # Now we have
    # - B1 : John Doe (Uni::Person)
    # - B2 : John Doe (Uni::Person::Loca FR) with his facets
    # - B3 : John Doe (Uni::Person::Loca EN) with his facets
    # For the English version, we can't migrate facets permalinks from B1, we need to query A2
    University::Person.find_each do |person|
      # If "old way" translation, we set the about to the original, else if "old way" master, we take its ID.
      about_id = person.original_id || person.id

      l10n = University::Person::Localization.where(
        about_id: about_id,
        language_id: person.language_id
      ).first
      next if l10n.nil?

      # Get permalinks for each facet
      administrator = University::Person::Administrator.find(person.id)
      administrator.permalinks.each do |permalink|
        new_permalink = permalink.dup
        new_permalink.about = l10n.administrator
        new_permalink.save
      end
      author = University::Person::Author.find(person.id)
      author.permalinks.each do |permalink|
        new_permalink = permalink.dup
        new_permalink.about = l10n.author
        new_permalink.save
      end
      researcher = University::Person::Researcher.find(person.id)
      researcher.permalinks.each do |permalink|
        new_permalink = permalink.dup
        new_permalink.about = l10n.researcher
        new_permalink.save
      end
      teacher = University::Person::Teacher.find(person.id)
      teacher.permalinks.each do |permalink|
        new_permalink = permalink.dup
        new_permalink.about = l10n.teacher
        new_permalink.save
      end
    end
  end

  def down
  end
end
