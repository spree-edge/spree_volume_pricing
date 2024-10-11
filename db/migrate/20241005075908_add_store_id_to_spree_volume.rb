class AddStoreIdToSpreeVolume < ActiveRecord::Migration[7.1]
  def change
    add_reference :spree_volume_price_models, :store, foreign_key: { to_table: :spree_stores }
    add_reference :spree_volume_prices, :store, foreign_key: { to_table: :spree_stores }
  end
end
