module Admin::Reorderable
  extend ActiveSupport::Concern

  def reorder
    ids = params[:ids] || []
    ids.each.with_index do |id, index|
      object = model.find_by(id: id)
      object.update(:position, index + 1) unless object.nil?
    end
    # Used to add extra code
    yield first_object if block_given?
  end

  protected

  def model
    self.class.to_s.remove('Admin::').remove('Controller').singularize.safe_constantize
  end
end
