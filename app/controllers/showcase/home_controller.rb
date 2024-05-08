class Showcase::HomeController < Showcase::ApplicationController
  def index
    @tags = Communication::Website::Showcase::Tag.all.ordered
    @features = [
      { 
        name: Communication::Website::Post.model_name.human(count: 2),
        path: '/actualites',
        websites: Communication::Website.in_showcase.with_feature_posts
      },
      { 
        name: Communication::Website::Agenda.model_name.human(count: 2),
        path: '/agenda',
        websites: Communication::Website.in_showcase.with_feature_agenda
      },
      { 
        name: Communication::Website::Portfolio.model_name.human(count: 2),
        path: '/portfolio',
        websites: Communication::Website.in_showcase.with_feature_portfolio
      }
    ]
    @websites = Communication::Website.in_showcase
                                      .page(params[:page]).per(1)
  end

  def tag
    @tag = Communication::Website::Showcase::Tag.find_by(slug: params[:tag])
    @websites = @tag.websites.in_showcase
                             .page(params[:page])
  end

  def feature
    @feature = params[:feature]
    @websites = Communication::Website.in_showcase
    case @feature
    when 'actualites'
      @title = Communication::Website::Post.model_name.human(count: 2)
      @websites = @websites.with_feature_posts
    when 'agenda'
      @title = Communication::Website::Agenda.model_name.human(count: 2)
      @websites = @websites.with_feature_agenda
    when 'portfolio'
      @title = Communication::Website::Portfolio.model_name.human(count: 2)
      @websites = @websites.with_feature_portfolio
    end
    @websites =  @websites.page(params[:page])
  end
end
