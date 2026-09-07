json.parameters @picker.parameters
json.pagination @picker.pagination
json.results do
  json.classes 'row g-2 row-cols-1'
  json.list @picker.results do |post|
    l10n = post.localized_in(current_language)
    json.data do
      json.id post.id
    end
    json.snippet render(
        partial: 'admin/communication/websites/posts/post',
        locals: {
          post: post,
          website: @website,
          hide_badges: true
        },
        formats: [:html]
      )
  end
end