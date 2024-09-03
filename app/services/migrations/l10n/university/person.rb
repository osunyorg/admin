class Migrations::L10n::University::Person < Migrations::L10n::Base
  def self.execute
    migrate_localizations
    migrate_category_localizations
    migrate_facets
  end

  def self.migrate_localizations
    University::Person.find_each do |person|
      # If "old way" translation, we set the about to the original, else if "old way" master, we take its ID.
      about_id = person.original_id || person.id

      next if University::Person::Localization.where(
        about_id: about_id,
        language_id: person.language_id
      ).exists?

      l10n = University::Person::Localization.create(
        biography: person.biography,
        first_name: person.first_name,
        last_name: person.last_name,
        linkedin: person.linkedin,
        mastodon: person.mastodon,
        meta_description: person.meta_description,
        name: person.name,
        picture_credit: person.picture_credit,
        slug: person.slug,
        summary: person.summary,
        twitter: person.twitter,
        url: person.url,
        about_id: about_id,
        language_id: person.language_id,
        university_id: person.university_id,
        created_at: person.created_at
      )

      # Copy from person (old) to localization (new)
      person.translate_contents!(l10n)
      person.translate_other_attachments(l10n)

      duplicate_permalinks(person, l10n)

      l10n.save
    end
  end

  def self.migrate_category_localizations
    University::Person::Category.find_each do |category|
      about_id = category.original_id || category.id

      next if University::Person::Category::Localization.where(
        about_id: about_id,
        language_id: category.language_id
      ).exists?

      l10n = University::Person::Category::Localization.create(
        name: category.name,
        slug: category.slug,
        about_id: about_id,
        language_id: category.language_id,
        university_id: category.university_id,
        created_at: category.created_at
      )

      category.translate_contents!(l10n)

      duplicate_permalinks(category, l10n)

      l10n.save
    end
  end

  def self.migrate_facets
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

end