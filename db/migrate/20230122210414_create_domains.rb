class CreateDomains < ActiveRecord::Migration[7.0]
  def change
    create_table :domains do |t|
      t.string :name
      t.datetime :expires_on
      t.datetime :billed_on
      t.text :notes
      t.boolean "web_hosting", null: false, default: false
      t.monetize :hosting_fee
      t.boolean "email_hosting", null: false, default: false
      t.boolean "registration", null: false, default: false
      t.monetize :registration_fee
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
