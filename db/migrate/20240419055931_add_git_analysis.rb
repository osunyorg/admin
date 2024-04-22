class AddGitAnalysis < ActiveRecord::Migration[7.1]
  def change
    create_table :communication_website_git_file_orphans, id: :uuid do |t|
      t.string :path
      t.references :communication_website, null: false, foreign_key: true, type: :uuid
      t.references :university, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end

    create_table :communication_website_git_file_layouts, id: :uuid do |t|
      t.string :path
      t.references :communication_website, null: false, foreign_key: true, type: :uuid
      t.references :university, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end

    add_column :communication_websites, :git_files_analysed_at, :datetime
  end
end
