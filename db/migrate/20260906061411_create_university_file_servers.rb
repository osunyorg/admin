class CreateUniversityFileServers < ActiveRecord::Migration[8.1]
  def change
    create_table :university_file_servers, id: :uuid do |t|
      t.string :url
      t.integer :ftp_port
      t.string :ftp_username
      t.string :ftp_password
      t.string :ftp_path
      t.string :ftp_host
      t.belongs_to :university, index: { unique: true }, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
