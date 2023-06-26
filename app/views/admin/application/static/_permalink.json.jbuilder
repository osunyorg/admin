json.url @about.current_permalink_in_website(@website)&.path

if @about.respond_to?(:slug) && @about.slug.present?
  forced_slug ||= nil
  json.slug (forced_slug || @about.slug)
end

previous_permalinks = @about.previous_permalinks_in_website(@website)
json.aliases previous_permalinks.collect(&:path) if previous_permalinks.any?
  