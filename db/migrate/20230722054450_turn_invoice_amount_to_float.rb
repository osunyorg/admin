class TurnInvoiceAmountToFloat < ActiveRecord::Migration[7.0]
  def change
    add_column :universities, :contribution_amount, :float
    University.find_each do |university|
      university.update_column :contribution_amount, university.invoice_amount.to_f
    end
    remove_column :universities, :invoice_amount
  end
end
