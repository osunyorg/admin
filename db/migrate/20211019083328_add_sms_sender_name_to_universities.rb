class AddSmsSenderNameToUniversities < ActiveRecord::Migration[6.1]
  def change
    add_column :universities, :sms_sender_name, :string
  end
end
