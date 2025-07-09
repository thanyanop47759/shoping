class AddFieldsToCoupons < ActiveRecord::Migration[7.2]
  def change
    add_column :coupons, :discount_type, :string, default: "fixed"
    add_column :coupons, :expires_at, :datetime
    add_column :coupons, :used, :boolean, default: false
  end
end
