class Showcase::WebsitesController < Showcase::ApplicationController
  def index
    @tags = Communication::Website::Showcase::Tag.all.ordered
    @features = Communication::Website::Showcase.features
    @websites = Communication::Website.in_showcase
                                      .page(params[:page])
  end

  def show
    @website = Communication::Website.find(params[:id])
    raise_404_unless(@website.in_showcase && @website.in_production)
  end

  def tag
    @tag = Communication::Website::Showcase::Tag.find_by!(slug: params[:tag])
    @websites = @tag.websites.in_showcase
                             .page(params[:page])
  end

  def feature
    feature = params[:feature].to_sym
    @title = Communication::Website::Showcase.title_for_feature(feature)
    @websites = Communication::Website::Showcase.websites_for_feature(feature)
                                                .in_showcase
                                                .page(params[:page])
  end
end
