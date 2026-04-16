class AddApacheConfigCustomContentToCommunicationWebsites < ActiveRecord::Migration[8.1]
  def change
    add_column :communication_websites, :apache_config_custom_content, :text
  end
end
