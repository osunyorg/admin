class RemoveDefaultPositionFromSomeModels < ActiveRecord::Migration[8.0]
  def change
    change_column_default :communication_blocks, :position, from: 0, to: nil
    change_column_default :communication_media_categories, :position, from: 0, to: nil
    change_column_default :communication_website_pages, :position, from: 0, to: nil
    change_column_default :education_diplomas, :position, from: 0, to: nil
    change_column_default :university_organization_categories, :position, from: 0, to: nil
    change_column_default :university_person_categories, :position, from: 0, to: nil
  end
end
