class RemoveSmsSenderNameFromUniversities < ActiveRecord::Migration[8.1]
  def change
    remove_column :universities, :sms_sender_name, :string
  end
end
