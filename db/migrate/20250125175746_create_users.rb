class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :location
      t.string :mobile
      t.string :email
      t.string :profession
      t.integer :age
      t.string :sex
      t.decimal :height
      t.decimal :weight
      t.references :package, null: false, foreign_key: true

      t.timestamps
    end
  end
end
