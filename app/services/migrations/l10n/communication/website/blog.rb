class Migrations::L10n::Communication::Website::Blog < Migrations::L10n::Base
  def self.execute
    Post.execute
    Category.execute
    Author.execute
    reconnect_objects_to_categories Communication::Website::Post
  end
end