module Migrations
  class L10nCleaner
    def self.execute
      ::Communication::Website.skip_callback :save, :after, :create_missing_special_pages
      ::Communication::Website.skip_callback :touch, :after, :create_missing_special_pages

      remove_non_original_objects
      remove_obsolete_permalinks
    ensure
      ::Communication::Website.set_callback :touch, :after, :create_missing_special_page
      ::Communication::Website.set_callback :save, :after, :create_missing_special_pages
    end

    protected

    def self.remove_non_original_objects
      Administration::Location.where.not(original_id: nil).destroy_all
      Communication::Website::Agenda::Category.where.not(original_id: nil).destroy_all
      Communication::Website::Agenda::Event.where.not(original_id: nil).destroy_all
      Communication::Website::Page.where.not(original_id: nil).destroy_all
      Communication::Website::Portfolio::Category.where.not(original_id: nil).destroy_all
      Communication::Website::Portfolio::Project.where.not(original_id: nil).destroy_all
      Communication::Website::Post::Category.where.not(original_id: nil).destroy_all
      Communication::Website::Post.where.not(original_id: nil).destroy_all
      Education::Diploma.where.not(original_id: nil).destroy_all
      Education::Program.where.not(original_id: nil).destroy_all
      Education::School.where.not(original_id: nil).destroy_all
      University::Organization::Category.where.not(original_id: nil).destroy_all
      University::Organization.where.not(original_id: nil).destroy_all
      University::Person.where.not(original_id: nil).destroy_all
      University::Person::Category.where.not(original_id: nil).destroy_all
      University::Person::Involvement.where.not(original_id: nil).destroy_all
      University::Role.where.not(original_id: nil).destroy_all
    end

    def self.remove_obsolete_permalinks
      about_types_to_delete = [
        "Administration::Location",
        "Communication::Website::Agenda::Event",
        "Communication::Website::Agenda::Category",
        "Communication::Website::Page",
        "Communication::Website::Portfolio::Project",
        "Communication::Website::Portfolio::Category",
        "Communication::Website::Post",
        "Communication::Website::Post::Category",
        "Education::Diploma",
        "Education::Program",
        "Research::Journal::Paper",
        "Research::Journal::Volume",
        "University::Organization",
        "University::Organization::Category",
        "University::Person",
        "University::Person::Category",
        "University::Person::Administrator",
        "University::Person::Author",
        "University::Person::Researcher",
        "University::Person::Teacher"
      ]
      Communication::Website::Permalink.where(about_type: about_types_to_delete).destroy_all
    end
  end
end