class Showcase::WebsitesController < Showcase::ApplicationController
  def index
    @tags = Communication::Website::Showcase::Tag.all.ordered
    @features = Communication::Website::Showcase.features
    @websites = Communication::Website.in_showcase
                                      .ordered_by_production_date
    @title = "#{@websites.count } sites créés par #{University.with_websites_in_production.count} organisations"
    respond_to do |format|
      format.html {
        @highlighted_websites = @websites.highlighted_in_showcase
        @websites = @websites.page(params[:page]).per(100)
      }
      format.json {
        @websites = @websites.page(params[:page])
        response.set_header('X-Total-Count', @websites.total_count.to_s)
        response.set_header('X-Total-Pages', @websites.total_pages.to_s)
      }
    end
  end

  def timeline
    @title = 'Historique'
    first_at = Communication::Website.in_production.minimum(:in_production_at)
    monthly = if first_at
      Communication::Website
        .in_production
        .group_by_month(:in_production_at, range: first_at..Time.current)
        .count
    else
      {}
    end
    cumulative = 0
    @websites_progression = monthly.transform_values { |count| cumulative += count }
  end

  def tag
    @tag = Communication::Website::Showcase::Tag.find_by!(slug: params[:tag])
    @websites = @tag.websites.in_showcase
                             .ordered_by_production_date
    @highlighted_websites = @websites.highlighted_in_showcase
    @websites = @websites.page(params[:page]).per(100)
  end

  def feature
    feature = params[:feature].to_sym
    @title = Communication::Website::Showcase.title_for_feature(feature)
    @websites = Communication::Website::Showcase.websites_for_feature(feature)
                                                .ordered_by_production_date
    @highlighted_websites = @websites.highlighted_in_showcase
    @websites = @websites.page(params[:page]).per(100)
  end

  def show
    @website = Communication::Website.find(params[:id])
    raise_404_unless(@website.in_showcase && @website.in_production)
  end
end
