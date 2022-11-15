class AddPrivateApiKeyCiphertextToClients < ActiveRecord::Migration[7.0]
  def change
    add_column :clients, :private_api_key_ciphertext, :text
    # blind index
    add_column :clients, :private_api_key_bidx, :string
    add_index :clients, :private_api_key_bidx, unique: true  
  end
end
