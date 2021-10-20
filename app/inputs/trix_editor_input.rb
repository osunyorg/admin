# I was using https://github.com/maclover7/trix to do:
#
# f.input :my_input, as: :trix_editor
#
# Its currently been over two weeks since Rails 5.2 was released, and the
# gem was the only thing preventing me from using it in multiple projects:
# https://github.com/maclover7/trix/pull/61#issuecomment-384312659
#
# So I made this custom simpleform input for my apps to prevent this from happening again in the future.
#
# For more info on SimpleForm custom form inputs, see:
# https://github.com/plataformatec/simple_form/wiki/Adding-custom-input-components
#

class TrixEditorInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    template.concat @builder.text_field(attribute_name, input_html_options)
    template.content_tag(:"trix-editor", nil, input: id)
  end

  def input_html_options
    super.merge({
      type: :hidden,
      id: id,
      name: name
    })
  end

  def id
    "#{object_name}_#{attribute_name}"
  end

  def name
    "#{object_name}[#{attribute_name}]"
  end

  private

  def object_name
    @builder.object.class.to_s.downcase.gsub('::', '_')
  end
end
