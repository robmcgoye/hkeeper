class Clients < ActiveRecord::Migration[7.0]
  def change
    create_table :clients do |t|
      t.string :name

      t.timestamps
    end

    create_table :computers do |t|
      t.string :name
      t.string :cpu
      t.string :operating_system
      t.string :make
      t.string :model
      t.string :serial_number
      t.string :key
      t.references :client, null: false, foreign_key: true

      t.timestamps
    end

    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest

      t.timestamps
    end
  end
end
