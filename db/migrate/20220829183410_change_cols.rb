class ChangeCols < ActiveRecord::Migration[7.0]
  def change
    rename_column :accounts, :private_api_key_ciphertext, :private_api_key
    remove_column :accounts, :private_api_key_bidx
  end
end
