module Pathable
  extend ActiveSupport::Concern

  included do
    before_validation :make_path
    after_save :update_children_paths, if: :saved_change_to_path?

    def generated_path
      "#{parent.nil? ? '/' : parent.path}#{slug}/".gsub(/\/+/, '/')
    end

    def update_children_paths
      return unless respond_to?(:children)
      children.each do |child|
        child.update_column :path, child.generated_path
        child.update_children_paths
      end
    end

    protected

    def make_path
      return unless respond_to?(:path) && respond_to?(:parent)
      self.path = generated_path
    end

  end
end
