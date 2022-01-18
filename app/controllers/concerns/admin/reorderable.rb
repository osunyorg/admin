module Admin::Reorderable
  extend ActiveSupport::Concern

  def reorder
    ids = params[:ids] || []
    first_object = model.find_by(id: ids.first)
    ids.each.with_index do |id, index|
      object = model.find_by(id: id)
      object.update_column(:position, index + 1) unless object.nil?
    end
    first_object.sync_with_git if first_object&.respond_to?(:sync_with_git)
    yield first_object if block_given?
  end

  protected

  def model
    self.class.to_s.remove('Admin::').remove('Controller').singularize.safe_constantize
  end
end
