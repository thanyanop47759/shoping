class CreateUserLogs < ActiveRecord::Migration[7.2]
  def change
    create_table :user_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.string :action
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
