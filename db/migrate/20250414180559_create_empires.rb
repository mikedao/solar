class CreateEmpires < ActiveRecord::Migration[7.1]
  def change
    create_table :empires do |t|
      t.string :name
      t.references :user, null: false, foreign_key: true
      t.integer :credits
      t.integer :minerals
      t.integer :energy
      t.integer :food
      t.integer :population

      t.timestamps
    end
  end
end
