module Migrations
  class Authors
    def self.migrate
      # Mono to multi-authors
      Communication::Website::Post.find_each do |post|
        next if post.author_id.blank?
        author = University::Person.find(post.author_id)
        next if author.in?(post.authors)
        puts post.original_localization.to_s
        puts "  Adding author #{author.original_localization}"
        post.authors << author
      end
    end
  end
end