class Communication::Block::Template::Category < Communication::Block::Template::Base

  has_elements
  has_layouts [
    :grid,
    :list,
    :cards,
    :alternate,
    :large
  ]
  has_component :category_kind, :option, options: (
    Communication::Block::CATEGORIES[:references] - [:categories]
  )

  has_component :option_count,        :boolean, default: true
  has_component :option_image,        :boolean, default: true
  has_component :option_summary,      :boolean, default: true
end