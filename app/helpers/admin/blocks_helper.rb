module Admin::BlocksHelper

  def block_component_edit(property, **options)
    block_component_render :edit, property, **options
  end

  def block_component_preview(property, **options)
    block_component_render :preview, property, **options
  end

  def block_component_static(property, **options)
    render "admin/communication/blocks/components/static",
            property: property,
            **options
  end

  protected

  def block_component_render(view, property, **options)
    template = options.has_key?(:template)  ? options[:template]
                                            : @block.template
    component = template.public_send "#{property}_component"
    partial = "admin/communication/blocks/components/#{component.kind}/#{view}"
    render partial, property: property, template: template, **options
  end
end
