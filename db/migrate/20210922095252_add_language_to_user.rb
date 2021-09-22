class AddLanguageToUser < ActiveRecord::Migration[6.1]
  def change
    add_reference :users, :language, foreign_key: true, type: :uuid
  end
end
