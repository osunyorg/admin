module Migrations
  class L10nCleaner
    def self.execute
      ::Communication::Website.skip_callback :save, :after, :create_missing_special_pages
      ::Communication::Website.skip_callback :touch, :after, :create_missing_special_pages

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
    ensure
      ::Communication::Website.set_callback :touch, :after, :create_missing_special_page
      ::Communication::Website.set_callback :save, :after, :create_missing_special_pages
    end
  end
end