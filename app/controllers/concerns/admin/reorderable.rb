module Admin::Reorderable
  extend ActiveSupport::Concern

  included do
    def reorder
      ids = params[:ids]
      ids.each.with_index do |id, index|
        object = model.find_by(id: id)
        object.update_column(:position, index + 1) unless object.nil?
      end
    end

    def model
      self.class.to_s.remove('Admin::').remove('Controller').singularize.safe_constantize
    end
  end

end
