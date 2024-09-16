class Migrations::L10n::Communication::Website::Blog::Author < Migrations::L10n::Base
  def self.execute
    puts Communication::Website::Post.model_name.human(count: 2)
    puts "Authors"
    Communication::Website::Post.where(self.constraint).find_each do |post|
      puts "#{post.id}"
      if post.author && post.author.original_id.present?
        puts "Fixing author (#{post.author.id} > #{post.author.original_id})"
        post.update_column :author_id, post.author.original_id
      end
    end
  end
end