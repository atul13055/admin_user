class CreatePricings < ActiveRecord::Migration[7.1]
  def change
    create_table :pricings do |t|
      t.references :package, null: false, foreign_key: true
      t.string :country
      t.decimal :price

      t.timestamps
    end
  end
end
