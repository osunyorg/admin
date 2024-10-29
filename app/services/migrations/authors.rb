module Migrations
  class Authors
    def self.migrate
      authors_ids = Communication::Website::Post.pluck(:author_id) + Communication::Extranet::Post.pluck(:author_id)
      authors_ids.uniq!
                 .compact!
      puts "#{authors_ids.count} authors"
      University::Person.where(id: authors_ids).update_all(is_author: true)
    end
  end
end