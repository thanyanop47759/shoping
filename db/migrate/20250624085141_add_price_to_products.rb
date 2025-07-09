class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name
      t.integer :quantity
      t.references :user, foreign_key: true
      t.references :category, foreign_key: true
      t.decimal :price, precision: 10, scale: 2   # ต้องมีบรรทัดนี้
      t.timestamps
    end
  end
end
