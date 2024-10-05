module Spree
  module Admin
    class VolumePricesController < Spree::Admin::BaseController
      def destroy
        @volume_price = current_store.volume_prices.find(params[:id])
        @volume_price.destroy
        # render nothing: true
      end
    end
  end
end