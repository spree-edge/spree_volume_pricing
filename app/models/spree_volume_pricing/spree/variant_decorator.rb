module SpreeVolumePricing
  module Spree
    module VariantDecorator
      def self.prepended(base)
        base.has_and_belongs_to_many :volume_price_models
        base.has_many :volume_prices, -> { order(position: :asc) }, dependent: :destroy
        base.has_many :model_volume_prices, -> { order(position: :asc) }, class_name: '::Spree::VolumePrice', through: :volume_price_models, source: :volume_prices
        base.accepts_nested_attributes_for :volume_prices, allow_destroy: true,
          reject_if: proc { |volume_price| volume_price[:amount].blank? && volume_price[:range].blank? }
      end

      def join_volume_prices(user = nil, order = nil)
        pricing_tier_id = find_wholesaler_pricing_tier_option(order)
        self.volume_prices.tier(pricing_tier_id, order&.store_id)
      end

      def volume_price(quantity, user = nil, order)
        compute_volume_price_based_on_quantity(:volume_price, price, quantity, user, order)
      end

      def volume_price_earning_percent(quantity, user = nil)
        compute_volume_price_based_on_quantity(:volume_price_earning_percent, 0, quantity, user)
      end

      def volume_price_earning_amount(quantity, user = nil)
        compute_volume_price_based_on_quantity(:volume_price_earning_amount, 0, quantity, user)
      end

      private

      def find_wholesaler_pricing_tier_option(order)
        return nil unless order

        wholesaler_email = if order.user&.wholesaler
                             order.user.email
                           else
                             nil
                           end

        return nil unless wholesaler_email

        wholesaler = ::Spree::Wholesaler.find_by(email: wholesaler_email, status: 'active')
        wholesaler&.pricing_tier_id
      rescue StandardError
        nil
      end

      def use_master_variant_volume_pricing?
        ::SpreeVolumePricing::Config[:use_master_variant_volume_pricing] && product.master.join_volume_prices.exists?
      end

      def compute_volume_price_based_on_quantity(type, default_price, quantity, user = nil, order = nil)
        volume_prices = applicable_volume_prices(user, order)
        volume_prices.each do |volume_price|
          return send("compute_#{type}", volume_price) if volume_price.include?(quantity)
        end

        return product.master.send(type, quantity, user) if use_master_variant_volume_pricing?

        default_price
      end

      def applicable_volume_prices(user = nil, order = nil)
        join_volume_prices(user, order).where(store_id: order&.store_id)
      end

      def compute_volume_price(volume_price)
        case volume_price.discount_type
        when 'price' then volume_price.amount
        when 'dollar' then price - volume_price.amount
        when 'percent' then price * (1 - volume_price.amount)
        end
      end

      def compute_volume_price_earning_percent(volume_price)
        case volume_price.discount_type
        when 'price'   then percent_diff(price, volume_price.amount)
        when 'dollar'  then (volume_price.amount * 100 / price).round
        when 'percent' then (volume_price.amount * 100).round
        end
      end

      def compute_volume_price_earning_amount(volume_price)
        case volume_price.discount_type
        when 'price'   then price - volume_price.amount
        when 'dollar'  then volume_price.amount
        when 'percent' then price - (price * volume_price.amount)
        end
      end

      def percent_diff(original, discounted)
        ((original - discounted) * 100 / original).round
      end
    end
  end
end

::Spree::Variant.prepend SpreeVolumePricing::Spree::VariantDecorator
