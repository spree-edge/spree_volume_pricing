module SpreeVolumePricing
  module Spree
    module StoreDecorator
      def self.prepended(base)
        base.has_many :volume_price_models
        base.has_many :volume_prices
      end
    end
  end
end

::Spree::Store.prepend SpreeVolumePricing::Spree::StoreDecorator
