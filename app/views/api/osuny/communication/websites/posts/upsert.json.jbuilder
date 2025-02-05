json.created do
  json.partial! "api/osuny/communication/websites/posts/post", collection: @successfully_created_posts, as: :post
end
json.updated do
  json.partial! "api/osuny/communication/websites/posts/post", collection: @successfully_updated_posts, as: :post
end
json.errors do
  json.array! @invalid_posts_with_index do |invalid_post_with_index|
    json.index invalid_post_with_index[:index]
    json.errors invalid_post_with_index[:post].errors
  end
end