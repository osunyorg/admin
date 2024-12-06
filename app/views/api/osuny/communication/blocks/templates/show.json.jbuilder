json.slug @template_kind
json.components @template_class.components_descriptions do |component|
  json.extract! component, :property, :kind
  json.extract! component, :options unless component[:options].nil?
  json.extract! component, :default unless component[:default].nil?
end
json.element do
  json.components @element_class.components_descriptions do |component|
    json.extract! component, :property, :kind
    json.extract! component, :options unless component[:options].nil?
    json.extract! component, :default unless component[:default].nil?
  end
end if @element_class.present?