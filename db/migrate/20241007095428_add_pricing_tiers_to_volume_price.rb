class AddPricingTiersToVolumePrice < ActiveRecord::Migration[7.1]
  def change
    add_reference :spree_volume_prices, :pricing_tier, null: true, foreign_key: { to_table: :spree_pricing_tiers }
  end
end
