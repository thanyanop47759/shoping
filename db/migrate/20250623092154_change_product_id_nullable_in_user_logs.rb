class ChangeProductIdNullableInUserLogs < ActiveRecord::Migration[7.2]
  def change
    change_column_null :user_logs, :product_id, true
  end
end
