class CreateUnifiSites < ActiveRecord::Migration[7.0]
  def change
    create_table :unifi_sites do |t|
      t.string :name
      t.monetize :hosting_fee
      t.datetime :billed_on
      t.text :notes

      t.references :account, null: false, foreign_key: true
      t.timestamps
    end
  end
end
