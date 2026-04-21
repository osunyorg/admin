json.blocks @blocks do |block|
  json.id block.id
  json.template block.template_name.to_s
  json.published block.published
#  json.snippet (render 'admin/communication/blocks/block/snippet', block: block, format: :html)
end