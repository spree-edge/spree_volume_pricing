module SpreeVolumePricing
  class Configuration < Spree::Preferences::Configuration
    preference :use_master_variant_volume_pricing, :boolean, default: false
    preference :volume_pricing_role, :string, default: 'wholesale'
    preference :volume_pricing_role_dropship, :string, default: 'dropship'
  end
end
