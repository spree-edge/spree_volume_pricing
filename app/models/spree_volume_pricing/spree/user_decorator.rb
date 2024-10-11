module SpreeVolumePricing
  module Spree
    module UserDecorator
      def resolve_role
        role_name = if has_spree_role?(::SpreeVolumePricing::Config[:volume_pricing_role].to_sym)
                      ::SpreeVolumePricing::Config[:volume_pricing_role]
                    elsif has_spree_role?(::SpreeVolumePricing::Config[:volume_pricing_role_dropship].to_sym)
                      ::SpreeVolumePricing::Config[:volume_pricing_role_dropship]
                    else
                      'user'
                    end

        ::Spree::Role.find_by(name: role_name)
      end
    end
  end
end

Spree.user_class.prepend SpreeVolumePricing::Spree::UserDecorator
