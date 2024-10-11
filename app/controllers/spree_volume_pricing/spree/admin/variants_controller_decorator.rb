module SpreeVolumePricing
  module Spree
    module Admin
      module VariantsControllerDecorator
        def edit
          @variant.volume_prices.build(store_id: current_store.id) if @variant.volume_prices.where(store_id: current_store.id)

          super
        end

        def volume_prices
          @product = @variant.product
          @variant.volume_prices.build(store_id: current_store.id) if @variant.volume_prices.where(store_id: current_store.id)
        end

        private

        # this loads the variant for the master variant volume price editing
        def load_resource_instance
          parent

          if new_actions.include?(params[:action].to_sym)
            build_resource
          elsif params[:id]
            ::Spree::Variant.find(params[:id])
          end
        end

        def location_after_save
          if @product.master.id == @variant.id && params[:variant].key?(:volume_prices_attributes)
            return volume_prices_admin_product_variant_url(@product, @variant)
          end
          super
        end
      end
    end
  end
end

::Spree::Admin::VariantsController.prepend SpreeVolumePricing::Spree::Admin::VariantsControllerDecorator
