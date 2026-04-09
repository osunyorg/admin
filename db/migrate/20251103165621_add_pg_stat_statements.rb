class AddPgStatStatements < ActiveRecord::Migration[8.0]
  def change
    enable_extension 'pg_stat_statements' unless extension_enabled?('pg_stat_statements')
  end
end
