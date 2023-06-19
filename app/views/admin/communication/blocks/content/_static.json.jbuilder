# TODO est-ce utile ? Voir avec Alex en fonction de Vue
json.contents about.content do |block_or_heading|
  if block_or_heading.is_a? Communication::Block
    json.partial! 'admin/communication/blocks/static', block: block_or_heading
  else
  end
end