class Communication::Block::Template::Agenda < Communication::Block::Template::Base

  has_layouts [:grid, :list]

  has_component :description, :rich_text
  has_component :quantity, :number, options: 3
  has_component :time, :option, options: [:future_or_present, :future, :present, :archive]

  def selected_events
    @selected_events ||= block.about&.website
                                    .events
                                    .for_language(block.language)
                                    .published
                                    .send(time)
                                    .limit(quantity)
  end

  def allowed_for_about?
    website.present?
  end

end
