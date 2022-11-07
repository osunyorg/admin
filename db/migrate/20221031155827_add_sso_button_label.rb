class AddSsoButtonLabel < ActiveRecord::Migration[6.1]
  def change
    add_column :universities, :sso_button_label, :string
    add_column :communication_extranets, :sso_button_label, :string
  end
end
