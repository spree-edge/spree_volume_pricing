module SpreeVolumePricing
  module Spree
    module OrderDecorator
      def self.prepended(base)
        base.state_machine.after_transition to: [:payment], do: :update_line_items_copy_price
      end

      # call copy_price for all line items and update order totals
      def update_line_items_copy_price
        line_items.each do |li|
          li.copy_price
          li.save!
        end

        update_totals
        persist_totals 
      end
    end
  end
end

::Spree::Order.prepend(SpreeVolumePricing::Spree::OrderDecorator)
