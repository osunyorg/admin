class RemoveUnneededIndexes < ActiveRecord::Migration[8.0]
  def change
    remove_index :communication_blocks, name: "index_communication_blocks_on_university_id", column: :university_id
    remove_index :communication_website_git_files, name: "index_communication_website_git_files_on_website_id", column: :website_id
  end
end
