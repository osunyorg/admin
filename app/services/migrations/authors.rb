module Migrations
  class Authors
    def self.migrate
      University::Person.find_each do |person|
        person.update_column :is_author, person.communication_website_posts.any?
      end
    end
  end
end