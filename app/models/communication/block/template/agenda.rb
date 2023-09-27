class Communication::Block::Template::Agenda < Communication::Block::Template::Base

  has_layouts [:grid, :list]

  has_component :description, :rich_text
  has_component :events_quantity, :number, options: 3

  def selected_events
    @selected_events ||= block.about&.website
                                    .events
                                    .for_language(block.language)
                                    .published
                                    .ordered
                                    .limit(events_quantity)
  end

  def allowed_for_about?
    website.present?
  end

end
