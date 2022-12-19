class SetRequiredDefaultLanguageToCommunicationWebsites < ActiveRecord::Migration[7.0]
  def change
    change_column_null :communication_websites, :default_language_id, false
  end
end
