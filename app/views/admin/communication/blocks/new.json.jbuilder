json.about_type @block.about_type
json.about_id @block.about_id
json.create_url admin_communication_blocks_path
json.button_label t('admin.communication.blocks.choose.button')

categories = Communication::Block::CATEGORIES.map do |category_key, kinds|
  templates = kinds.filter_map do |kind|
    @block.template_reset!
    @block.template_kind = kind
    next unless @block.template.allowed_for_about?
    {
      kind: kind,
      name: @block.template_name.to_s,
      description: t("admin.communication.blocks.templates.#{kind}.description"),
      thumbnail_url: image_url("communication/blocks/templates/#{kind}.jpg")
    }
  end
  next if templates.empty?
  {
    key: category_key,
    label: t("admin.communication.blocks.categories.#{category_key}.label"),
    description: t("admin.communication.blocks.categories.#{category_key}.description"),
    templates: templates
  }
end.compact

json.categories categories
