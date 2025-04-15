class CreateStarSystems < ActiveRecord::Migration[7.1]
  def change
    create_table :star_systems do |t|
      t.string :name, null: false
      t.string :status, default: "undiscovered"
      t.string :system_type, null: false, default: 'terrestrial'
      t.integer :max_population, null: false, default: 1000
      t.integer :max_buildings, null: false, default: 10
      t.integer :current_population, null: false, default: 0
      t.integer :loyalty, null: false, default: 100
      t.references :empire, foreign_key: true, null: true
      t.references :previous_owner, foreign_key: { to_table: :empires }, null: true

      t.timestamps
    end

    add_index :star_systems, :name
    add_index :star_systems, :status
    add_index :star_systems, :system_type
  end
end
