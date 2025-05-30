class AddOptinNewsletterToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :optin_newsletter, :boolean
  end
end
