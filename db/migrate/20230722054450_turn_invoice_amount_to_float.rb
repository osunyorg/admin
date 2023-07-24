class TurnInvoiceAmountToFloat < ActiveRecord::Migration[7.0]
  def up
    add_column :universities, :contribution_amount, :float
    University.reset_column_information
    University.find_each do |university|
      university.update_column :contribution_amount, university.invoice_amount.to_f
    end
    remove_column :universities, :invoice_amount
  end

  def down
    remove_column :universities, :contribution_amount, :float
    add_column :universities, :invoice_amount, :string
  end
end
