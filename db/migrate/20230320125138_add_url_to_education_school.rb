class AddUrlToEducationSchool < ActiveRecord::Migration[7.0]
  def change
    add_column :education_schools, :url, :string
  end
end
