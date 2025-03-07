class AddExpirationDateToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :expiration_date, :date
  end
end
