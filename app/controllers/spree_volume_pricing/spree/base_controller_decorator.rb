module SpreeVolumePricing
  module Spree
    module BaseControllerDecorator
      def self.prepended(base)
        base.include ::SpreeVolumePricing::BaseHelper
        base.helper_method [
          :display_volume_price,
          :display_volume_price_earning_percent,
          :display_volume_price_earning_amount
        ]
      end
    end
  end
end

::Spree::BaseController.prepend SpreeVolumePricing::Spree::BaseControllerDecorator
