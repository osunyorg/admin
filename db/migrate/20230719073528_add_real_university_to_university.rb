class AddRealUniversityToUniversity < ActiveRecord::Migration[7.0]
  def change
    add_column :universities, :is_really_a_university, :boolean, default: true
    remove_column :universities, :feature_education
    remove_column :universities, :feature_research
    remove_column :universities, :feature_communication
    remove_column :universities, :feature_administration
  end
end
