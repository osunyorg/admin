class AddFeaturesToUniversity < ActiveRecord::Migration[7.0]
  def change
    add_column :universities, :feature_education, :boolean, default: true
    add_column :universities, :feature_research, :boolean, default: true
    add_column :universities, :feature_communication, :boolean, default: true
    add_column :universities, :feature_administration, :boolean, default: true
  end
end
