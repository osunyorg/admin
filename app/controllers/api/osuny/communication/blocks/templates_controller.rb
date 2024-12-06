class Api::Osuny::Communication::Blocks::TemplatesController < Api::Osuny::ApplicationController
  def index
    if params[:category]
      @templates = Communication::Block::CATEGORIES[params[:category].to_sym] || []
    else
      @templates = Communication::Block.template_kinds.keys
    end
  end

  def show
    @template_kind = params[:id]
    raise_404_unless Communication::Block.template_kinds.keys.include?(@template_kind)
    @template_class = "Communication::Block::Template::#{@template_kind.classify}".constantize
    @element_class = @template_class.element_class
  end
end
