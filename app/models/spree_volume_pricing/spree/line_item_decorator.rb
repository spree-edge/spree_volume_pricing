module SpreeVolumePricing
  module Spree
    module LineItemDecorator
      def copy_price
        return unless variant

        update_price
        self.cost_price ||= variant.cost_price
        self.currency ||= variant.currency
      end

      def update_price
        vprice = variant.volume_price(quantity, order.user, order)

        return self.price = vprice if price.present? && vprice <= variant.price

        super
      end
    end
  end
end

::Spree::LineItem.prepend SpreeVolumePricing::Spree::LineItemDecorator
