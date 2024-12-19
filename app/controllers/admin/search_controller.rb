class Admin::SearchController < Admin::ApplicationController
  def index
    @term = params[:term]
    @results = Osuny::Search.new( @term,
                                  current_university, 
                                  current_language,
                                  website: website,
                                  extranet: extranet
                                ).results
    render layout: false
  end

  protected

  def website
    current_university.websites.find(params[:website_id]) if params.has_key?(:website_id)
  end

  def extranet
    current_university.extranets.find(params[:extranet_id]) if params.has_key?(:extranet_id)
  end

  def default_url_options
    options = super
    options[:website_id] = website.id if website
    options[:extranet_id] = extranet.id if extranet
    options
  end
end