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

  def block_options_static(block)
    render 'admin/communication/blocks/partials/options',
            block: block
  end

  def block_html_class(block)
    html_class = "block block-#{block.template_kind}"
    html_class += " block-#{block.template_kind}--#{block.template.layout}" if block.template.respond_to?(:layout)
    html_class += " block-titled" if block.title.present?
    html_class
  end
end
