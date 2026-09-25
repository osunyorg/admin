class AddFeaturedImageAttributesToCommunicationWebsiteFileLocalizations < ActiveRecord::Migration[8.1]
  def change
    add_column :communication_file_localizations, :featured_image_alt, :string
    add_column :communication_file_localizations, :featured_image_credit, :text
  end
end
