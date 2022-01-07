class RenameCoverToFeaturedImageForVolumes < ActiveRecord::Migration[6.1]
  def change
    rename_column :research_journal_volumes, :cover_alt, :featured_image_alt
  end
end
