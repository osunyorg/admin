module Migrations
  class L10n
    def self.execute
      ::Communication::Website.skip_callback :save, :after, :create_missing_special_pages
      ::Communication::Website.skip_callback :touch, :after, :create_missing_special_pages
      University::Organization.execute
      University::Person.execute
      Communication::Block.execute
      Administration::Location.execute
      Education::Diploma.execute
      Education::Program.execute
      Education::School.execute
      University::Role.execute
      University::Person::Experience.execute
      University::Person::Involvement.execute
      Communication::Website.execute
      Communication::Website::Page.execute
      Communication::Website::Agenda.execute
      Communication::Website::Blog.execute
      Communication::Website::Portfolio.execute
      Communication::Website::Menu.execute
      Research::Journal.execute
      Research::Laboratory.execute
      Research::Laboratory::Axis.execute
      Research::Thesis.execute
    ensure
      ::Communication::Website.set_callback :touch, :after, :create_missing_special_page
      ::Communication::Website.set_callback :save, :after, :create_missing_special_pages
    end
  end
end