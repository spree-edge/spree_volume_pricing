module Spree
  module Admin
    class VolumePriceModelsController < ResourceController
      before_action :find_or_initialize, only: [:new, :edit]
      before_action :load_volume_prices, only: [:new, :edit]
      respond_to :json, only: [:get_children]

      def index
        @volume_price_models = current_store.volume_price_models
      end

      def get_children
        @volume_prices = ::Spree::VolumePrice.find(params[:parent_id]).children
      end

      private

      def location_after_save
        if @volume_price_model.created_at == @volume_price_model.updated_at
          edit_admin_volume_price_model_url(@volume_price_model)
        else
          admin_volume_price_models_url
        end
      end

      def load_volume_prices
        @volume_price_model.volume_prices.build if @volume_price_model.volume_prices.empty?
      end

      def find_or_initialize
        @object = ::Spree::VolumePriceModel.find_or_initialize_by(store_id: current_store.try(:id))
      end
    end
  end
end
