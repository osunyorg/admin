class AddSummernoteLocaleInLanguages < ActiveRecord::Migration[7.0]
  def change
    add_column :languages, :summernote_locale, :string
  end
end
