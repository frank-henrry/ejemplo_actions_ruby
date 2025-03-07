class AddCategoriaToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :categoria, :string
  end
end
