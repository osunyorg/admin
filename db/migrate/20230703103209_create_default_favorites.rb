class CreateDefaultFavorites < ActiveRecord::Migration[7.0]
  def up
    User.not_visitor.not_contributor.not_author.not_teacher.not_program_manager.each do |user|
      return if user.favorites.any?
      return if user.university.websites.many?
      user.favorites.create(about: user.university.websites.first)
    end
  end
end
