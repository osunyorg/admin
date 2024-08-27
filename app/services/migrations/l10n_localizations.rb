module Migrations
  class L10nLocalizations

    def self.execute
      migrate_education_diploma_localizations
      migrate_education_program_localizations
      migrate_communication_website_localizations
      migrate_communication_website_agenda_event_localizations
      migrate_communication_website_agenda_category_localizations
      migrate_communication_website_menu_items_abouts
      migrate_communication_website_page_localizations
      migrate_communication_website_post_localizations
      migrate_communication_website_post_category_localizations
      migrate_communication_website_post_authors
      migrate_communication_website_portfolio_category_localizations
      reconnect_objects_to_categories Communication::Website::Post
      reconnect_objects_to_categories Communication::Website::Agenda::Event
      reconnect_objects_to_categories Communication::Website::Portfolio::Project
      migrate_university_organization_localizations
      migrate_university_organization_category_localizations
      migrate_university_person_localizations
      migrate_university_person_category_localizations
      migrate_university_person_facets
      migrate_university_person_experiences
    end

    def self.migrate_education_diploma_localizations
      Education::Diploma.find_each do |diploma|
        about_id = diploma.original_id || diploma.id

        l10n = Education::Diploma::Localization.create(
          duration: diploma.duration,
          name: diploma.name,
          short_name: diploma.short_name,
          slug: diploma.slug,
          summary: diploma.summary,
          about_id: about_id,
          language_id: diploma.language_id,
          university_id: diploma.university_id,
          created_at: diploma.created_at
        )

        diploma.translate_contents!(l10n)

        duplicate_permalinks(diploma, l10n)

        l10n.save
      end
    end

    def self.migrate_education_program_localizations
      Education::Program.find_each do |program|
        about_id = program.original_id || program.id

        l10n = Education::Program::Localization.create(
          accessibility: program.accessibility,
          contacts: program.contacts,
          content: program.content,
          duration: program.duration,
          evaluation: program.evaluation,
          featured_image_alt: program.featured_image_alt,
          featured_image_credit: program.featured_image_credit,
          meta_description: program.meta_description,
          name: program.name,
          objectives: program.objectives,
          opportunities: program.opportunities,
          other: program.other,
          path: program.path,
          pedagogy: program.pedagogy,
          prerequisites: program.prerequisites,
          presentation: program.presentation,
          pricing: program.pricing,
          pricing_apprenticeship: program.pricing_apprenticeship,
          pricing_continuing: program.pricing_continuing,
          pricing_initial: program.pricing_initial,
          published: program.published,
          published_at: program.created_at,
          qualiopi_text: program.qualiopi_text,
          registration: program.registration,
          registration_url: program.registration_url,
          results: program.results,
          short_name: program.short_name,
          slug: program.slug,
          summary: program.summary,
          url: program.url,

          about_id: about_id,
          language_id: program.language_id,
          university_id: program.university_id,
          created_at: program.created_at
        )

        program.translate_contents!(l10n)
        program.translate_attachment(l10n, :featured_image)
        program.translate_attachment(l10n, :shared_image)
        program.translate_attachment(l10n, :downloadable_summary)
        program.translate_attachment(l10n, :logo)

        duplicate_permalinks(program, l10n)

        l10n.save
      end
    end

    def self.migrate_communication_website_localizations
      # 1. créer les locas principales
      # 2. créer les locas manquantes avec les données du website par défaut (name, socials)
      # 3. ajouter la publication aux locas existantes
      Communication::Website::Localization.reset_column_information
      Communication::Website.includes(:legacy_languages).find_each do |website|
        website.legacy_languages.each do |language|
          l10n = website.localization_for(language)
          if l10n
            # Loca existante, on la publie
            l10n.update(
              published: true,
              published_at: Time.now
            )
          else
            # Loca manquante (principale ou pas), on la crée avec les données du website et on la publie
            website.localizations.create(
              university_id: website.university_id,
              language_id: language.id,
              name: website.name,
              social_email: website.social_email,
              social_facebook: website.social_facebook,
              social_github: website.social_github,
              social_instagram: website.social_instagram,
              social_linkedin: website.social_linkedin,
              social_mastodon: website.social_mastodon,
              social_peertube: website.social_peertube,
              social_tiktok: website.social_tiktok,
              social_vimeo: website.social_vimeo,
              social_x: website.social_x,
              social_youtube: website.social_youtube,
              published: true,
              published_at: Time.now
            )
          end
        end
      end
    end

    def self.migrate_university_organization_localizations
      University::Organization.find_each do |orga|
        # If "old way" translation, we set the about to the original, else if "old way" master, we take its ID.
        about_id = orga.original_id || orga.id

        l10n = University::Organization::Localization.create(
          address_additional: orga.address_additional,
          address_name: orga.address_name,
          linkedin: orga.linkedin,
          long_name: orga.long_name,
          mastodon: orga.mastodon,
          meta_description: orga.meta_description,
          name: orga.name,
          summary: orga.summary,
          text: orga.text,
          twitter: orga.twitter,
          url: orga.url,
          about_id: about_id,
          language_id: orga.language_id,
          university_id: orga.university_id,
          created_at: orga.created_at
        )

        # Copy from orga (old) to localization (new)
        orga.translate_contents!(l10n)
        orga.translate_other_attachments(l10n)

        duplicate_permalinks(orga, l10n)

        l10n.save

      end
    end

    def self.migrate_communication_website_post_localizations
      Communication::Website::Post.find_each do |post|
        puts "Migration post #{post.id}"

        about_id = post.original_id || post.id

        l10n = Communication::Website::Post::Localization.create(
          featured_image_alt: post.featured_image_alt,
          featured_image_credit: post.featured_image_credit,
          meta_description: post.meta_description,
          migration_identifier: post.migration_identifier,
          pinned: post.pinned,
          published: post.published,
          published_at: post.published_at,
          slug: post.slug,
          summary: post.summary,
          text: post.text,
          title: post.title,
          about_id: about_id,
          language_id: post.language_id,
          communication_website_id: post.communication_website_id,
          university_id: post.university_id,
          created_at: post.created_at
        )

        post.translate_contents!(l10n)
        post.translate_attachment(l10n, :featured_image)
        post.translate_other_attachments(l10n)

        duplicate_permalinks(post, l10n)

        l10n.save
      end
    end

    def self.migrate_communication_website_post_category_localizations
      Communication::Website::Post::Category.find_each do |object|
        puts "Migration category #{object.id}"

        about_id = object.original_id || object.id

        l10n = Communication::Website::Post::Category::Localization.create(
          featured_image_alt: object.featured_image_alt,
          featured_image_credit: object.featured_image_credit,
          meta_description: object.meta_description,
          slug: object.slug,
          path: object.path,
          summary: object.summary,
          name: object.name,
          about_id: about_id,
          language_id: object.language_id,
          communication_website_id: object.communication_website_id,
          university_id: object.university_id,
          created_at: object.created_at
        )

        object.translate_contents!(l10n)
        object.translate_other_attachments(l10n)

        duplicate_permalinks(object, l10n)

        l10n.save

      end
    end

    def self.migrate_university_person_localizations
      University::Person.find_each do |person|
        # If "old way" translation, we set the about to the original, else if "old way" master, we take its ID.
        about_id = person.original_id || person.id

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

    def self.migrate_university_person_category_localizations
      University::Person::Category.find_each do |category|
        about_id = category.original_id || category.id

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

    def self.migrate_university_organization_category_localizations
      University::Organization::Category.find_each do |category|
        about_id = category.original_id || category.id

        l10n = University::Organization::Category::Localization.create(
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

    def self.migrate_university_person_facets
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

    def self.migrate_communication_website_page_localizations
      Communication::Website::Page.find_each do |page|
        puts "Migration page #{page.id}"

        about_id = page.original_id || page.id

        l10n = Communication::Website::Page::Localization.create(
          breadcrumb_title: page.breadcrumb_title,
          featured_image_alt: page.featured_image_alt,
          featured_image_credit: page.featured_image_credit,
          header_cta: page.header_cta,
          header_cta_label: page.header_cta_label,
          header_cta_url: page.header_cta_url,
          header_text: page.header_text,
          meta_description: page.meta_description,
          migration_identifier: page.migration_identifier,
          published: page.published,
          published_at: page.published_at,
          slug: page.slug,
          summary: page.summary,
          text: page.text,
          title: page.title,
          about_id: about_id,
          language_id: page.language_id,
          communication_website_id: page.communication_website_id,
          university_id: page.university_id,
          created_at: page.created_at
        )

        page.translate_contents!(l10n)
        page.translate_attachment(l10n, :featured_image)
        page.translate_other_attachments(l10n)

        duplicate_permalinks(page, l10n)

        l10n.save
      end
    end

    def self.migrate_university_person_experiences
      University::Person::Experience.find_each do |experience|
        # En théorie, il faut : 
        # 1. vérifier que l'expérience originale existe,
        # 2. sinon la créer
        # 3. puis supprimer l'expérience
        # En pratique, les expériences concernent uniquement MMI et IJBA, qui sont monolingues, donc on saute au 3.
        organization = experience.organization
        person = experience.person
        experience_is_original = organization.original_id.blank? && person.original_id.blank?
        experience.destroy unless experience_is_original
      end
    end

    def self.migrate_communication_website_agenda_event_localizations
      Communication::Website::Agenda::Event.find_each do |event|
        puts "Migration event #{event.id}"

        about_id = event.original_id || event.id

        l10n = Communication::Website::Agenda::Event::Localization.create(
          add_to_calendar_urls: event.add_to_calendar_urls,
          featured_image_alt: event.featured_image_alt,
          featured_image_credit: event.featured_image_credit,
          meta_description: event.meta_description,
          migration_identifier: event.migration_identifier,
          published: event.published,
          published_at: event.updated_at, # No published_at yet
          slug: event.slug,
          subtitle: event.subtitle,
          summary: event.summary,
          title: event.title,
          about_id: about_id,

          language_id: event.language_id,
          communication_website_id: event.communication_website_id,
          university_id: event.university_id,
          created_at: event.created_at
        )

        event.translate_contents!(l10n)
        event.translate_attachment(l10n, :featured_image)
        event.translate_other_attachments(l10n)

        duplicate_permalinks(event, l10n)

        l10n.save
      end
    end

    def self.migrate_communication_website_agenda_category_localizations
      Communication::Website::Agenda::Category.find_each do |category|
        about_id = category.original_id || category.id

        l10n = Communication::Website::Agenda::Category::Localization.create(
          featured_image_alt: category.featured_image_alt,
          featured_image_credit: category.featured_image_credit,
          meta_description: category.meta_description,
          name: category.name,
          slug: category.slug,
          path: category.path,

          about_id: about_id,
          language_id: category.language_id,
          communication_website_id: category.communication_website_id,
          university_id: category.university_id,

          created_at: category.created_at
        )

        category.translate_contents!(l10n)
        category.translate_attachment(l10n, :featured_image)

        duplicate_permalinks(category, l10n)

        l10n.save
      end
    end

    def self.migrate_communication_website_menu_items_abouts
      Communication::Website::Menu::Item.where.not(kind: [:blank, :url]).find_each do |menu_item|
        about = menu_item.about
        next if about.nil?
        puts "Migration menu item #{menu_item.id}"
        # Kind like paper can't respond to original_id
        about_id = about.try(:original_id) || about.id
        menu_item.update_column :about_id, about_id
      end
    end

    def self.migrate_communication_website_portfolio_project_localizations
      Communication::Website::Portfolio::Project.find_each do |project|
        puts "Migration project #{project.id}"

        about_id = project.original_id || project.id

        l10n = Communication::Website::Portfolio::Project::Localization.create(
          featured_image_alt: project.featured_image_alt,
          featured_image_credit: project.featured_image_credit,
          meta_description: project.meta_description,
          published: project.published,
          published_at: project.updated_at, # No published_at yet
          slug: project.slug,
          summary: project.summary,
          title: project.title,
          about_id: about_id,

          language_id: project.language_id,
          communication_website_id: project.communication_website_id,
          university_id: project.university_id,
          created_at: project.created_at
        )

        project.translate_contents!(l10n)
        project.translate_attachment(l10n, :featured_image)
        project.translate_other_attachments(l10n)

        duplicate_permalinks(project, l10n)

        l10n.save
      end
    end

    def self.migrate_communication_website_portfolio_category_localizations
      Communication::Website::Portfolio::Category.find_each do |category|
        puts "Migration category #{category.id}"

        about_id = category.original_id || category.id

        l10n = Communication::Website::Portfolio::Category::Localization.create(
          featured_image_alt: category.featured_image_alt,
          featured_image_credit: category.featured_image_credit,
          meta_description: category.meta_description,
          name: category.name,
          path: category.path,
          published: true, # No published yet
          published_at: category.updated_at, # No published_at yet
          slug: category.slug,
          summary: category.summary,
          about_id: about_id,

          language_id: category.language_id,
          communication_website_id: category.communication_website_id,
          university_id: category.university_id,
          created_at: category.created_at
        )

        category.translate_contents!(l10n)
        category.translate_attachment(l10n, :featured_image)

        duplicate_permalinks(category, l10n)

        l10n.save
      end
    end

    def self.migrate_communication_website_post_authors
      puts Communication::Website::Post.model_name.human(count: 2)
      puts "Authors"
      Communication::Website::Post.find_each do |post|
        puts "#{post.id}"
        if post.author && post.author.original_id.present?
          puts "Fixing author (#{post.author.id} > #{post.author.original_id})"
          post.update_column :author_id, post.author.original_id
        end
      end
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

    protected

    # Get permalinks (for aliases)
    def self.duplicate_permalinks(object, l10n)
      object.permalinks.each do |permalink|
        new_permalink = permalink.dup
        new_permalink.about = l10n
        new_permalink.save
      end
    end
    
  end
end