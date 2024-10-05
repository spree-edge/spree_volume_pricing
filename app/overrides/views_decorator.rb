Deface::Override.new(
  virtual_path: 'spree/admin/variants/edit',
  name: 'add_volume_pricing_field_to_variant',
  insert_after: '[data-hook="admin_variant_edit_form"]',
  partial: 'spree/admin/variants/edit_fields',
  original: 'a675cff6d6f5661221fd47b90bfd2db140c4ff2d'
)
