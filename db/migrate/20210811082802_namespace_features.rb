class NamespaceFeatures < ActiveRecord::Migration[6.1]
  def change
    rename_table :programs, :features_education_programs
    rename_table :qualiopi_indicators, :features_education_qualiopi_indicators
    rename_table :qualiopi_criterions, :features_education_qualiopi_criterions
  end
end
