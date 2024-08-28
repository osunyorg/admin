class Migrations::L10n::Communication::Website::Portfolio < Migrations::L10n::Base
  def self.execute
    Project.execute
    Category.execute
    reconnect_objects_to_categories Communication::Website::Portfolio::Project
  end
end