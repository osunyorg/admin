json.blocks @blocks do |block|
  json.id block.id
  json.template do 
    json.kind block.template_kind
    json.name block.template_name.to_s
  end
  json.published block.published
  json.url do 
    json.edit edit_admin_communication_block_path(block, website_id: nil, extranet_id: nil)
    json.delete admin_communication_block_path(block, website_id: nil, extranet_id: nil)
    json.duplicate duplicate_admin_communication_block_path(block, website_id: nil, extranet_id: nil)
    json.copy copy_admin_communication_block_path(block, website_id: nil, extranet_id: nil)
  end
  json.snippet  render(
                  partial: 'admin/communication/blocks/block/snippet',
                  locals: { block: block },
                  formats: [:html]
                )
 json.a11y do
    json.status render(
                  partial: 'admin/application/a11y/status',
                  locals: { about: block },
                  formats: [:html]
                )
 end
end