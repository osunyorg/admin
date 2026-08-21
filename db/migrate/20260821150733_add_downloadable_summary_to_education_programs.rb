class AddDownloadableSummaryToEducationPrograms < ActiveRecord::Migration[8.1]
  def change
    add_reference :education_programs,
                  :downloadable_summary,
                  type: :uuid,
                  foreign_key: {
                    to_table: :communication_files,
                    on_delete: :nullify
                  }
  end
end
