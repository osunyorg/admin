module Migrations
  class Authors
    # Mono to multi-authors
    def self.migrate
      Communication::Website::Post.where.not(author_id: nil).find_each do |post|
        migrate_post(post)
      end
    end

    protected

    def self.migrate_post(post)
      author = University::Person.find(post.author_id)
      return if author.in?(post.authors)
      puts post.original_localization.to_s
      puts " author #{author.original_localization}"
      post.authors << author
  end
  end
end