class RefactorFeatures < ActiveRecord::Migration[6.1]
  def change
    rename_table :features_websites_sites, :communication_websites
    rename_table :features_education_programs, :education_programs
    rename_table :features_education_qualiopi_criterions, :administration_qualiopi_criterions
    rename_table :features_education_qualiopi_indicators, :administration_qualiopi_indicators
  end
end
