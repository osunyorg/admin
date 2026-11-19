class RenameSearchIndexToUniversitySearchResults < ActiveRecord::Migration[8.1]
  def change
    rename_table :search_index, :university_search_results
  end
end
