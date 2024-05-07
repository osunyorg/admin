class Showcase::HomeController < Showcase::ApplicationController
  def index
    @tags = Communication::Website::Showcase::Tag.all.ordered
    @websites = Communication::Website.in_showcase
                                      .page(params[:page]).per(1)
  end

  def tag
    @tag = Communication::Website::Showcase::Tag.find_by(slug: params[:tag])
    @websites = @tag.websites.in_showcase
                             .page(params[:page])
  end
end
