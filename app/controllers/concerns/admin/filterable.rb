module Admin::Filterable
  extend ActiveSupport::Concern

  included do
    before_action :load_filters, only: :index
  end

  protected

  def load_filters
    @filters = []
    filter_class_name = "::Filters::#{self.class.to_s.gsub('Controller', '')}"
    # filter_class will be nil if filter does not exist
    filter_class = filter_class_name.safe_constantize
    @filters = filter_class.new(current_user).list unless filter_class.nil?
  end

end
