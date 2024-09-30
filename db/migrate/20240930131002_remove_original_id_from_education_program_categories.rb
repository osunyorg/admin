class RemoveOriginalIdFromEducationProgramCategories < ActiveRecord::Migration[7.1]
  def change
    remove_column :education_program_categories, :original_id
  end
end
