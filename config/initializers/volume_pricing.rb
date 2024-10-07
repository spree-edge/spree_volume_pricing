Rails.application.config.after_initialize do
  if Spree::Core::Engine.backend_available?
    Rails.application.config.spree_backend.tabs[:product].add(
      ::Spree::Admin::Tabs::TabBuilder.new(::Spree.t(:volume_pricing), ->(resource) { ::Spree::Core::Engine.routes.url_helpers.volume_prices_admin_product_variant_path(resource, resource.master) }).
        with_icon_key('tasks').
        with_manage_ability_check(::Spree::VolumePrice).
        with_active_check.
        build
    )

     Rails.application.config.spree_backend.main_menu.add_to_section('settings',
      ::Spree::Admin::MainMenu::ItemBuilder.new('volume_price_models', ::Spree::Core::Engine.routes.url_helpers.admin_volume_price_models_path).
        with_manage_ability_check(::Spree::VolumePriceModel).
        with_match_path('/volume_price_models').
        build
      )
  end
end
