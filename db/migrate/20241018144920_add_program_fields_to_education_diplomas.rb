class AddProgramFieldsToEducationDiplomas < ActiveRecord::Migration[7.1]
  def change
    add_column :education_diploma_localizations, :pedagogy, :text
    add_column :education_diploma_localizations, :evaluation, :text
    add_column :education_diploma_localizations, :registration, :text
    add_column :education_diploma_localizations, :prerequisites, :text
    add_column :education_diploma_localizations, :other, :text
    add_column :education_diploma_localizations, :pricing, :text
    add_column :education_diploma_localizations, :pricing_initial, :text
    add_column :education_diploma_localizations, :pricing_continuing, :text
    add_column :education_diploma_localizations, :pricing_apprenticeship, :text
    add_column :education_diploma_localizations, :accessibility, :text
    add_column :education_diploma_localizations, :contacts, :text
  end
end
