class Migrations::L10n::Communication::Block < Migrations::L10n::Base
  def self.execute
    # Le but est de rebrancher tous les éléments targetés dans les blocs aux "originaux" puisqu'avec
    # la refonte, les objets non originaux sont voués à disparaitre.
    begin
      # Skip callbacks
      Communication::Block.skip_callback :save, :after, :touch_about
      Communication::Block.skip_callback :save, :after, :connect_and_sync_direct_sources
      Communication::Block.skip_callback :save, :after, :clean_websites_if_necessary

      Communication::Block.pages.find_each do |block|
        template = block.template
        if (main_page = Communication::Website::Page.find_by(id: template.page_id)).present?
          new_main_page_id = main_page.original_id || main_page.id
          template.page_id = new_main_page_id
        end
        template.elements.each do |element|
          if (page = Communication::Website::Page.find_by(id: element.id)).present?
            new_page_id = page.original_id || page.id
            element.id = new_page_id
          end
        end
        block.data = template.data
        block.save
      end

      Communication::Block.posts.find_each do |block|
        template = block.template
        if (category = Communication::Website::Post::Category.find_by(id: template.category_id)).present?
          new_category_id = category.original_id || category.id
          template.category_id = new_category_id
        end
        template.elements.each do |element|
          if (post = Communication::Website::Post.find_by(id: element.id)).present?
            new_post_id = post.original_id || post.id
            element.id = new_post_id
          end
        end
        block.data = template.data
        block.save
      end

      Communication::Block.persons.find_each do |block|
        template = block.template
        if (category = University::Person::Category.find_by(id: template.category_id)).present?
          new_category_id = category.original_id || category.id
          template.category_id = new_category_id
        end
        template.elements.each do |element|
          if (person = University::Person.find_by(id: element.id)).present?
            new_person_id = person.original_id || person.id
            element.id = new_person_id
          end
        end
        block.data = template.data
        block.save
      end

      Communication::Block.organizations.find_each do |block|
        template = block.template
        if (category = University::Organization::Category.find_by(id: template.category_id)).present?
          new_category_id = category.original_id || category.id
          template.category_id = new_category_id
        end
        template.elements.each do |element|
          if (organization = University::Organization.find_by(id: element.id)).present?
            new_organization_id = organization.original_id || organization.id
            element.id = new_organization_id
          end
        end
        block.data = template.data
        block.save
      end

      Communication::Block.agenda.find_each do |block|
        template = block.template
        if (category = Communication::Website::Agenda::Category.find_by(id: template.category_id)).present?
          new_category_id = category.original_id || category.id
          template.category_id = new_category_id
        end
        template.elements.each do |element|
          if (event = Communication::Website::Agenda::Event.find_by(id: element.id)).present?
            new_event_id = event.original_id || event.id
            element.id = new_event_id
          end
        end
        block.data = template.data
        block.save
      end

      Communication::Block.programs.find_each do |block|
        template = block.template
        template.elements.each do |element|
          if (program = Education::Program.find_by(id: element.id)).present?
            new_program_id = program.original_id || program.id
            element.id = new_program_id
          end
        end
        block.data = template.data
        block.save
      end

      Communication::Block.locations.find_each do |block|
        template = block.template
        template.elements.each do |element|
          if (location = Administration::Location.find_by(id: element.id)).present?
            new_location_id = location.original_id || location.id
            element.id = new_location_id
          end
        end
        block.data = template.data
        block.save
      end

      Communication::Block.projects.find_each do |block|
        template = block.template
        if (category = Communication::Website::Portfolio::Category.find_by(id: template.category_id)).present?
          new_category_id = category.original_id || category.id
          template.category_id = new_category_id
        end
        template.elements.each do |element|
          if (project = Communication::Website::Portfolio::Project.find_by(id: element.id)).present?
            new_project_id = project.original_id || project.id
            element.id = new_project_id
          end
        end
        block.data = template.data
        block.save
      end

    ensure
      # Re-set callbacks
      Communication::Block.set_callback :save, :after, :clean_websites_if_necessary
      Communication::Block.set_callback :save, :after, :connect_and_sync_direct_sources
      Communication::Block.set_callback :save, :after, :touch_about
    end
  end
end
