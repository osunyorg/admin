class AddInvoiceElementsToUniversity < ActiveRecord::Migration[6.1]
  def change
    add_column :universities, :invoice_date, :date
    add_column :universities, :invoice_date_yday, :integer
    add_column :universities, :invoice_amount, :string
  end
end
