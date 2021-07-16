class FixUuids < ActiveRecord::Migration[6.1]
  def up
    add_column :users, :uuid, :uuid, default: "gen_random_uuid()", null: false
    rename_column :users, :id, :integer_id
    rename_column :users, :uuid, :id
    execute "ALTER TABLE users drop constraint users_pkey;"
    execute "ALTER TABLE users ADD PRIMARY KEY (id);"
    execute "ALTER TABLE ONLY users ALTER COLUMN integer_id DROP DEFAULT;"
    change_column_null :users, :integer_id, true
    execute "DROP SEQUENCE IF EXISTS users_id_seq"

    add_column :universities, :uuid, :uuid, default: "gen_random_uuid()", null: false
    rename_column :universities, :id, :integer_id
    rename_column :universities, :uuid, :id
    execute "ALTER TABLE universities drop constraint universities_pkey;"
    execute "ALTER TABLE universities ADD PRIMARY KEY (id);"
    execute "ALTER TABLE ONLY universities ALTER COLUMN integer_id DROP DEFAULT;"
    change_column_null :universities, :integer_id, true
    execute "DROP SEQUENCE IF EXISTS universities_id_seq"
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
