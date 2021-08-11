class AddGlossaryToFeaturesEducationQualiopiIndicator < ActiveRecord::Migration[6.1]
  def change
    add_column :features_education_qualiopi_indicators, :glossary, :text
  end
end
