class AddPricingFieldsToEducationPrograms < ActiveRecord::Migration[7.1]
  def change
    add_column :education_programs, :pricing_continuing, :text
    add_column :education_programs, :pricing_apprenticeship, :text
    add_column :education_programs, :pricing_initial, :text
  end
end
