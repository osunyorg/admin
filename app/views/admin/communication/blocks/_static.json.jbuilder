json.content about.content do |block_or_heading|
  if block_or_heading.is_a? Communication::Block
    json.partial! 'admin/communication/blocks/block_static', block: block_or_heading
  else
  end
end