class CreateDefaultFavorites < ActiveRecord::Migration[7.0]
  def up
    User.not_visitor.not_contributor.not_author.not_teacher.not_program_manager.each do |user|
      next if user.favorites.any?
      if user.website_manager?
        user.websites_to_manage.each do |website|
          user.favorites.create(about: website)
        end
      elsif user.university.websites.count < 5
        user.university.websites.each do |website|
          user.favorites.create(about: website)
        end
      end
    end

  end
end
