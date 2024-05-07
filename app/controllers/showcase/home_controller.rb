class Showcase::HomeController < Showcase::ApplicationController
  def index
    @websites = Communication::Website.in_showcase
                                      .ordered_for_showcase
    @tags = Communication::Website::Showcase::Tag.all.ordered
  end

  def tag
    @tag = Communication::Website::Showcase::Tag.find_by(slug: params[:tag])
    @websites = @tag.websites.in_showcase
                             .ordered_for_showcase
  end
end
