module Admin::BlocksHelper

  def block_component_edit(block, property, **options)
    render 'admin/communication/blocks/components/edit',
            block: block,
            property: property,
            **options
  end

  def block_component_snippet(block, property, **options)
    render 'admin/communication/blocks/components/snippet',
            block: block,
            property: property,
            **options
  end

  def block_component_show(block, property, **options)
    render 'admin/communication/blocks/components/show',
            block: block,
            property: property,
            **options
  end

  def block_component_static(block, property, **options)
    render 'admin/communication/blocks/components/static',
            block: block,
            property: property,
            **options
  end

  def block_component_add_element(block, label)
    render 'admin/communication/blocks/components/add_element/edit',
            block: block,
            label: label
  end
end
