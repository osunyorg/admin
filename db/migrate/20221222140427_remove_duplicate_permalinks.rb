class RemoveDuplicatePermalinks < ActiveRecord::Migration[7.0]
  def change
    attributes = [:about_id, :about_type, :website_id, :path]
    duplicates_per_input = Communication::Website::Permalink.select(*attributes).group(*attributes).having("COUNT(*) > 1").size
    duplicates_per_input.keys.each do |key|
      about_id, about_type, website_id, path = key
      permalinks = Communication::Website::Permalink.where(about_id: about_id, about_type: about_type, website_id: website_id, path: path).order(:created_at)
      current_permalink = permalinks.detect(&:is_current?)
      if current_permalink.present?
        # Remove all non-current permalinks with this path
        permalinks.where(is_current: false).each(&:destroy)
      else
        # Remove all permalinks with this path except the most recent one
        permalinks.where.not(id: permalinks.last.id).each(&:destroy)
      end
    end
  end
end
