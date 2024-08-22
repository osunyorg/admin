class ReconnectToOriginals < ActiveRecord::Migration[7.1]
  def up
    puts Communication::Website::Post.model_name.human(count: 2)
    puts "Authors"
    Communication::Website::Post.find_each do |post|
      puts "#{post.id}"
      if post.author && post.author.original_id.present?
        puts "Fixing author (#{post.author.id} > #{post.author.original_id})"
        post.update_column :author_id, post.author.original_id
      end
    end
    migrate_categories Communication::Website::Post
    migrate_categories Communication::Website::Agenda::Event
    migrate_categories Communication::Website::Portfolio::Project
  end

  def migrate_categories(model)
    puts
    puts model.model_name.human(count: 2)
    puts "Categories"
    model.find_each do |object|
      puts "#{object.id}"
      if object.categories.any?
        object.categories.each do |category|
          if category.original_id.present?
            puts "Fixing category (#{category.id} > #{category.original_id})"
            object.categories.delete(category)
            object.categories << category.original
         end
        end
      end
    end
  end

  def down
  end
end
