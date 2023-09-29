json.layout block.template.layout
json.description block.template.description
json.with_link block.template.with_link
json.organizations block.template.elements do |element|
  if element.organization
    json.slug element.organization.slug
  end
end