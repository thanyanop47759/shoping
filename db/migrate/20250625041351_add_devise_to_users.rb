class AddDeviseToUsers < ActiveRecord::Migration[7.2]
  def change
    change_table :users do |t|
      ## Database authenticatable
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false
      # t.string   :unlock_token
      # t.datetime :locked_at
    end

    add_index :users, :reset_password_token, unique: true
    # add_index :users, :confirmation_token, unique: true
  end
end
