module Admin::BlocksHelper

  def block_component_edit(property, **options)
    render "admin/communication/blocks/components/edit",
            property: property,
            **options
  end

  def block_component_preview(property, **options)
    render "admin/communication/blocks/components/preview",
            property: property,
            **options
  end

  def block_component_static(property, **options)
    render "admin/communication/blocks/components/static",
            property: property,
            **options
  end
end
