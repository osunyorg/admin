class RemoveTextFromPostLocalizations < ActiveRecord::Migration[8.0]
  def change
    remove_column :communication_website_post_localizations, :text
  end
end
