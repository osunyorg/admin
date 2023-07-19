class AddRealUniversityToUniversity < ActiveRecord::Migration[7.0]
  def change
    add_column :universities, :is_really_a_university, :boolean, default: true
    remove_column :universities, :feature_education, :boolean, default: true
    remove_column :universities, :feature_research, :boolean, default: true
    remove_column :universities, :feature_communication, :boolean, default: true
    remove_column :universities, :feature_administration, :boolean, default: true
  end
end
