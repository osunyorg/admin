class AddKeysToUniversityApps < ActiveRecord::Migration[7.0]
  def change
    add_column :university_apps, :access_key, :string
    rename_column :university_apps, :token, :secret_key
  end
end
