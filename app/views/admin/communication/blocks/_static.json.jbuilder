json.kind 'block'
json.position block.position
json.template block.template_kind
json.data do
  json.partial! "admin/communication/blocks/templates/#{block.template_kind}/static", block: block
end