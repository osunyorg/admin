module Migrations
  class L10n
    def self.execute
      Education::Diploma.execute
      Education::Program.execute
      Education::School.execute
      Communication::Website.execute
      Communication::Website::Agenda.execute
      Communication::Website::Blog.execute
      Communication::Website::Menu.execute
      Communication::Website::Page.execute
      Communication::Website::Portfolio.execute
      University::Organization.execute
      University::Person.execute
      Research::Journal.execute
      Research::Laboratory.execute
      Research::Laboratory::Axis.execute
      Research::Thesis.execute
    end
  end
end